using System.Data;
using Microsoft.Data.SqlClient;

namespace RTech.Api.DataAccess;

public sealed class DbConnectionFactory(IConfiguration configuration) : IDbConnectionFactory
{
    public IDbConnection CreateConnection()
    {
        var connectionString = configuration.GetConnectionString("DefaultConnection");
        if (string.IsNullOrWhiteSpace(connectionString))
        {
            throw new InvalidOperationException(
                "Connection string 'DefaultConnection' is not configured. Set it using user secrets or environment variables.");
        }

        return new SqlConnection(connectionString);
    }
}
