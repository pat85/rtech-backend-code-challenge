using Moq;
using RTech.Api.Business;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Entities;
using RTech.Api.Domain.Requests;

namespace RTech.Tests.Services;

public sealed class ShipServiceTests
{
    [Fact]
    public async Task AddAsync_RejectsInvalidFiscalYearRange()
    {
        var service = new ShipService(Mock.Of<IShipRepository>());
        var request = new CreateShipRequest
        {
            ShipCode = "SHIP06", ShipName = "Example", FiscalYearStartMonth = 4, FiscalYearEndMonth = 4
        };

        await Assert.ThrowsAsync<ArgumentException>(
            () => service.AddAsync(request, CancellationToken.None));
    }

    [Fact]
    public async Task AddAsync_AcceptsAprilToMarchFiscalYear()
    {
        var repository = new Mock<IShipRepository>();
        repository.Setup(x => x.AddAsync(It.IsAny<Ship>(), It.IsAny<CancellationToken>()))
            .Returns((Ship ship, CancellationToken _) => { ship.ShipId = 10; return Task.FromResult(ship); });
        var service = new ShipService(repository.Object);

        var result = await service.AddAsync(new CreateShipRequest
        {
            ShipCode = "SHIP06", ShipName = "Example", FiscalYearStartMonth = 4, FiscalYearEndMonth = 3
        }, CancellationToken.None);

        Assert.Equal(10, result.ShipId);
        Assert.Equal((byte)4, result.FiscalYearStartMonth);
        Assert.Equal((byte)3, result.FiscalYearEndMonth);
    }
}
