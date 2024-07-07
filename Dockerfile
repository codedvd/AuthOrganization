FROM mcr.microsoft.com/dotnet/sdk:8.0-nanoserver-1809 AS build
WORKDIR /src
COPY ["AuthOrganizationAPI/AuthOrganizationAPI.csproj", "AuthOrganizationAPI/"]
RUN dotnet restore "AuthOrganizationAPI/AuthOrganizationAPI.csproj"
COPY . .
WORKDIR "/src/AuthOrganizationAPI"
RUN dotnet build "AuthOrganizationAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AuthOrganizationAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AuthOrganizationAPI.dll"]

# Set the user to ContainerUser for subsequent stages if needed
USER ContainerUser
