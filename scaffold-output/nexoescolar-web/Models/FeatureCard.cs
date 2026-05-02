namespace NexoEscolar.Models;

public class FeatureCard : IOrderedContent
{
    public int Order { get; set; }
    public string Title { get; set; } = "";
    public string Icon { get; set; } = "";
    public string Description { get; set; } = "";
    public string Span { get; set; } = "small";
}
