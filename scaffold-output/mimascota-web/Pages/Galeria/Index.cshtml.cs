using Microsoft.AspNetCore.Mvc.RazorPages;
using MiMascota.Models;
using MiMascota.Services;

namespace MiMascota.Pages;

public class GaleriaModel : PageModel
{
    private readonly ContentService _content;

    public GaleriaModel(ContentService content) => _content = content;

    public IReadOnlyList<GalleryItem> Items { get; private set; } = Array.Empty<GalleryItem>();
    public IReadOnlyList<string> Lines { get; private set; } = Array.Empty<string>();

    public void OnGet()
    {
        var gallery = _content.GetGallery();
        Items = gallery?.Items ?? new List<GalleryItem>();
        Lines = Items
            .Where(i => !string.IsNullOrEmpty(i.Line))
            .Select(i => i.Line!)
            .Distinct()
            .ToList();
    }
}
