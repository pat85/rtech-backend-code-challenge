using System.ComponentModel.DataAnnotations;

namespace RTech.Api.Domain.Requests;

public sealed class CrewSearchRequest
{
    [Range(1, int.MaxValue)]
    public int PageNumber { get; init; } = 1;

    [Range(1, 500)]
    public int PageSize { get; init; } = 20;

    [StringLength(30)]
    public string SortColumn { get; init; } = "RankName";

    [RegularExpression("^(?i:ASC|DESC)$", ErrorMessage = "SortDirection must be ASC or DESC.")]
    public string SortDirection { get; init; } = "ASC";

    [StringLength(100)]
    public string? SearchTerm { get; init; }
}
