@echo off
chcp 65001 >nul
title Discord Drover

:: 1. Procurar onde o tor.exe esta localizado
set "TOR_EXE="
if exist "%LOCALAPPDATA%\Discord-Drover\tor.exe" set "TOR_EXE=%LOCALAPPDATA%\Discord-Drover\tor.exe"
if exist "%~dp0windows\tor.exe" set "TOR_EXE=%~dp0windows\tor.exe"
if exist "%~dp0tor.exe" set "TOR_EXE=%~dp0tor.exe"
if exist "%UserProfile%\Desktop\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=%UserProfile%\Desktop\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
if exist "%LocalAppData%\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=%LocalAppData%\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
if exist "%ProgramFiles%\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=%ProgramFiles%\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
if exist "%ProgramFiles(x86)%\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=%ProgramFiles(x86)%\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
if exist "C:\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=C:\Tor Browser\Browser\TorBrowser\Tor\tor.exe"

:: 2. Iniciar Tor se ainda nao estiver rodando
set "TOR_RUNNING=0"
netstat -ano | findstr ":9150" >nul 2>&1 && set "TOR_RUNNING=1"

if "%TOR_RUNNING%"=="0" (
    if not "%TOR_EXE%"=="" (
        powershell -NoProfile -Command "Start-Process -FilePath '%TOR_EXE%' -ArgumentList '--SocksPort 9150' -WindowStyle Hidden"
        timeout /t 3 /nobreak >nul 2>&1
    )
)

:: 3. Iniciar Discord
set "FLAGS=--proxy-server=socks5://127.0.0.1:9150 --proxy-bypass-list=*.storage.googleapis.com,*.googleapis.com,*.discordapp.com,*.discordapp.net,*.discord.media,*.gcp.discord.gg"

if exist "%LOCALAPPDATA%\Discord\Update.exe" (
    start "" "%LOCALAPPDATA%\Discord\Update.exe" --processStart Discord.exe --process-start-args "%FLAGS%"
) else if exist "%LOCALAPPDATA%\DiscordCanary\Update.exe" (
    start "" "%LOCALAPPDATA%\DiscordCanary\Update.exe" --processStart DiscordCanary.exe --process-start-args "%FLAGS%"
) else if exist "%LOCALAPPDATA%\DiscordPTB\Update.exe" (
    start "" "%LOCALAPPDATA%\DiscordPTB\Update.exe" --processStart DiscordPTB.exe --process-start-args "%FLAGS%"
)
