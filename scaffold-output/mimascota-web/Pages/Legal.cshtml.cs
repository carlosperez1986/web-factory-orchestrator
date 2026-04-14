using Markdig;
using Microsoft.AspNetCore.Mvc.RazorPages;
using MiMascota.Models;
using MiMascota.Services;

namespace MiMascota.Pages;

public class LegalModel : PageModel
{
    private readonly ContentService _content;
    private static readonly MarkdownPipeline _pipeline =
        new MarkdownPipelineBuilder().UseAdvancedExtensions().Build();

    public LegalModel(ContentService content) => _content = content;

    public LegalContent? Legal { get; private set; }
    public string TermsHtml { get; private set; } = string.Empty;
    public string PrivacyHtml { get; private set; } = string.Empty;
    public string ReturnsHtml { get; private set; } = string.Empty;
    public string? FiscalHtml { get; private set; }

    public void OnGet()
    {
        Legal = _content.GetLegalContent();
        if (Legal is null) return;

        TermsHtml = Markdown.ToHtml(Legal.Terms, _pipeline);
        PrivacyHtml = Markdown.ToHtml(Legal.Privacy, _pipeline);
        ReturnsHtml = Markdown.ToHtml(Legal.Returns, _pipeline);
        FiscalHtml = Legal.FiscalInfo is not null
            ? Markdown.ToHtml(Legal.FiscalInfo, _pipeline)
            : null;
    }
}
