using Microsoft.AspNetCore.Mvc.RazorPages;
using MiMascota.Models;
using MiMascota.Services;

namespace MiMascota.Pages;

public class IndexModel : PageModel
{
    private readonly ContentService _content;

    public IndexModel(ContentService content) => _content = content;

    public HeroBanner? Hero { get; private set; }
    public ProductLinesRoot? ProductLines { get; private set; }
    public TestimonialsRoot? Testimonials { get; private set; }
    public IReadOnlyList<BlogPost> LatestPosts { get; private set; } = Array.Empty<BlogPost>();

    public void OnGet()
    {
        Hero = _content.GetHeroBanner();
        ProductLines = _content.GetProductLines();
        Testimonials = _content.GetTestimonials();
        LatestPosts = _content.GetBlogPosts().Take(3).ToList();

        ViewData["SeoDescription"] = Hero?.Subtitle
            ?? "Toallitas biodegradables con ingredientes 100% seguros para perros y gatos.";
    }
}
