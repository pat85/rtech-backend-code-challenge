using System.ComponentModel.DataAnnotations;

namespace RTech.Api.Domain.Requests;

public sealed class AssignShipRequest
{
    [Range(1, int.MaxValue)]
    public int ShipId { get; init; }
}
