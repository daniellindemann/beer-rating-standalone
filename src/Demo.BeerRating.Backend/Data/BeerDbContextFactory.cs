using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Logging.Abstractions;

namespace Demo.BeerRating.Backend.Data;

/// <summary>
/// Design-time factory used by EF Core tooling (dotnet ef migrations, dotnet ef migrations script, etc.).
/// This bypasses the application host so tooling works without a running database or full configuration.
/// </summary>
public class BeerDbContextFactory : IDesignTimeDbContextFactory<BeerDbContext>
{
    public BeerDbContext CreateDbContext(string[] args)
    {
        var optionsBuilder = new DbContextOptionsBuilder<BeerDbContext>();
        optionsBuilder.UseSqlServer("Server=localhost;Database=BeerRating;User Id=sa;Password=placeholder;",
            builder => builder.MigrationsAssembly(typeof(BeerDbContext).Assembly.FullName));

        var interceptor = new AuditableEntitySaveChangesInterceptor(
            NullLogger<AuditableEntitySaveChangesInterceptor>.Instance);

        return new BeerDbContext(optionsBuilder.Options, interceptor);
    }
}
