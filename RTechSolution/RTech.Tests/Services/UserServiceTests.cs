using Moq;
using RTech.Api.Business;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Domain.Entities;
using RTech.Api.Domain.Requests;

namespace RTech.Tests.Services;

public sealed class UserServiceTests
{
    [Fact]
    public async Task AddAsync_TrimsFieldsAndReturnsCreatedUser()
    {
        var repository = new Mock<IUserRepository>();
        repository.Setup(x => x.AddAsync(It.IsAny<User>(), It.IsAny<CancellationToken>()))
            .Returns((User user, CancellationToken _) =>
            {
                user.UserId = 42;
                return Task.FromResult(user);
            });
        var service = new UserService(repository.Object);

        var result = await service.AddAsync(new CreateUserRequest
        {
            Username = " jdoe ", FullName = " John Doe ", Email = " john@example.com ", Role = " Manager "
        }, CancellationToken.None);

        Assert.Equal(42, result.UserId);
        Assert.Equal("jdoe", result.Username);
        Assert.Equal("John Doe", result.FullName);
        Assert.Equal("john@example.com", result.Email);
        Assert.True(result.IsActive);
        repository.Verify(x => x.AddAsync(It.IsAny<User>(), It.IsAny<CancellationToken>()), Times.Once);
    }

    [Fact]
    public async Task GetShipsAsync_RejectsInvalidUserId()
    {
        var service = new UserService(Mock.Of<IUserRepository>());
        await Assert.ThrowsAsync<ArgumentOutOfRangeException>(
            () => service.GetShipsAsync(0, false, CancellationToken.None));
    }
}
