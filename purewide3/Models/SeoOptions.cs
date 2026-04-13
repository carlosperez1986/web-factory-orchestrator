namespace PureWide3.Models;

/// <summary>SEO configuration options — bound from appsettings.json "Seo" section.</summary>
public sealed class SeoOptions
{
    public string SiteName { get; set; } = "Pure Wipe 3.0";
    public string BaseUrl { get; set; } = string.Empty;
    public string DefaultDescription { get; set; } = string.Empty;
}
