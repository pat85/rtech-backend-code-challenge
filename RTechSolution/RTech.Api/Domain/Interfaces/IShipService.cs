using RTech.Api.Domain.Entities;
using RTech.Api.Domain.Requests;

namespace RTech.Api.Domain.Interfaces;

public interface IShipService
{
    Task<Ship> AddAsync(CreateShipRequest request, CancellationToken cancellationToken);
    Task<IReadOnlyList<Ship>> GetAllAsync(bool includeInactive, CancellationToken cancellationToken);
}
