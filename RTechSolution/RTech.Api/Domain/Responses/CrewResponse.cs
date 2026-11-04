using RTech.Api.Domain.Entities;

namespace RTech.Api.Domain.Responses;

public sealed record CrewResponse(
    string RankName, string CrewMemberId, string FirstName, string LastName,
    int Age, string Nationality, DateTime SignOnDate, string Status)
{
    public static CrewResponse From(CrewMember crew) => new(
        crew.RankName, crew.CrewMemberId, crew.FirstName, crew.LastName,
        crew.Age, crew.Nationality, crew.SignOnDate, crew.Status);
}

public sealed record PagedResponse<T>(
    IReadOnlyList<T> Items, int PageNumber, int PageSize, long TotalCount);
