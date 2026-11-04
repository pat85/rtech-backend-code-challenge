using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;

namespace RTech.Api.Middleware;

public sealed class ExceptionHandlingMiddleware(
    RequestDelegate next,
    ILogger<ExceptionHandlingMiddleware> logger)
{
    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await next(context);
        }
        catch (OperationCanceledException) when (context.RequestAborted.IsCancellationRequested)
        {
            // The client disconnected; do not turn cancellation into a 500 response.
        }
        catch (Exception exception)
        {
            logger.LogError(exception, "Unhandled API exception. TraceId: {TraceId}", context.TraceIdentifier);
            if (context.Response.HasStarted) throw;

            var (status, title, detail) = MapException(exception);
            context.Response.Clear();
            context.Response.StatusCode = status;
            context.Response.ContentType = "application/problem+json";

            var problem = new ProblemDetails
            {
                Status = status,
                Title = title,
                Detail = detail,
                Instance = context.Request.Path.Value
            };
            problem.Extensions["traceId"] = context.TraceIdentifier;
            await context.Response.WriteAsJsonAsync(problem);
        }
    }

    private static (int Status, string Title, string Detail) MapException(Exception exception)
        => exception switch
        {
            ArgumentException => (400, "Invalid request", exception.Message),
            SqlException sql when sql.Number is 2601 or 2627 or 50102 or 50114
                => (409, "Conflict", "A record with the same unique value already exists."),
            SqlException sql when sql.Number is 50121 or 50122 or 50131 or 50003 or 50012 or 50022
                => (404, "Resource not found", sql.Message),
            SqlException sql when sql.Number is 50101 or 50111 or 50112 or 50113 or
                50001 or 50002 or 50004 or 50011 or 50021
                => (400, "Invalid request", sql.Message),
            SqlException sql when sql.Number == 547
                => (409, "Related record conflict", "The operation conflicts with a related record."),
            _ => (500, "Internal server error",
                "An unexpected error occurred. Use the trace ID when contacting support.")
        };
}
