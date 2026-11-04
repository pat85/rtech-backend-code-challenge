using System.Data;
using Dapper;
using RTech.Api.DataAccess;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Entities;

namespace RTech.Api.DataAccess.Repositories;

public sealed class FinancialReportRepository(IDbConnectionFactory connectionFactory)
    : IFinancialReportRepository
{
    public Task<IReadOnlyList<FinancialReport>> GetDetailAsync(
        string shipCode, DateOnly period, CancellationToken cancellationToken)
        => ExecuteAsync("dbo.usp_GetFinancialReportDetail", shipCode, period, cancellationToken);

    public Task<IReadOnlyList<FinancialReport>> GetSummaryAsync(
        string shipCode, DateOnly period, CancellationToken cancellationToken)
        => ExecuteAsync("dbo.usp_GetFinancialReportSummary", shipCode, period, cancellationToken);

    private async Task<IReadOnlyList<FinancialReport>> ExecuteAsync(
        string procedure, string shipCode, DateOnly period, CancellationToken cancellationToken)
    {
        using var connection = connectionFactory.CreateConnection();
        var command = new CommandDefinition(procedure, new
        {
            ShipCode = shipCode,
            AccountingPeriod = period.ToDateTime(TimeOnly.MinValue)
        }, commandType: CommandType.StoredProcedure, cancellationToken: cancellationToken);

        var rows = await connection.QueryAsync<FinancialReport>(command);
        return rows.AsList();
    }
}
