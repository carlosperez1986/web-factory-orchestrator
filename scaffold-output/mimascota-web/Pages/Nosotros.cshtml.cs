using Microsoft.AspNetCore.Mvc.RazorPages;
using MiMascota.Models;
using MiMascota.Services;

namespace MiMascota.Pages;

public class NosotrosModel : PageModel
{
    private readonly ContentService _content;

    public NosotrosModel(ContentService content) => _content = content;

    public BrandAbout? About { get; private set; }

    public void OnGet()
    {
        About = _content.GetAbout();
    }
}
