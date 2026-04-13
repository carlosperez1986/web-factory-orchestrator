// PureWide3 — Content Service
// Stack  : .NET 9 · Razor Pages · Git-backed JSON/MD content layer (no EF, no DB)
// Source : blueprints/code/Services/ContentService.cs.template

using Markdig;
using Microsoft.Extensions.Caching.Memory;
using PureWide3.Models;
using System.Text.Json;
using System.Text.Json.Serialization;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;

namespace PureWide3.Services;

/// <summary>Contract for Git-backed content access.</summary>
public interface IContentService
{
    T? GetPage<T>(string slug) where T : class;
    IReadOnlyList<T> GetCollection<T>(string collectionName) where T : class;
    IReadOnlyList<BlogPost> GetBlogPosts();
    BlogPost? GetPostBySlug(string slug);
}

/// <summary>
/// Reads JSON and Markdown files from wwwroot/content/.
/// Caches content in-memory. No database, no ORM.
/// </summary>
public sealed class JsonContentService : IContentService
{
    private readonly IMemoryCache _cache;
    private readonly IWebHostEnvironment _env;
    private readonly ILogger<JsonContentService> _logger;
    private readonly MarkdownPipeline _markdownPipeline;
    private readonly IDeserializer _yamlDeserializer;

    private static readonly JsonSerializerOptions _jsonOptions = new()
    {
        PropertyNameCaseInsensitive = true,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
        ReadCommentHandling = JsonCommentHandling.Skip,
        AllowTrailingCommas = true
    };

    private const int CacheTtlMinutes = 60;

    public JsonContentService(IMemoryCache cache, IWebHostEnvironment env, ILogger<JsonContentService> logger)
    {
        _cache = cache;
        _env = env;
        _logger = logger;
        _markdownPipeline = new MarkdownPipelineBuilder().UseAdvancedExtensions().Build();
        _yamlDeserializer = new DeserializerBuilder()
            .WithNamingConvention(UnderscoredNamingConvention.Instance)
            .IgnoreUnmatchedProperties()
            .Build();
    }

    /// <inheritdoc/>
    public T? GetPage<T>(string slug) where T : class
    {
        var cacheKey = $"page_{slug}";
        return _cache.GetOrCreate(cacheKey, entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var filePath = Path.Combine(_env.WebRootPath, "content", "pages", $"{slug}.json");
            if (!File.Exists(filePath)) return null;
            var json = File.ReadAllText(filePath);
            return JsonSerializer.Deserialize<T>(json, _jsonOptions);
        });
    }

    /// <inheritdoc/>
    public IReadOnlyList<T> GetCollection<T>(string collectionName) where T : class
    {
        var cacheKey = $"collection_{collectionName}";
        return _cache.GetOrCreate(cacheKey, entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var folder = Path.Combine(_env.WebRootPath, "content", collectionName);
            if (!Directory.Exists(folder)) return Array.Empty<T>();

            var results = new List<T>();
            foreach (var file in Directory.EnumerateFiles(folder, "*.json", SearchOption.TopDirectoryOnly))
            {
                try
                {
                    var item = JsonSerializer.Deserialize<T>(File.ReadAllText(file), _jsonOptions);
                    if (item is not null) results.Add(item);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error reading collection file: {File}", file);
                }
            }
            return results.AsReadOnly();
        })!;
    }

    /// <inheritdoc/>
    public IReadOnlyList<BlogPost> GetBlogPosts()
    {
        return _cache.GetOrCreate("blogposts", entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var folder = Path.Combine(_env.WebRootPath, "content", "blog");
            if (!Directory.Exists(folder)) return new List<BlogPost>();

            var posts = new List<BlogPost>();
            foreach (var file in Directory.EnumerateFiles(folder, "*.md"))
            {
                try
                {
                    var post = ParseMarkdownFile(file);
                    if (post is not null) posts.Add(post);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error reading blog post: {File}", file);
                }
            }
            return posts.OrderByDescending(p => p.Date).ToList();
        })!;
    }

    /// <inheritdoc/>
    public BlogPost? GetPostBySlug(string slug)
    {
        var cacheKey = $"blogpost_{slug}";
        return _cache.GetOrCreate(cacheKey, entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var file = Path.Combine(_env.WebRootPath, "content", "blog", $"{slug}.md");
            return File.Exists(file) ? ParseMarkdownFile(file) : null;
        });
    }

    private BlogPost? ParseMarkdownFile(string filePath)
    {
        var rawContent = File.ReadAllText(filePath);
        var slug = Path.GetFileNameWithoutExtension(filePath);

        string frontmatterYaml = string.Empty;
        string markdownBody = rawContent;

        if (rawContent.StartsWith("---"))
        {
            var endIndex = rawContent.IndexOf("---", 3);
            if (endIndex > 0)
            {
                frontmatterYaml = rawContent[3..endIndex].Trim();
                markdownBody = rawContent[(endIndex + 3)..].Trim();
            }
        }

        var frontmatter = new Dictionary<string, string>();
        if (!string.IsNullOrEmpty(frontmatterYaml))
        {
            frontmatter = _yamlDeserializer.Deserialize<Dictionary<string, string>>(frontmatterYaml)
                          ?? new Dictionary<string, string>();
        }

        frontmatter.TryGetValue("title", out var title);
        frontmatter.TryGetValue("date", out var dateStr);
        frontmatter.TryGetValue("image", out var image);
        frontmatter.TryGetValue("seo_description", out var seoDescription);
        frontmatter.TryGetValue("category", out var category);

        DateTime.TryParse(dateStr, out var date);

        return new BlogPost
        {
            Slug = slug,
            Title = title ?? slug,
            Date = date,
            Image = image ?? string.Empty,
            SeoDescription = seoDescription ?? string.Empty,
            Category = category ?? string.Empty,
            ContentHtml = Markdown.ToHtml(markdownBody, _markdownPipeline)
        };
    }
}
