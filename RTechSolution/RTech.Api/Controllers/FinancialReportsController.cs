using System.Globalization;
using Microsoft.AspNetCore.Mvc;
using RTech.Api.Domain.Interfaces;

namespace RTech.Api.Controllers;

[ApiController]
[Route("api/ships/{shipCode}/financial-reports")]
public sealed class FinancialReportsController(IFinancialReportService service) : ControllerBase
{
    [HttpGet("detail")]
    public async Task<IActionResult> GetDetail(
        string shipCode, [FromQuery] string period, CancellationToken cancellationToken)
    {
        var accountingPeriod = ParsePeriod(period);
        return Ok(await service.GetDetailAsync(shipCode, accountingPeriod, cancellationToken));
    }

    [HttpGet("summary")]
    public async Task<IActionResult> GetSummary(
        string shipCode, [FromQuery] string period, CancellationToken cancellationToken)
    {
        var accountingPeriod = ParsePeriod(period);
        return Ok(await service.GetSummaryAsync(shipCode, accountingPeriod, cancellationToken));
    }

    private static DateOnly ParsePeriod(string? period)
    {
        if (string.IsNullOrWhiteSpace(period) ||
            !DateOnly.TryParseExact(period + "-01", "yyyy-MM-dd", CultureInfo.InvariantCulture,
                DateTimeStyles.None, out var value))
        {
            throw new ArgumentException("Period is required and must use yyyy-MM format, e.g. 2025-01.");
        }

        return value;
    }
}
