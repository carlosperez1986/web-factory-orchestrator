using Microsoft.AspNetCore.Mvc.RazorPages;
using MiMascota.Models;
using MiMascota.Services;

namespace MiMascota.Pages.Blog;

public class IndexModel : PageModel
{
    private readonly ContentService _content;

    public IndexModel(ContentService content) => _content = content;

    public IReadOnlyList<BlogPost> Posts { get; private set; } = Array.Empty<BlogPost>();
    public IReadOnlyList<string> Categories { get; private set; } = Array.Empty<string>();
    public string? ActiveCategory { get; private set; }

    public void OnGet(string? categoria = null)
    {
        ActiveCategory = categoria;
        var all = _content.GetBlogPosts();
        Categories = all.Select(p => p.Category).Distinct().OrderBy(c => c).ToList();
        Posts = string.IsNullOrEmpty(categoria)
            ? all
            : all.Where(p => p.Category == categoria).ToList();
    }
}
