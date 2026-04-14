using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MiMascota.Models;
using MiMascota.Services;

namespace MiMascota.Pages;

public class ContactoModel : PageModel
{
    private readonly ContentService _content;
    private readonly ILogger<ContactoModel> _logger;

    public ContactoModel(ContentService content, ILogger<ContactoModel> logger)
    {
        _content = content;
        _logger = logger;
    }

    public ContactConfig? Contact { get; private set; }

    public void OnGet()
    {
        Contact = _content.GetContactConfig();
    }

    public IActionResult OnPost(
        string name, string email, string message,
        string? reason = null)
    {
        if (string.IsNullOrWhiteSpace(name) ||
            string.IsNullOrWhiteSpace(email) ||
            string.IsNullOrWhiteSpace(message))
        {
            return BadRequest("Missing required fields");
        }

        // TODO (integrate-ui-component): wire email handler (Formspree or SendGrid Phase 2)
        _logger.LogInformation(
            "Contact form submission from {Email} — reason: {Reason}",
            email, reason ?? "not specified");

        if (Request.Headers["X-Requested-With"] == "XMLHttpRequest")
            return new OkResult();

        TempData["Success"] = true;
        return RedirectToPage();
    }
}
