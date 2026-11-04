using RTech.Api.Domain.Entities;

namespace RTech.Api.Domain.Responses;

public sealed record UserResponse(
    int UserId, string Username, string FullName, string? Email,
    string Role, bool IsActive, DateTime CreatedAt, int AssignedShipCount)
{
    public static UserResponse From(User user) => new(
        user.UserId, user.Username, user.FullName, user.Email,
        user.Role, user.IsActive, user.CreatedAt, user.AssignedShipCount);
}
