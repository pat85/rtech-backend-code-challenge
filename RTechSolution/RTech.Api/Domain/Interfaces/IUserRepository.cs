using RTech.Api.Domain.Entities;

namespace RTech.Api.Domain.Interfaces;

public interface IUserRepository
{
    Task<User> AddAsync(User user, CancellationToken cancellationToken);
    Task<IReadOnlyList<User>> GetAllAsync(bool includeInactive, CancellationToken cancellationToken);
    Task AssignShipAsync(int userId, int shipId, CancellationToken cancellationToken);
    Task<IReadOnlyList<Ship>> GetShipsAsync(int userId, bool includeInactiveShips, CancellationToken cancellationToken);
}
