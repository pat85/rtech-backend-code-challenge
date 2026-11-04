using Moq;
using RTech.Api.Business;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Requests;

namespace RTech.Tests.Services;

public sealed class CrewServiceTests
{
    [Fact]
    public async Task GetCrewListAsync_RejectsPageNumberZero()
    {
        var service = new CrewService(Mock.Of<ICrewRepository>());
        await Assert.ThrowsAsync<ArgumentOutOfRangeException>(() =>
            service.GetCrewListAsync("SHIP01", new CrewSearchRequest { PageNumber = 0 }, CancellationToken.None));
    }

    [Fact]
    public async Task GetCrewListAsync_RejectsUnsupportedSortColumn()
    {
        var service = new CrewService(Mock.Of<ICrewRepository>());
        await Assert.ThrowsAsync<ArgumentException>(() =>
            service.GetCrewListAsync("SHIP01", new CrewSearchRequest { SortColumn = "ShipName" }, CancellationToken.None));
    }

    [Fact]
    public async Task GetCrewListAsync_RejectsPageSizeAboveProcedureLimit()
    {
        var service = new CrewService(Mock.Of<ICrewRepository>());
        await Assert.ThrowsAsync<ArgumentOutOfRangeException>(() =>
            service.GetCrewListAsync("SHIP01", new CrewSearchRequest { PageSize = 501 }, CancellationToken.None));
    }
}
