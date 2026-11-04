using System.ComponentModel.DataAnnotations;

namespace RTech.Api.Domain.Requests;

public sealed class CreateUserRequest
{
    [Required, StringLength(100, MinimumLength = 3)]
    public string Username { get; init; } = string.Empty;

    [Required, StringLength(150)]
    public string FullName { get; init; } = string.Empty;

    [EmailAddress, StringLength(255)]
    public string? Email { get; init; }

    [Required, StringLength(50)]
    public string Role { get; init; } = "User";
}
