using RTech.Api.Domain.Entities;
using RTech.Api.Domain.Requests;

namespace RTech.Api.Domain.Interfaces;

public interface IUserService
{
    Task<User> AddAsync(CreateUserRequest request, CancellationToken cancellationToken);
    Task<IReadOnlyList<User>> GetAllAsync(bool includeInactive, CancellationToken cancellationToken);
    Task AssignShipAsync(int userId, int shipId, CancellationToken cancellationToken);
    Task<IReadOnlyList<Ship>> GetShipsAsync(int userId, bool includeInactiveShips, CancellationToken cancellationToken);
}
