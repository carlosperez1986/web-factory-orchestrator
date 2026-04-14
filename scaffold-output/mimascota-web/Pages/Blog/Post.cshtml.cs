using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MiMascota.Models;
using MiMascota.Services;

namespace MiMascota.Pages.Blog;

public class PostModel : PageModel
{
    private readonly ContentService _content;

    public PostModel(ContentService content) => _content = content;

    public BlogPost? Post { get; private set; }
    public Product? RelatedProduct { get; private set; }

    public IActionResult OnGet(string slug)
    {
        Post = _content.GetBlogPost(slug);
        if (Post is null)
            return Page();

        if (!string.IsNullOrEmpty(Post.RelatedProduct))
            RelatedProduct = _content.GetProduct(Post.RelatedProduct);

        return Page();
    }
}
