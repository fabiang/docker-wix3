ARG BASE_IMAGE_PWSH_VERSION=1809
ARG BASE_IMAGE=servercore
ARG BASE_IMAGE_VERSION=ltsc2019
FROM mcr.microsoft.com/powershell:lts-windows${BASE_IMAGE}-${BASE_IMAGE_PWSH_VERSION} AS download

ARG WIX_DOWNLOAD_URL=https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311-binaries.zip
ARG WIX_DOWNLOAD_HASH_SHA256=2c1888d5d1dba377fc7fa14444cf556963747ff9a0a289a3599cf09da03b9e2e

ENV TEMP=C:\\Windows\\TEMP

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Write-Host ('Downloading wix3 ({0}) ...' -f $env:WIX_DOWNLOAD_URL); \
    \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -Uri $env:WIX_DOWNLOAD_URL -OutFile ("'{0}\\wix.zip'" -f $Env:TEMP); \
    \
    Write-Host ('Verifying sha256 ({0}) ...' -f $env:WIX_DOWNLOAD_HASH_SHA256); \
    if ((Get-FileHash ("'{0}\\wix.zip'" -f $Env:TEMP) -Algorithm sha256).Hash -ne $env:WIX_DOWNLOAD_HASH_SHA256) { \
    Write-Host 'FAILED!'; \
    exit 1; \
    }; \
    \
    New-Item -ItemType "directory" -Path ("'{0}\\Wix3'" -f $Env:Programfiles); \
    \
    Expand-Archive -LiteralPath ("'{0}\\wix.zip'" -f $Env:TEMP) -DestinationPath  ("'{0}\\Wix3'" -f $Env:Programfiles); \
    \
    Write-Host 'Complete.'

FROM mcr.microsoft.com/windows/${BASE_IMAGE}:${BASE_IMAGE_VERSION}

SHELL ["cmd", "/S", "/C"]

COPY --from=download ["C:/Program Files/Wix3", "C:/Program Files/Wix3"]

ARG POWERSHELL_VERSION=7.2.8

USER ContainerAdministrator

RUN curl -SL --output PowerShell.msi https://github.com/PowerShell/PowerShell/releases/download/v%POWERSHELL_VERSION%/PowerShell-%POWERSHELL_VERSION%-win-x64.msi \
    \
    && (start /w msiexec.exe /package PowerShell.msi /quiet \
    ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=0 \
    ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=0 \
    ENABLE_PSREMOTING=0 \
    REGISTER_MANIFEST=0 \
    USE_MU=0 \
    ENABLE_MU=0 \
    ADD_PATH=1) \
    \
    && del /q PowerShell.msi

RUN curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe \
    \
    && (start /w vs_buildtools.exe --quiet --wait --norestart --nocache \
    --installPath "%ProgramFiles(x86)%\Microsoft Visual Studio\2022\BuildTools" \
    --add Microsoft.VisualStudio.Workload.AzureBuildTools \
    --add Microsoft.Component.ClickOnce.MSBuild \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10240 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.10586 \
    --remove Microsoft.VisualStudio.Component.Windows10SDK.14393 \
    --remove Microsoft.VisualStudio.Component.Windows81SDK \
    || IF "%ERRORLEVEL%"=="3010" EXIT 0) \
    \
    && del /q vs_buildtools.exe

RUN setx PATH "%PATH%;C:\Program Files\Wix3;%ProgramFiles(x86)%\Microsoft SDKs\ClickOnce\SignTool" /m \
    && setx WIX_TOOL_PATH "C:\Program Files\Wix3" /m

RUN mkdir C:\App
WORKDIR C:\\App

USER ContainerUser

ENTRYPOINT ["C:\\Program Files (x86)\\Microsoft Visual Studio\\2022\\BuildTools\\Common7\\Tools\\VsDevCmd.bat", "&&", "powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
