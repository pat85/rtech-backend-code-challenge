using RTech.Api.Domain.Entities;

namespace RTech.Api.Domain.Interfaces;

public interface IFinancialReportRepository
{
    Task<IReadOnlyList<FinancialReport>> GetDetailAsync(
        string shipCode, DateOnly period, CancellationToken cancellationToken);
    Task<IReadOnlyList<FinancialReport>> GetSummaryAsync(
        string shipCode, DateOnly period, CancellationToken cancellationToken);
}
