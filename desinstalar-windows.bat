@echo off
chcp 65001 >nul
title Discord Drover - Desinstalador Windows
color 0C

echo ========================================================
echo        Discord Drover (Windows) - Desinstalador        
echo ========================================================
echo.

:: 1. Fechar Discord se estiver aberto
echo [*] Fechando processos do Discord...
taskkill /F /IM Discord.exe /T >nul 2>&1
taskkill /F /IM DiscordCanary.exe /T >nul 2>&1
taskkill /F /IM DiscordPTB.exe /T >nul 2>&1

echo [*] Removendo arquivos do Drover das pastas do Discord...

for /d %%D in ("%LOCALAPPDATA%\Discord\app-*") do (
    if exist "%%D\version.dll" del /F /Q "%%D\version.dll" >nul 2>&1
    if exist "%%D\drover.ini" del /F /Q "%%D\drover.ini" >nul 2>&1
    if exist "%%D\drover-packet.bin" del /F /Q "%%D\drover-packet.bin" >nul 2>&1
    echo [-] Removido de: %%~nxD
)

for /d %%D in ("%LOCALAPPDATA%\DiscordCanary\app-*") do (
    if exist "%%D\version.dll" del /F /Q "%%D\version.dll" >nul 2>&1
    if exist "%%D\drover.ini" del /F /Q "%%D\drover.ini" >nul 2>&1
    if exist "%%D\drover-packet.bin" del /F /Q "%%D\drover-packet.bin" >nul 2>&1
    echo [-] Removido de: %%~nxD
)

for /d %%D in ("%LOCALAPPDATA%\DiscordPTB\app-*") do (
    if exist "%%D\version.dll" del /F /Q "%%D\version.dll" >nul 2>&1
    if exist "%%D\drover.ini" del /F /Q "%%D\drover.ini" >nul 2>&1
    if exist "%%D\drover-packet.bin" del /F /Q "%%D\drover-packet.bin" >nul 2>&1
    echo [-] Removido de: %%~nxD
)

echo.
echo ========================================================
echo       [+] DESINSTALACAO CONCLUIDA COM SUCESSO!         
echo ========================================================
echo.
pause
