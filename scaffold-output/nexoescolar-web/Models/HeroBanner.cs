namespace NexoEscolar.Models;

public class HeroBanner
{
    public string Headline { get; set; } = "";
    public string Subheadline { get; set; } = "";
    public string CtaLabel { get; set; } = "Quiero mi demo";
    public string CtaHref { get; set; } = "#demo";
    public List<DashboardChip> DashboardChips { get; set; } = new();
    public string PhoneNotification { get; set; } = "";
}
