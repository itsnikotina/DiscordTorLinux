@echo off
title Debug Discord Drover
color 0E

echo ========================================================
echo        MODO DE DEPURACAO - DISCORD DROVER
echo ========================================================
echo.
echo [*] Fechando Discord e Tor travados...
taskkill /F /IM Discord.exe /T >nul 2>&1
taskkill /F /IM DiscordCanary.exe /T >nul 2>&1
taskkill /F /IM DiscordPTB.exe /T >nul 2>&1
taskkill /F /IM tor.exe /T >nul 2>&1

echo.
echo [*] Iniciando o Tor de forma VISIVEL...
set "TOR_EXE="
if exist "%LOCALAPPDATA%\Discord-Drover\tor.exe" set "TOR_EXE=%LOCALAPPDATA%\Discord-Drover\tor.exe"
if exist "%~dp0windows\tor.exe" set "TOR_EXE=%~dp0windows\tor.exe"

if "%TOR_EXE%"=="" (
    echo [!] ERRO: tor.exe nao encontrado!
    pause
    exit /b
)

start "Tor Debug" cmd /k "%TOR_EXE% --SocksPort 9150 --HTTPTunnelPort 9180"

echo.
echo ========================================================
echo OLHE PARA A OUTRA JANELA PRETA QUE ABRIU (Tor Debug).
echo Espere ela mostrar: "Bootstrapped 100%% (done)".
echo Se ela travar em 5%% ou 10%%, a operadora dele bloqueou o Tor!
echo ========================================================
pause

echo.
echo [*] Iniciando o Discord DIRETO (Pulando o Update.exe)...
set "FLAGS=--proxy-server=http://127.0.0.1:9180 --proxy-bypass-list=*.storage.googleapis.com,*.googleapis.com,*.discordapp.com,*.discordapp.net,*.discord.media,*.gcp.discord.gg"

set "DISCORD_EXE="
if exist "%LOCALAPPDATA%\Discord" (
    for /d %%D in ("%LOCALAPPDATA%\Discord\app-*") do (
        if exist "%%D\Discord.exe" set "DISCORD_EXE=%%D\Discord.exe"
    )
)

if "%DISCORD_EXE%"=="" (
    echo [!] Discord.exe direto nao encontrado!
    pause
    exit /b
)

echo Executando: "%DISCORD_EXE%" %FLAGS%
start "" "%DISCORD_EXE%" %FLAGS%

echo.
echo O Discord foi aberto ignorando o verificador de atualizacoes.
echo Se funcionar agora, o problema era o Update.exe!
pause
