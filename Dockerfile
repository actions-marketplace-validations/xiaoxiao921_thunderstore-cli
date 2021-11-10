# Set the base image as the .NET 6.0 SDK (this includes the runtime)
FROM mcr.microsoft.com/dotnet/sdk:6.0 as build-env

# Copy everything and publish the release (publish implicitly restores and builds)
COPY . ./
RUN dotnet publish ./ThunderstoreCLI/ThunderstoreCLI.csproj -c Release -o out --no-self-contained

# Label as GitHub action
LABEL com.github.actions.name="ThunderstoreCLI - TEST"
LABEL com.github.actions.description="A Github action for the Thunderstore CLI - TEST"
LABEL com.github.actions.icon="server"
LABEL com.github.actions.color="blue"

# Relayer the .NET SDK, anew with the build output
FROM mcr.microsoft.com/dotnet/sdk:6.0
COPY --from=build-env /out .
ENTRYPOINT [ "dotnet", "/tcli.dll" ]
