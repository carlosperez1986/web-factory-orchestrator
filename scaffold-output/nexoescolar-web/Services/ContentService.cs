using Microsoft.Extensions.Caching.Memory;
using NexoEscolar.Models;
using System.Text.Json;

namespace NexoEscolar.Services;

/// NexoEscolar — Content Service
/// Reads JSON files from wwwroot/content/pages/ (singletons) and
/// wwwroot/content/collections/{name}/ (ordered folder collections)
/// Caches results in memory with 10-minute TTL
/// ── Do NOT modify — generated from WFO blueprint by project-scaffolding skill

public class ContentService
{
    private readonly IMemoryCache _cache;
    private readonly IWebHostEnvironment _env;
    private readonly ILogger<ContentService> _logger;
    private static readonly JsonSerializerOptions _jsonOptions = new()
    {
        PropertyNameCaseInsensitive = true
    };

    private const int CacheTtlMinutes = 10;

    public ContentService(IMemoryCache cache, IWebHostEnvironment env, ILogger<ContentService> logger)
    {
        _cache = cache;
        _env = env;
        _logger = logger;
    }

    // ── Singleton page loader ─────────────────────────────────────────────────
    // Reads: wwwroot/content/pages/{slug}.json
    public T? GetPage<T>(string slug) where T : class
    {
        var cacheKey = $"page_{slug}";
        return _cache.GetOrCreate<T?>(cacheKey, entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var filePath = Path.Combine(_env.WebRootPath, "content", "pages", $"{slug}.json");

            if (!File.Exists(filePath))
            {
                _logger.LogWarning("Page content file not found: {Path}", filePath);
                return null;
            }

            try
            {
                var json = File.ReadAllText(filePath);
                return JsonSerializer.Deserialize<T>(json, _jsonOptions);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error reading page content file: {Path}", filePath);
                return null;
            }
        });
    }

    // ── Folder collection loader ──────────────────────────────────────────────
    // Reads: wwwroot/content/collections/{name}/*.json sorted by "order" field
    public List<T> GetCollection<T>(string name) where T : class, IOrderedContent, new()
    {
        var cacheKey = $"collection_{name}";
        return _cache.GetOrCreate<List<T>>(cacheKey, entry =>
        {
            entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(CacheTtlMinutes);
            var items = new List<T>();
            var dirPath = Path.Combine(_env.WebRootPath, "content", "collections", name);

            if (!Directory.Exists(dirPath))
            {
                _logger.LogWarning("Collection directory not found: {Path}", dirPath);
                return items;
            }

            foreach (var file in Directory.EnumerateFiles(dirPath, "*.json").OrderBy(f => f))
            {
                try
                {
                    var json = File.ReadAllText(file);
                    var item = JsonSerializer.Deserialize<T>(json, _jsonOptions);
                    if (item is not null)
                        items.Add(item);
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error reading collection file: {File}", file);
                }
            }

            return items.OrderBy(i => i.Order).ToList();
        })!;
    }
}
