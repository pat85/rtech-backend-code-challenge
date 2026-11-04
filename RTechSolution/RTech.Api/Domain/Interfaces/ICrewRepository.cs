using RTech.Api.Domain.Entities;
using RTech.Api.Domain.Requests;

namespace RTech.Api.Domain.Interfaces;

public interface ICrewRepository
{
    Task<IReadOnlyList<CrewMember>> GetCrewListAsync(
        string shipCode, CrewSearchRequest request, CancellationToken cancellationToken);
}
