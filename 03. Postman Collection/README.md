# RTech Backend API - Postman Collection

## Import

In Postman, select **Import** and choose `RTech_Backend_API.postman_collection.json`.

The collection includes its own variables, so a separate environment is not required.

## Start the API

From `RTechSolution/RTech.Api`:

```powershell
dotnet run --launch-profile http
```

Default collection `baseUrl`:

```text
http://localhost:5204
```

Change the collection variable `baseUrl` if your API reports a different listening address.

## Prerequisites

- SQL Server is running.
- The RTech database exists.
- All DDL scripts (tables, views, stored procedures) have been executed.
- Seed data scripts have been executed.

## Recommended run order

Run the folders in order:

1. `00 - Reference Data`
2. `01 - Users and Ships`
3. `02 - User Ship Assignments`
4. `03 - Crew`
5. `04 - Financial Reports`

Folder 01 creates a uniquely named user and ship each time and stores their IDs in collection variables. Folder 02 uses those IDs. The test-create requests write rows to the database; other requests are read-only.

## Tests included

- Active/inactive ship listing
- User listing and dynamic user creation
- Dynamic ship creation using April-March fiscal year
- Duplicate user and ship conflict handling
- User-ship assignment and idempotent reassignment
- Crew listing, pagination, search by ID and partial date (`05 Apr`)
- Invalid crew sort/page size and inactive ship handling
- Financial detail and summary for SHIP01 (Jan-Dec) and SHIP02 (Apr-Mar)
- Invalid accounting period and unknown ship handling

## Notes

- Negative-test requests are expected to return 400, 404 or 409. Postman marks them as passed when the expected status is returned.
- The financial example validates SHIP01 / account `7135000` / Jan 2025: monthly actual 1,000, budget 1,000, variance 0.
- The crew response uses the paged shape: `items`, `pageNumber`, `pageSize`, `totalCount`.
- This collection doesn't include authentication because the challenge API currently has no authentication requirement.
