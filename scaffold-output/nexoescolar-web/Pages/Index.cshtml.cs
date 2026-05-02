using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using NexoEscolar.Models;
using NexoEscolar.Services;
using System.Text;
using System.Text.Json;

namespace NexoEscolar.Pages;

public class IndexModel : PageModel
{
    private readonly ContentService _content;
    private readonly IConfiguration _config;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly ILogger<IndexModel> _logger;

    public HeroBanner Hero { get; private set; } = new();
    public ProblemaSection Problema { get; private set; } = new();
    public List<FeatureCard> FeatureCards { get; private set; } = new();
    public BeneficiosHub Beneficios { get; private set; } = new();
    public AppShowcase App { get; private set; } = new();
    public TrustSection Trust { get; private set; } = new();
    public List<FaqItem> FaqItems { get; private set; } = new();
    public FooterContent Footer { get; private set; } = new();

    [BindProperty]
    public ContactFormModel Form { get; set; } = new();

    public bool FormSuccess { get; private set; }

    public IndexModel(
        ContentService content,
        IConfiguration config,
        IHttpClientFactory httpClientFactory,
        ILogger<IndexModel> logger)
    {
        _content = content;
        _config = config;
        _httpClientFactory = httpClientFactory;
        _logger = logger;
    }

    public void OnGet()
    {
        FormSuccess = Request.Query.ContainsKey("success");
        LoadContent();
    }

    public async Task<IActionResult> OnPostAsync()
    {
        LoadContent();

        if (!ModelState.IsValid)
            return Page();

        await DispatchLeadAsync();

        return RedirectToPage("/Index", null, "demo");
    }

    private void LoadContent()
    {
        Hero      = _content.GetPage<HeroBanner>("hero")         ?? new HeroBanner();
        Problema  = _content.GetPage<ProblemaSection>("problema") ?? new ProblemaSection();
        Beneficios= _content.GetPage<BeneficiosHub>("beneficios") ?? new BeneficiosHub();
        App       = _content.GetPage<AppShowcase>("app")          ?? new AppShowcase();
        Trust     = _content.GetPage<TrustSection>("trust")       ?? new TrustSection();
        Footer    = _content.GetPage<FooterContent>("footer")     ?? new FooterContent();

        FeatureCards = _content.GetCollection<FeatureCard>("funciones");
        FaqItems     = _content.GetCollection<FaqItem>("faq");
    }

    private async Task DispatchLeadAsync()
    {
        var webhookUrl = _config["NotificationWebhook"];
        if (string.IsNullOrWhiteSpace(webhookUrl))
        {
            _logger.LogInformation(
                "Lead received — no webhook configured. NombreCompleto={Nombre}, Colegio={Colegio}, Correo={Correo}",
                Form.NombreCompleto, Form.NombreColegio, Form.CorreoInstitucional);
            return;
        }

        try
        {
            var payload = JsonSerializer.Serialize(new
            {
                nombre_completo      = Form.NombreCompleto,
                nombre_colegio       = Form.NombreColegio,
                correo_institucional = Form.CorreoInstitucional,
                whatsapp             = Form.WhatsApp,
                timestamp            = DateTimeOffset.UtcNow.ToString("o")
            });

            using var http = _httpClientFactory.CreateClient();
            using var content = new StringContent(payload, Encoding.UTF8, "application/json");
            var response = await http.PostAsync(webhookUrl, content);

            if (!response.IsSuccessStatusCode)
                _logger.LogWarning("Webhook returned {Status}", (int)response.StatusCode);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error dispatching lead webhook");
        }
    }
}
