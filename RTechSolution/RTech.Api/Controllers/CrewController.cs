using Microsoft.AspNetCore.Mvc;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Requests;
using RTech.Api.Domain.Responses;

namespace RTech.Api.Controllers;

[ApiController]
[Route("api/ships/{shipCode}/crew")]
public sealed class CrewController(ICrewService service) : ControllerBase
{
    [HttpGet]
    [ProducesResponseType(typeof(PagedResponse<CrewResponse>), StatusCodes.Status200OK)]
    public async Task<IActionResult> GetCrew(
        string shipCode, [FromQuery] CrewSearchRequest request, CancellationToken cancellationToken)
    {
        var rows = await service.GetCrewListAsync(shipCode, request, cancellationToken);
        var totalCount = rows.Count == 0 ? 0 : rows[0].TotalCount;
        var response = new PagedResponse<CrewResponse>(
            rows.Select(CrewResponse.From).ToList(), request.PageNumber, request.PageSize, totalCount);
        return Ok(response);
    }
}
