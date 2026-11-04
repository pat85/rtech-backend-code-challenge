using RTech.Api.Domain.Entities;
using RTech.Api.Domain.Interfaces;

namespace RTech.Api.Business;

public sealed class FinancialReportService(IFinancialReportRepository repository) : IFinancialReportService
{
    public Task<IReadOnlyList<FinancialReport>> GetDetailAsync(
        string shipCode, DateOnly period, CancellationToken cancellationToken)
    {
        Validate(shipCode, period);
        return repository.GetDetailAsync(shipCode.Trim(), period, cancellationToken);
    }

    public Task<IReadOnlyList<FinancialReport>> GetSummaryAsync(
        string shipCode, DateOnly period, CancellationToken cancellationToken)
    {
        Validate(shipCode, period);
        return repository.GetSummaryAsync(shipCode.Trim(), period, cancellationToken);
    }

    private static void Validate(string shipCode, DateOnly period)
    {
        if (string.IsNullOrWhiteSpace(shipCode)) throw new ArgumentException("Ship code is required.");
        if (period.Day != 1) throw new ArgumentException("Accounting period must be the first day of a month.");
    }
}
