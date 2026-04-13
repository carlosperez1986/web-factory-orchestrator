namespace PureWide3.Models;

/// <summary>BlogPost — parsed from YAML-frontmatter Markdown files in wwwroot/content/blog/.</summary>
public sealed class BlogPost
{
    public string Slug { get; set; } = string.Empty;
    public string Title { get; set; } = string.Empty;
    public DateTime Date { get; set; }
    public string Image { get; set; } = string.Empty;
    public string SeoDescription { get; set; } = string.Empty;
    public string Category { get; set; } = string.Empty;

    /// <summary>Rendered HTML body (from Markdown). Empty for list views.</summary>
    public string ContentHtml { get; set; } = string.Empty;
}
