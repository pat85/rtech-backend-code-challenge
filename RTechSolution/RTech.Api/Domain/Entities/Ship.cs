namespace RTech.Api.Domain.Entities;

public sealed class Ship
{
    public int ShipId { get; set; }
    public string ShipCode { get; set; } = string.Empty;
    public string ShipName { get; set; } = string.Empty;
    public byte FiscalYearStartMonth { get; set; }
    public byte FiscalYearEndMonth { get; set; }
    public bool IsActive { get; set; }
    public DateTime? AssignedAt { get; set; }
}
