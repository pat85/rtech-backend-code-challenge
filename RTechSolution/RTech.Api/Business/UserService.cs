using RTech.Api.Domain.Entities;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Requests;

namespace RTech.Api.Business;

public sealed class UserService(IUserRepository repository) : IUserService
{
    public Task<User> AddAsync(CreateUserRequest request, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(request);
        if (string.IsNullOrWhiteSpace(request.Username)) throw new ArgumentException("Username is required.");
        if (string.IsNullOrWhiteSpace(request.FullName)) throw new ArgumentException("Full name is required.");
        if (string.IsNullOrWhiteSpace(request.Role)) throw new ArgumentException("Role is required.");

        return repository.AddAsync(new User
        {
            Username = request.Username.Trim(),
            FullName = request.FullName.Trim(),
            Email = string.IsNullOrWhiteSpace(request.Email) ? null : request.Email.Trim(),
            Role = request.Role.Trim(),
            IsActive = true
        }, cancellationToken);
    }

    public Task<IReadOnlyList<User>> GetAllAsync(bool includeInactive, CancellationToken cancellationToken)
        => repository.GetAllAsync(includeInactive, cancellationToken);

    public Task AssignShipAsync(int userId, int shipId, CancellationToken cancellationToken)
    {
        if (userId <= 0) throw new ArgumentOutOfRangeException(nameof(userId), "User ID must be positive.");
        if (shipId <= 0) throw new ArgumentOutOfRangeException(nameof(shipId), "Ship ID must be positive.");
        return repository.AssignShipAsync(userId, shipId, cancellationToken);
    }

    public Task<IReadOnlyList<Ship>> GetShipsAsync(
        int userId, bool includeInactiveShips, CancellationToken cancellationToken)
    {
        if (userId <= 0) throw new ArgumentOutOfRangeException(nameof(userId), "User ID must be positive.");
        return repository.GetShipsAsync(userId, includeInactiveShips, cancellationToken);
    }
}
