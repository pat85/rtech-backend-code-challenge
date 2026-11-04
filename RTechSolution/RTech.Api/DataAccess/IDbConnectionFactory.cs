using System.Data;

namespace RTech.Api.DataAccess;

public interface IDbConnectionFactory
{
    IDbConnection CreateConnection();
}
