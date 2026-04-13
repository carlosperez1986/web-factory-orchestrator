using Microsoft.AspNetCore.Mvc.RazorPages;
using PureWide3.Models;
using PureWide3.Services;

namespace PureWide3.Pages;

public class IndexModel : PageModel
{
    private readonly IContentService _content;

    public Dictionary<string, List<Product>> ProductsByCategory { get; private set; } = new();
    public IReadOnlyList<BlogPost> LatestPosts { get; private set; } = Array.Empty<BlogPost>();

    public IndexModel(IContentService content)
    {
        _content = content;
    }

    public void OnGet()
    {
        var allProducts = _content.GetCollection<Product>("products");

        ProductsByCategory = allProducts
            .GroupBy(p => p.Category)
            .ToDictionary(g => g.Key, g => g.ToList());

        LatestPosts = _content.GetBlogPosts().Take(3).ToList();
    }
}
