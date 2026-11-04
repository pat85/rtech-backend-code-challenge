namespace RTech.Api.Domain.Entities;

// Property names intentionally match the aliases returned by the financial stored procedures.
public sealed class FinancialReport
{
    public string COADescription { get; set; } = string.Empty;
    public string AccountNumber { get; set; } = string.Empty;
    public decimal? ActualValue { get; set; }
    public decimal? BudgetValue { get; set; }
    public decimal? Variance { get; set; }
    public decimal? ActualYTD { get; set; }
    public decimal? BudgetYTD { get; set; }
    public decimal? VarianceYTD { get; set; }
}
