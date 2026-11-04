using RTech.Api.Business;
using RTech.Api.DataAccess;
using RTech.Api.DataAccess.Repositories;
using RTech.Api.Domain.Interfaces;
using RTech.Api.Middleware;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddOpenApi();

// The factory is stateless; repositories and services are scoped per request.
builder.Services.AddSingleton<IDbConnectionFactory, DbConnectionFactory>();

builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IShipRepository, ShipRepository>();
builder.Services.AddScoped<ICrewRepository, CrewRepository>();
builder.Services.AddScoped<IFinancialReportRepository, FinancialReportRepository>();

builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IShipService, ShipService>();
builder.Services.AddScoped<ICrewService, CrewService>();
builder.Services.AddScoped<IFinancialReportService, FinancialReportService>();

var app = builder.Build();
app.UseMiddleware<ExceptionHandlingMiddleware>();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();

    app.UseSwaggerUI(options =>
    {
        options.SwaggerEndpoint(
            "/openapi/v1.json",
            "AE Backend API v1");

        options.RoutePrefix = "swagger";
    });

}

app.UseHttpsRedirection();
app.MapControllers();
app.Run();

// Exposes the entry point to WebApplicationFactory in future API integration tests.
public partial class Program { }
