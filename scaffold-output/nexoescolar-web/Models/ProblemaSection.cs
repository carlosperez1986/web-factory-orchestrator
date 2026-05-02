namespace NexoEscolar.Models;

public class ProblemaSection
{
    public string Headline { get; set; } = "";
    public List<PainPoint> Cards { get; set; } = new();
}
