using Microsoft.AspNetCore.Mvc.RazorPages;
using MiMascota.Models;
using MiMascota.Services;

namespace MiMascota.Pages.Productos;

public class IndexModel : PageModel
{
    private readonly ContentService _content;

    public IndexModel(ContentService content) => _content = content;

    public ProductLinesRoot? ProductLines { get; private set; }
    public IReadOnlyList<Product> Products { get; private set; } = Array.Empty<Product>();

    public void OnGet()
    {
        ProductLines = _content.GetProductLines();
        Products = _content.GetAllProducts();
    }
}
