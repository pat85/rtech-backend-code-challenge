using Moq;
using RTech.Api.Business;
using RTech.Api.Domain.Interfaces;

namespace RTech.Tests.Services;

public sealed class FinancialReportServiceTests
{
    [Fact]
    public async Task GetDetailAsync_RejectsNonFirstDayPeriod()
    {
        var service = new FinancialReportService(Mock.Of<IFinancialReportRepository>());
        await Assert.ThrowsAsync<ArgumentException>(() =>
            service.GetDetailAsync("SHIP01", new DateOnly(2025, 1, 15), CancellationToken.None));
    }

    [Fact]
    public async Task GetDetailAsync_RejectsBlankShipCode()
    {
        var service = new FinancialReportService(Mock.Of<IFinancialReportRepository>());
        await Assert.ThrowsAsync<ArgumentException>(() =>
            service.GetDetailAsync(" ", new DateOnly(2025, 1, 1), CancellationToken.None));
    }
}
