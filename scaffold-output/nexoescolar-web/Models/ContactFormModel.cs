using System.ComponentModel.DataAnnotations;

namespace NexoEscolar.Models;

public class ContactFormModel
{
    [Required(ErrorMessage = "El nombre completo es obligatorio.")]
    [MaxLength(120)]
    public string NombreCompleto { get; set; } = "";

    [Required(ErrorMessage = "El nombre del colegio es obligatorio.")]
    [MaxLength(120)]
    public string NombreColegio { get; set; } = "";

    [Required(ErrorMessage = "El correo institucional es obligatorio.")]
    [EmailAddress(ErrorMessage = "Ingresa un correo electrónico válido.")]
    [MaxLength(200)]
    public string CorreoInstitucional { get; set; } = "";

    [Required(ErrorMessage = "El número de WhatsApp es obligatorio.")]
    [Phone(ErrorMessage = "Ingresa un número de teléfono válido.")]
    [MaxLength(20)]
    public string WhatsApp { get; set; } = "";
}
