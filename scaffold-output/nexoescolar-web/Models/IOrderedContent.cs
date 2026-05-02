namespace NexoEscolar.Models;

/// Marker interface for ordered collection items (used by ContentService.GetCollection<T>)
public interface IOrderedContent
{
    int Order { get; }
}
