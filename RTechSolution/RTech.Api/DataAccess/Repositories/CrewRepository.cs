using System.Data;
using Dapper;
using RTech.Api.DataAccess;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Entities;
using RTech.Api.Domain.Requests;

namespace RTech.Api.DataAccess.Repositories;

public sealed class CrewRepository(IDbConnectionFactory connectionFactory) : ICrewRepository
{
    public async Task<IReadOnlyList<CrewMember>> GetCrewListAsync(
        string shipCode, CrewSearchRequest request, CancellationToken cancellationToken)
    {
        using var connection = connectionFactory.CreateConnection();
        var command = new CommandDefinition("dbo.usp_GetCrewList", new
        {
            ShipCode = shipCode,
            request.PageNumber,
            request.PageSize,
            request.SortColumn,
            request.SortDirection,
            request.SearchTerm
            // @AsOfDate is intentionally omitted; SQL defaults it to today's date.
        }, commandType: CommandType.StoredProcedure, cancellationToken: cancellationToken);

        var rows = await connection.QueryAsync<CrewMember>(command);
        return rows.AsList();
    }
}
