# Dockerfile for ASP.NET Web Application (Windows Container / IIS)
FROM mcr.microsoft.com/dotnet/framework/aspnet:4.8-windowsservercore-ltsc2019

WORKDIR /inetpub/wwwroot

# Copy application files
COPY ./Solution.Web .

EXPOSE 80
