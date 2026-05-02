namespace NexoEscolar.Models;

public class FaqItem : IOrderedContent
{
    public int Order { get; set; }
    public string Question { get; set; } = "";
    public string Answer { get; set; } = "";
}
