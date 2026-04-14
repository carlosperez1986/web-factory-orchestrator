// MiMascota — ContentService
// Stack  : .NET 9 · Razor Pages · Git-backed JSON/MD content layer (no DB, no ORM)
// Source : blueprints/code/Services/ContentService.cs.template
// Tokens : PROJECT_NAME=MiMascota  CACHE_TTL_MINUTES=10
// ─────────────────────────────────────────────────────────────────────────────
// Generic primitives are defined here (blueprint layer).
// Project-specific Get*() methods are added by content-service-and-data-wiring skill.
// ─────────────────────────────────────────────────────────────────────────────

using Markdig;
using Microsoft.Extensions.Caching.Memory;
using MiMascota.Models;
using System.Text.Json;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;

namespace MiMascota.Services;

/// <summary>
/// Reads Git-backed JSON and Markdown files from wwwroot/content/.
/// No database, no ORM — content lives in the repository alongside code.
/// All results are cached in memory with a 10-minute TTL.
/// </summary>
public class ContentService
{
    private readonly IMemoryCache _cache;
    private readonly IWebHostEnvironment _env;
    private readonly ILogger<ContentService> _logger;
    private readonly MarkdownPipeline _markdownPipeline;
    private readonly IDeserializer _yamlDeserializer;
    private static readonly JsonSerializerOptions _jsonOptions = new()
    {
        PropertyNameCaseInsensitive = true,
        AllowTrailingCommas = true,
        ReadCommentHandling = JsonCommentHandling.Skip
    };

    private const int CacheTtlMinutes = 10;

    public ContentService(IMemoryCache cache, IWebHostEnvironment env, ILogger<ContentService> logger)
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

    // ── Generic single-file (singleton) loader ────────────────────────────────
    /// <summary>Reads and deserializes a single JSON file from wwwroot/content/{slug}.json</summary>
    public T? GetPage<T>(string slug) where T : class
    {
        var cacheKey = $"page_{slug}";
        return _cache.GetOrCreate<T?>(cacheKey, entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var filePath = Path.Combine(_env.WebRootPath, "content", $"{slug}.json");
            if (!File.Exists(filePath))
            {
                _logger.LogWarning("Content file not found: {Path}", filePath);
                return null;
            }
            try
            {
                var json = File.ReadAllText(filePath);
                return JsonSerializer.Deserialize<T>(json, _jsonOptions);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error reading content file: {Path}", filePath);
                return null;
            }
        });
    }

    // ── Generic collection (folder) loader ───────────────────────────────────
    /// <summary>Reads all *.json files from wwwroot/content/{collectionName}/</summary>
    public IReadOnlyList<T> GetCollection<T>(string collectionName) where T : class
    {
        var cacheKey = $"collection_{collectionName}";
        return _cache.GetOrCreate<IReadOnlyList<T>>(cacheKey, entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var items = new List<T>();
            var folder = Path.Combine(_env.WebRootPath, "content", collectionName);
            if (!Directory.Exists(folder))
            {
                _logger.LogWarning("Collection folder not found: {Path}", folder);
                return items.AsReadOnly();
            }
            foreach (var file in Directory.EnumerateFiles(folder, "*.json", SearchOption.TopDirectoryOnly))
            {
                try
                {
                    var json = File.ReadAllText(file);
                    var item = JsonSerializer.Deserialize<T>(json, _jsonOptions);
                    if (item is not null) items.Add(item);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error reading collection file: {File}", file);
                }
            }
            return items.AsReadOnly();
        })!;
    }

    // ── Blog posts (Markdown + YAML frontmatter) ──────────────────────────────
    /// <summary>Returns all blog posts sorted by date descending.</summary>
    public IReadOnlyList<BlogPost> GetBlogPosts()
    {
        return _cache.GetOrCreate<IReadOnlyList<BlogPost>>("blogposts", entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var posts = new List<BlogPost>();
            var folder = Path.Combine(_env.WebRootPath, "content", "blog");
            if (!Directory.Exists(folder))
            {
                _logger.LogWarning("Blog folder not found: {Path}", folder);
                return posts.AsReadOnly();
            }
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
            return posts.OrderByDescending(p => p.Date).ToList().AsReadOnly();
        })!;
    }

    /// <summary>Returns a single blog post by slug, or null if not found.</summary>
    public BlogPost? GetBlogPost(string slug)
    {
        var cacheKey = $"blogpost_{slug}";
        return _cache.GetOrCreate<BlogPost?>(cacheKey, entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var file = Path.Combine(_env.WebRootPath, "content", "blog", $"{slug}.md");
            return File.Exists(file) ? ParseMarkdownFile(file) : null;
        });
    }

    private BlogPost? ParseMarkdownFile(string filePath)
    {
        var raw = File.ReadAllText(filePath);
        var slug = Path.GetFileNameWithoutExtension(filePath);
        string frontmatterYaml = string.Empty;
        string markdownBody = raw;

        if (raw.StartsWith("---"))
        {
            var endIdx = raw.IndexOf("---", 3);
            if (endIdx > 0)
            {
                frontmatterYaml = raw[3..endIdx].Trim();
                markdownBody = raw[(endIdx + 3)..].Trim();
            }
        }

        var fm = new Dictionary<string, string>();
        if (!string.IsNullOrEmpty(frontmatterYaml))
        {
            fm = _yamlDeserializer.Deserialize<Dictionary<string, string>>(frontmatterYaml)
                 ?? new Dictionary<string, string>();
        }

        fm.TryGetValue("title", out var title);
        fm.TryGetValue("date", out var dateStr);
        fm.TryGetValue("featured_image", out var featuredImage);
        fm.TryGetValue("excerpt", out var excerpt);
        fm.TryGetValue("category", out var category);
        fm.TryGetValue("related_product", out var relatedProduct);

        DateTime.TryParse(dateStr, out var date);
        var bodyHtml = Markdown.ToHtml(markdownBody, _markdownPipeline);

        return new BlogPost
        {
            Slug = slug,
            Title = title ?? slug,
            Date = date,
            FeaturedImage = featuredImage ?? string.Empty,
            Excerpt = excerpt ?? string.Empty,
            Category = category ?? string.Empty,
            RelatedProduct = relatedProduct,
            BodyHtml = bodyHtml
        };
    }

    // ── Project-specific typed accessors (stubs — wired by content-service-and-data-wiring) ──
    // These methods delegate to the generic primitives above.
    // Full implementation (error handling, fallbacks) is added in the next skill.

    public HeroBanner? GetHeroBanner() => GetPage<HeroBanner>("hero");

    public ProductLinesRoot? GetProductLines() => GetPage<ProductLinesRoot>("product-lines");

    public Product? GetProduct(string slug)
    {
        var cacheKey = $"product_{slug}";
        return _cache.GetOrCreate<Product?>(cacheKey, entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var file = Path.Combine(_env.WebRootPath, "content", "products", $"{slug}.json");
            if (!File.Exists(file)) return null;
            try
            {
                var json = File.ReadAllText(file);
                return JsonSerializer.Deserialize<Product>(json, _jsonOptions);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error reading product: {File}", file);
                return null;
            }
        });
    }

    public IReadOnlyList<Product> GetAllProducts() => GetCollection<Product>("products");

    public BrandAbout? GetAbout() => GetPage<BrandAbout>("about");

    public GalleryRoot? GetGallery() => GetPage<GalleryRoot>("gallery");

    public ContactConfig? GetContactConfig() => GetPage<ContactConfig>("contact");

    public TestimonialsRoot? GetTestimonials() => GetPage<TestimonialsRoot>("testimonials");

    public LegalContent? GetLegalContent() => GetPage<LegalContent>("legal");
}
