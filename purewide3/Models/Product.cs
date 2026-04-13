namespace PureWide3.Models;

/// <summary>Product — Git-backed JSON content model.</summary>
public sealed class Product
{
    public string Slug { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;

    /// <summary>Category slug: adultos-mayores | mascotas | ecologica | multiuso | bebes</summary>
    public string Category { get; set; } = string.Empty;

    public string ShortDescription { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public string ImageUrl { get; set; } = string.Empty;
    public string[] Features { get; set; } = Array.Empty<string>();
    public bool InStock { get; set; } = true;
}
