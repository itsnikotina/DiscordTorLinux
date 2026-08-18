@echo off
chcp 65001 >nul
title Discord Drover

:: 1. Iniciar Tor em segundo plano se ainda nao estiver rodando
set "TOR_RUNNING=0"
netstat -ano | findstr ":9080" >nul 2>&1 && set "TOR_RUNNING=1"
netstat -ano | findstr ":9150" >nul 2>&1 && set "TOR_RUNNING=1"

if "%TOR_RUNNING%"=="0" (
    set "TOR_EXE="
    if exist "%LOCALAPPDATA%\Discord-Drover\tor.exe" set "TOR_EXE=%LOCALAPPDATA%\Discord-Drover\tor.exe"
    if exist "%~dp0windows\tor.exe" set "TOR_EXE=%~dp0windows\tor.exe"
    if exist "%~dp0tor.exe" set "TOR_EXE=%~dp0tor.exe"
    if exist "%UserProfile%\Desktop\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=%UserProfile%\Desktop\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
    if exist "%LocalAppData%\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=%LocalAppData%\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
    if exist "%ProgramFiles%\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=%ProgramFiles%\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
    if exist "%ProgramFiles(x86)%\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=%ProgramFiles(x86)%\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
    if exist "C:\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=C:\Tor Browser\Browser\TorBrowser\Tor\tor.exe"

    if not "%TOR_EXE%"=="" (
        mkdir "%LOCALAPPDATA%\Discord-Drover\data" >nul 2>&1
        powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%TOR_EXE%' -ArgumentList '--SocksPort 9150 --HTTPTunnelPort 9080 --DataDirectory \"%LOCALAPPDATA%\Discord-Drover\data\"' -WindowStyle Hidden"
    )
)

:: 2. Iniciar Discord com excecao de proxy para uploads diretos (Google Cloud Storage / CDNs)
set "FLAGS=--proxy-bypass-list=*.storage.googleapis.com,*.googleapis.com,*.discordapp.com,*.discordapp.net,*.discord.media,*.gcp.discord.gg"

if exist "%LOCALAPPDATA%\Discord\Update.exe" (
    start "" "%LOCALAPPDATA%\Discord\Update.exe" --processStart Discord.exe --process-start-args "%FLAGS%"
) else if exist "%LOCALAPPDATA%\DiscordCanary\Update.exe" (
    start "" "%LOCALAPPDATA%\DiscordCanary\Update.exe" --processStart DiscordCanary.exe --process-start-args "%FLAGS%"
) else if exist "%LOCALAPPDATA%\DiscordPTB\Update.exe" (
    start "" "%LOCALAPPDATA%\DiscordPTB\Update.exe" --processStart DiscordPTB.exe --process-start-args "%FLAGS%"
)
