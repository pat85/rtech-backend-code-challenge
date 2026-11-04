# RTech Backend – Local Setup Guide

This guide explains how to clone, configure, build, test and run the RTech ASP.NET Core API on a local development machine.

The SQL Server DDL, seed data and Postman instructions are maintained separately. See the links in the **Related setup guides** section rather than repeating those instructions here.

## Prerequisites

Install the following:

- **Git** – to clone the repository.
- **.NET 10 SDK** – both the API and test projects target .NET 10.
- **SQL Server** – SQL Server Express, Developer Edition or another compatible SQL Server instance.
- **SQL Server Management Studio (SSMS)** or Azure Data Studio – to create and populate the database.
- **Visual Studio 2026** or another .NET 10-compatible IDE (optional). The project can also be built and run from PowerShell.

Before starting the API, create the database and execute the SQL object and seed scripts using the separate guides.

## 1. Clone the repository

Open PowerShell or a terminal:

```powershell
git clone https://github.com/pat85/rtech-backend-code-challenge.git
cd rtech-backend-code-challenge
```

The .NET solution is located under `RTechSolution`:

```text
RTechSolution/
├── RTech.Api/       # ASP.NET Core Web API
├── RTech.Tests/     # xUnit unit tests
└── RTechSolution.slnx
```

## 2. Configure the SQL Server connection string

The API reads the connection string named `DefaultConnection`.

For local development, configure it with **.NET User Secrets**. This keeps the SQL username and password outside the repository.

From PowerShell:

```powershell
cd RTechSolution\RTech.Api

# Run once for this project. Skip this command if User Secrets are already initialized.
dotnet user-secrets init

# Replace the server, database, username and password with your own values.
dotnet user-secrets set "ConnectionStrings:DefaultConnection" "Server=localhost\SQLEXPRESS;Database=RTechDb;User Id=YOUR_SQL_USERNAME;Password=YOUR_SQL_PASSWORD;Encrypt=True;TrustServerCertificate=True;"
```

Adjust the connection details to match your SQL Server instance:

| SQL Server setup | Example `Server` value |
|---|---|
| Default local instance | `localhost` |
| SQL Server Express named instance | `localhost\SQLEXPRESS` |
| SQL Server listening on TCP port 1433 | `localhost,1433` |

Use the database name that you created and populated with the SQL scripts. The connection string above uses `RTechDb` as an example; change it if your database has a different name.

For local development, `TrustServerCertificate=True` can be useful with a locally generated or self-signed SQL Server certificate. For production, configure a trusted server certificate and use certificate validation.

To verify that the secret is configured:

```powershell
dotnet user-secrets list
```

User Secrets are stored outside the repository and are not committed to Git. Do not put real credentials in source code, Postman collections or tracked configuration files.

### Important: sanitize the committed connection string

The current repository version has a SQL authentication connection string in `RTechSolution/RTech.Api/appsettings.json`. Before sharing or deploying the repository, replace its value with an empty string, for example:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": ""
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

Then configure the actual connection using User Secrets as shown above. Because the previous credentials have already been committed, **rotate that SQL Server password**; removing it from the latest file does not remove it from Git history.

## 3. Restore, build and run the unit tests

If you are still in `RTechSolution\RTech.Api`, move to the solution directory:

```powershell
cd ..
```

Restore NuGet dependencies, build the solution and run the tests:

```powershell
dotnet restore
dotnet build
dotnet test
```

To run only the test project:

```powershell
dotnet test .\RTech.Tests\RTech.Tests.csproj
```

The current unit tests use mocked repository dependencies, so they do not require SQL Server to be running. Running the API and testing real database operations does require a reachable SQL Server database.

## 4. Start the API

From the `RTechSolution` directory:

```powershell
dotnet run --project .\RTech.Api\RTech.Api.csproj --launch-profile http
```

The HTTP launch profile is configured in `RTech.Api/Properties/launchSettings.json`:

| Purpose | URL |
|---|---|
| API base URL | `http://localhost:5204` |
| Swagger UI | `http://localhost:5204/swagger` |
| OpenAPI JSON | `http://localhost:5204/openapi/v1.json` |

An HTTPS profile is also available:

```powershell
dotnet run --project .\RTech.Api\RTech.Api.csproj --launch-profile https
```

| Purpose | URL |
|---|---|
| API base URL | `https://localhost:7193` |
| Swagger UI | `https://localhost:7193/swagger` |

The launch profiles set `ASPNETCORE_ENVIRONMENT=Development`, which enables the OpenAPI document and Swagger UI. The browser is configured to open Swagger UI when a profile is started. The terminal also prints the actual listening addresses; use those if they differ from the defaults above.

Press `Ctrl+C` in the terminal to stop the API.

## 5. Run from Visual Studio (optional)

1. Open `RTechSolution/RTechSolution.slnx` in a .NET 10-compatible version of Visual Studio.
2. Set `RTech.Api` as the startup project.
3. Select the `http` launch profile.
4. Press `F5` to run with debugging, or `Ctrl+F5` to run without debugging.
5. Swagger UI should open at `http://localhost:5204/swagger`.

To run unit tests from Visual Studio, open **Test > Test Explorer** and select **Run All Tests**.

## 6. Test the running API

Use Swagger UI at `http://localhost:5204/swagger` to explore and execute the endpoints.

The repository also includes a Postman collection with request examples and automated response assertions. Follow the separate Postman guide for importing and running it.

## Troubleshooting

| Problem | What to check |
|---|---|
| `dotnet` command is not found | Install the .NET 10 SDK, reopen the terminal and verify with `dotnet --info`. |
| SQL login failed | Confirm SQL Server authentication is enabled, the username and password are correct, and the login has access to the target database. |
| Cannot open database | Confirm the database exists and the connection string uses the exact database name. |
| Server or instance not found | Check that the SQL Server service is running and that the server/instance name is correct. |
| SSL certificate error | For local development, check `TrustServerCertificate=True`; use a trusted certificate outside local development. |
| Port already in use | Check the terminal output or change `applicationUrl` in `RTech.Api/Properties/launchSettings.json`. |
| Swagger UI is unavailable | Run with the `http` or `https` Development launch profile and browse to `/swagger`. |
| Connection string appears empty | Run `dotnet user-secrets list` from the API project directory and confirm `ConnectionStrings:DefaultConnection` is present. |

## Related setup guides

- [SQL Server objects and DDL execution order](01.%20SQL%20Objects/README.md)
- [Seed data and sample-data execution](02.%20Data%20Sample/README.md)
- [Postman collection import and API testing](03.%20Postman%20Collection/README.md)
