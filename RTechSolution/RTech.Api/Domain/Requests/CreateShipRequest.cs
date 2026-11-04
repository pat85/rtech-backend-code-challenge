using System.ComponentModel.DataAnnotations;

namespace RTech.Api.Domain.Requests;

public sealed class CreateShipRequest : IValidatableObject
{
    [Required, StringLength(20)]
    public string ShipCode { get; init; } = string.Empty;

    [Required, StringLength(150)]
    public string ShipName { get; init; } = string.Empty;

    [Range(1, 12)]
    public byte FiscalYearStartMonth { get; init; } = 1;

    [Range(1, 12)]
    public byte FiscalYearEndMonth { get; init; } = 12;

    public IEnumerable<ValidationResult> Validate(ValidationContext validationContext)
    {
        var expectedEndMonth = FiscalYearStartMonth == 1 ? 12 : FiscalYearStartMonth - 1;
        if (FiscalYearEndMonth != expectedEndMonth)
        {
            yield return new ValidationResult(
                "Fiscal year must span 12 months; end month must be the month before the start month.",
                new[] { nameof(FiscalYearEndMonth) });
        }
    }
}
