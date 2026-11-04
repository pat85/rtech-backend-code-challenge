using RTech.Api.Domain.Entities;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Requests;

namespace RTech.Api.Business;

public sealed class CrewService(ICrewRepository repository) : ICrewService
{
    private static readonly HashSet<string> AllowedSortColumns = new(StringComparer.OrdinalIgnoreCase)
    {
        "RankName", "CrewMemberId", "FirstName", "LastName",
        "Age", "Nationality", "SignOnDate", "Status"
    };

    public Task<IReadOnlyList<CrewMember>> GetCrewListAsync(
        string shipCode, CrewSearchRequest request, CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(request);
        if (string.IsNullOrWhiteSpace(shipCode)) throw new ArgumentException("Ship code is required.");
        if (request.PageNumber < 1) throw new ArgumentOutOfRangeException(nameof(request.PageNumber));
        // The stored procedure accepts page sizes up to 500.
        if (request.PageSize is < 1 or > 500) throw new ArgumentOutOfRangeException(nameof(request.PageSize));
        if (string.IsNullOrWhiteSpace(request.SortColumn) || !AllowedSortColumns.Contains(request.SortColumn))
            throw new ArgumentException("Unsupported sort column.", nameof(request.SortColumn));
        if (!string.Equals(request.SortDirection, "ASC", StringComparison.OrdinalIgnoreCase) &&
            !string.Equals(request.SortDirection, "DESC", StringComparison.OrdinalIgnoreCase))
            throw new ArgumentException("Sort direction must be ASC or DESC.", nameof(request.SortDirection));

        // Pass the canonical database column name even if the client used different casing.
        var canonicalSortColumn = AllowedSortColumns.Single(
            column => column.Equals(request.SortColumn, StringComparison.OrdinalIgnoreCase));
        var normalized = new CrewSearchRequest
        {
            PageNumber = request.PageNumber,
            PageSize = request.PageSize,
            SortColumn = canonicalSortColumn,
            SortDirection = request.SortDirection.ToUpperInvariant(),
            SearchTerm = string.IsNullOrWhiteSpace(request.SearchTerm) ? null : request.SearchTerm.Trim()
        };

        return repository.GetCrewListAsync(shipCode.Trim(), normalized, cancellationToken);
    }
}
