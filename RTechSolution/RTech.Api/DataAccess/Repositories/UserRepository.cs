using System.Data;
using Dapper;
using RTech.Api.DataAccess;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Entities;

namespace RTech.Api.DataAccess.Repositories;

public sealed class UserRepository(IDbConnectionFactory connectionFactory) : IUserRepository
{
    public async Task<User> AddAsync(User user, CancellationToken cancellationToken)
    {
        using var connection = connectionFactory.CreateConnection();
        var command = new CommandDefinition("dbo.usp_AddUser", new
        {
            user.Username,
            user.FullName,
            user.Role,
            user.Email
        }, commandType: CommandType.StoredProcedure, cancellationToken: cancellationToken);

        // usp_AddUser returns the newly created row, not a scalar ID.
        return await connection.QuerySingleAsync<User>(command);
    }

    public async Task<IReadOnlyList<User>> GetAllAsync(bool includeInactive, CancellationToken cancellationToken)
    {
        using var connection = connectionFactory.CreateConnection();
        var command = new CommandDefinition("dbo.usp_GetUsers", new { IncludeInactive = includeInactive },
            commandType: CommandType.StoredProcedure, cancellationToken: cancellationToken);
        var rows = await connection.QueryAsync<User>(command);
        return rows.AsList();
    }

    public async Task AssignShipAsync(int userId, int shipId, CancellationToken cancellationToken)
    {
        using var connection = connectionFactory.CreateConnection();
        var command = new CommandDefinition("dbo.usp_AssignShipToUser",
            new { UserId = userId, ShipId = shipId },
            commandType: CommandType.StoredProcedure, cancellationToken: cancellationToken);
        // The procedure is idempotent and returns the resulting assignment row.
        await connection.QuerySingleAsync(command);
    }

    public async Task<IReadOnlyList<Ship>> GetShipsAsync(
        int userId, bool includeInactiveShips, CancellationToken cancellationToken)
    {
        using var connection = connectionFactory.CreateConnection();
        var command = new CommandDefinition("dbo.usp_GetShipsByUser",
            new { UserId = userId, IncludeInactiveShips = includeInactiveShips },
            commandType: CommandType.StoredProcedure, cancellationToken: cancellationToken);
        var rows = await connection.QueryAsync<Ship>(command);
        return rows.AsList();
    }
}
