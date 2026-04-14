using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MiMascota.Models;
using MiMascota.Services;

namespace MiMascota.Pages.Productos;

public class DetalleModel : PageModel
{
    private readonly ContentService _content;

    public DetalleModel(ContentService content) => _content = content;

    public Product? Product { get; private set; }
    public IReadOnlyList<Product> RelatedProducts { get; private set; } = Array.Empty<Product>();

    public IActionResult OnGet(string slug)
    {
        Product = _content.GetProduct(slug);
        if (Product is null)
            return Page();

        if (Product.RelatedProducts?.Any() == true)
        {
            var all = _content.GetAllProducts();
            RelatedProducts = all
                .Where(p => Product.RelatedProducts.Contains(p.Slug))
                .ToList();
        }

        ViewData["Title"] = Product.Name;
        ViewData["SeoDescription"] = Product.Description;
        return Page();
    }
}
