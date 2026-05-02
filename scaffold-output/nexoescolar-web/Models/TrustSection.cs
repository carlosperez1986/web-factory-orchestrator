namespace NexoEscolar.Models;

public class TrustSection
{
    public string Headline { get; set; } = "";
    public List<TrustBlock> Blocks { get; set; } = new();
}
