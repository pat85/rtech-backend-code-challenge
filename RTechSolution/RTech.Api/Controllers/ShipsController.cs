using Microsoft.AspNetCore.Mvc;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Requests;
using RTech.Api.Domain.Responses;

namespace RTech.Api.Controllers;

[ApiController]
[Route("api/ships")]
public sealed class ShipsController(IShipService service) : ControllerBase
{
    [HttpPost]
    [ProducesResponseType(typeof(ShipResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create(
        [FromBody] CreateShipRequest request, CancellationToken cancellationToken)
    {
        var ship = await service.AddAsync(request, cancellationToken);
        var response = ShipResponse.From(ship);
        return CreatedAtAction(nameof(GetAll), new { includeInactive = false }, response);
    }

    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<ShipResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll(
        [FromQuery] bool includeInactive = false, CancellationToken cancellationToken = default)
    {
        var ships = await service.GetAllAsync(includeInactive, cancellationToken);
        return Ok(ships.Select(ShipResponse.From).ToList());
    }
}
