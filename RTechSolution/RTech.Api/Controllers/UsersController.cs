using Microsoft.AspNetCore.Mvc;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Requests;
using RTech.Api.Domain.Responses;

namespace RTech.Api.Controllers;

[ApiController]
[Route("api/users")]
public sealed class UsersController(IUserService service) : ControllerBase
{
    [HttpPost]
    [ProducesResponseType(typeof(UserResponse), StatusCodes.Status201Created)]
    [ProducesResponseType(StatusCodes.Status400BadRequest)]
    [ProducesResponseType(StatusCodes.Status409Conflict)]
    public async Task<IActionResult> Create(
        [FromBody] CreateUserRequest request, CancellationToken cancellationToken)
    {
        var user = await service.AddAsync(request, cancellationToken);
        var response = UserResponse.From(user);
        return CreatedAtAction(nameof(GetAll), new { includeInactive = false }, response);
    }

    [HttpGet]
    [ProducesResponseType(typeof(IReadOnlyList<UserResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetAll(
        [FromQuery] bool includeInactive = false, CancellationToken cancellationToken = default)
    {
        var users = await service.GetAllAsync(includeInactive, cancellationToken);
        return Ok(users.Select(UserResponse.From).ToList());
    }

    [HttpPost("{userId:int}/ships")]
    [ProducesResponseType(StatusCodes.Status204NoContent)]
    public async Task<IActionResult> AssignShip(
        int userId, [FromBody] AssignShipRequest request, CancellationToken cancellationToken)
    {
        await service.AssignShipAsync(userId, request.ShipId, cancellationToken);
        return NoContent();
    }

    [HttpGet("{userId:int}/ships")]
    [ProducesResponseType(typeof(IReadOnlyList<ShipResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetShips(
        int userId, [FromQuery] bool includeInactive = false, CancellationToken cancellationToken = default)
    {
        var ships = await service.GetShipsAsync(userId, includeInactive, cancellationToken);
        return Ok(ships.Select(ShipResponse.From).ToList());
    }
}
