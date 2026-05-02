namespace NexoEscolar.Models;

public class BeneficiosHub
{
    public string Headline { get; set; } = "";
    public string Subheadline { get; set; } = "";
    public List<RoleHub> Roles { get; set; } = new();
}
