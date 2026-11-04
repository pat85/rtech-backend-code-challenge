using System.Data;
using Dapper;
using RTech.Api.DataAccess;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Entities;

namespace RTech.Api.DataAccess.Repositories;

public sealed class ShipRepository(IDbConnectionFactory connectionFactory) : IShipRepository
{
    public async Task<Ship> AddAsync(Ship ship, CancellationToken cancellationToken)
    {
        using var connection = connectionFactory.CreateConnection();
        var command = new CommandDefinition("dbo.usp_AddShip", new
        {
            ship.ShipCode,
            ship.ShipName,
            ship.FiscalYearStartMonth,
            ship.FiscalYearEndMonth,
            IsActive = ship.IsActive
        }, commandType: CommandType.StoredProcedure, cancellationToken: cancellationToken);

        return await connection.QuerySingleAsync<Ship>(command);
    }

    public async Task<IReadOnlyList<Ship>> GetAllAsync(bool includeInactive, CancellationToken cancellationToken)
    {
        using var connection = connectionFactory.CreateConnection();
        var command = new CommandDefinition("dbo.usp_GetShips", new { IncludeInactive = includeInactive },
            commandType: CommandType.StoredProcedure, cancellationToken: cancellationToken);
        var rows = await connection.QueryAsync<Ship>(command);
        return rows.AsList();
    }
}
