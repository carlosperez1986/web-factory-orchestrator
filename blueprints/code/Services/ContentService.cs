// ContentService.cs — WFO Blueprint
// Stack  : .NET 9 · Razor Pages · Git-backed JSON content layer (no EF, no DB)
// Source : blueprints/code/Services/ContentService.cs
//
// Substitutions applied by project-scaffolding skill:
//   {{PROJECT_NAME}} → Pascal-cased namespace  e.g. PureWipe
//
// This file is intentionally free of project-specific logic.
// The content-service-and-data-wiring skill adds model-specific GetXxx() methods
// on top of the generic GetPage<T>() and GetCollection<T>() primitives below.
// ─────────────────────────────────────────────────────────────────────────────

using System.Text.Json;
using System.Text.Json.Serialization;

namespace {{PROJECT_NAME}}.Services;

/// <summary>
/// Reads Git-backed JSON files from wwwroot/content/.
/// No database, no ORM — content lives in the repository alongside code.
/// </summary>
public interface IContentService
{
    /// <summary>Returns a single-page JSON document deserialized as T.</summary>
    T? GetPage<T>(string slug) where T : class;

    /// <summary>Returns all items in a content collection folder.</summary>
    IReadOnlyList<T> GetCollection<T>(string collectionName) where T : class;
}

public sealed class JsonContentService : IContentService
{
    private readonly string _contentRoot;

    // JsonSerializerOptions are shared to avoid repeated allocations.
    private static readonly JsonSerializerOptions _options = new()
    {
        PropertyNameCaseInsensitive = true,
        DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull,
        ReadCommentHandling = JsonCommentHandling.Skip,
        AllowTrailingCommas = true
    };

    public JsonContentService(IWebHostEnvironment env)
    {
        // Content lives at wwwroot/content — tracked by Git, managed by Decap CMS.
        _contentRoot = Path.Combine(env.WebRootPath, "content");
    }

    /// <inheritdoc/>
    public T? GetPage<T>(string slug) where T : class
    {
        // slug examples: "inicio", "nosotros", "contacto"
        // file path:     wwwroot/content/pages/{slug}.json
        var filePath = Path.Combine(_contentRoot, "pages", $"{slug}.json");

        if (!File.Exists(filePath))
            return null;

        var json = File.ReadAllText(filePath);
        return JsonSerializer.Deserialize<T>(json, _options);
    }

    /// <inheritdoc/>
    public IReadOnlyList<T> GetCollection<T>(string collectionName) where T : class
    {
        // collectionName examples: "products", "posts", "team"
        // folder path:    wwwroot/content/{collectionName}/
        var folder = Path.Combine(_contentRoot, collectionName);

        if (!Directory.Exists(folder))
            return Array.Empty<T>();

        var results = new List<T>();

        foreach (var file in Directory.EnumerateFiles(folder, "*.json", SearchOption.TopDirectoryOnly))
        {
            var json = File.ReadAllText(file);
            var item = JsonSerializer.Deserialize<T>(json, _options);
            if (item is not null)
                results.Add(item);
        }

        return results.AsReadOnly();
    }
}
