namespace NexoEscolar.Models;

public class AppShowcase
{
    public string Headline { get; set; } = "";
    public string Subheadline { get; set; } = "";
    public List<string> Highlights { get; set; } = new();
    public List<AppNotification> Notifications { get; set; } = new();
}
