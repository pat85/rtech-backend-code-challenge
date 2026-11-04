namespace RTech.Api.Domain.Entities;

public sealed class CrewMember
{
    public string RankName { get; set; } = string.Empty;
    public string CrewMemberId { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public int Age { get; set; }
    public string Nationality { get; set; } = string.Empty;
    public DateTime SignOnDate { get; set; }
    public string Status { get; set; } = string.Empty;
    // usp_GetCrewList returns COUNT_BIG(*) OVER() for pagination metadata.
    public long TotalCount { get; set; }
}
