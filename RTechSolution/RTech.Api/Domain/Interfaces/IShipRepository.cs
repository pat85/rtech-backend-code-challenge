using RTech.Api.Domain.Entities;

namespace RTech.Api.Domain.Interfaces;

public interface IShipRepository
{
    Task<Ship> AddAsync(Ship ship, CancellationToken cancellationToken);
    Task<IReadOnlyList<Ship>> GetAllAsync(bool includeInactive, CancellationToken cancellationToken);
}
