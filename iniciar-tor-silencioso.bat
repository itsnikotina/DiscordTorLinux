@echo off
chcp 65001 >nul
title Tor Invisivel - Windows

:: Procura onde o tor.exe esta instalado no PC
set "TOR_EXE="
if exist "%UserProfile%\Desktop\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=%UserProfile%\Desktop\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
if exist "%LocalAppData%\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=%LocalAppData%\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
if exist "C:\Tor Browser\Browser\TorBrowser\Tor\tor.exe" set "TOR_EXE=C:\Tor Browser\Browser\TorBrowser\Tor\tor.exe"
if exist "%ProgramFiles%\Tor\tor.exe" set "TOR_EXE=%ProgramFiles%\Tor\tor.exe"
if exist "%~dp0windows\tor.exe" set "TOR_EXE=%~dp0windows\tor.exe"
if exist "%~dp0tor.exe" set "TOR_EXE=%~dp0tor.exe"

if "%TOR_EXE%"=="" (
    echo [!] Tor.exe nao encontrado automaticamente.
    echo [*] Abra o Tor Browser manualmente ou coloque o Tor Expert Bundle nesta pasta.
    pause
    exit /b 1
)

:: Executa o Tor em segundo plano sem janela
echo [*] Iniciando Tor em segundo plano (invisivel)...
powershell -WindowStyle Hidden -Command "Start-Process -FilePath '%TOR_EXE%' -ArgumentList '--SocksPort 9150 --HTTPTunnelPort 9080' -WindowStyle Hidden"

echo [+] Tor iniciado com sucesso em segundo plano!
timeout /t 2 >nul
