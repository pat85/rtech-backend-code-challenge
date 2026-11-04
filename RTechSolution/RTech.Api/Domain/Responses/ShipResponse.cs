using RTech.Api.Domain.Entities;

namespace RTech.Api.Domain.Responses;

public sealed record ShipResponse(
    int ShipId, string ShipCode, string ShipName,
    byte FiscalYearStartMonth, byte FiscalYearEndMonth, bool IsActive,
    DateTime? AssignedAt = null)
{
    public static ShipResponse From(Ship ship) => new(
        ship.ShipId, ship.ShipCode, ship.ShipName,
        ship.FiscalYearStartMonth, ship.FiscalYearEndMonth,
        ship.IsActive, ship.AssignedAt);
}
