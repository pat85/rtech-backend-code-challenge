using RTech.Api.Domain.Entities;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Requests;

namespace RTech.Api.Business;

public sealed class ShipService(IShipRepository repository) : IShipService
{
    public Task<Ship> AddAsync(CreateShipRequest request, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(request);
        var expectedEndMonth = request.FiscalYearStartMonth == 1
            ? 12 : request.FiscalYearStartMonth - 1;

        if (request.FiscalYearStartMonth is < 1 or > 12 ||
            request.FiscalYearEndMonth is < 1 or > 12 ||
            request.FiscalYearEndMonth != expectedEndMonth)
        {
            throw new ArgumentException(
                "Fiscal year must span 12 months; end month must be the month before the start month.");
        }

        if (string.IsNullOrWhiteSpace(request.ShipCode)) throw new ArgumentException("Ship code is required.");
        if (string.IsNullOrWhiteSpace(request.ShipName)) throw new ArgumentException("Ship name is required.");

        return repository.AddAsync(new Ship
        {
            ShipCode = request.ShipCode.Trim(),
            ShipName = request.ShipName.Trim(),
            FiscalYearStartMonth = request.FiscalYearStartMonth,
            FiscalYearEndMonth = request.FiscalYearEndMonth,
            IsActive = true
        }, cancellationToken);
    }

    public Task<IReadOnlyList<Ship>> GetAllAsync(bool includeInactive, CancellationToken cancellationToken)
        => repository.GetAllAsync(includeInactive, cancellationToken);
}
