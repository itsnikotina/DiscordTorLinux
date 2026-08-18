@echo off
setlocal EnableDelayedExpansion
chcp 65001 >nul
title Discord Drover - Instalador Windows (Tudo em 1)

echo ========================================================
echo         Discord Drover (Windows) - Tudo em 1           
echo ========================================================
echo.

echo [*] Fechando processos do Discord...
taskkill /F /IM Discord.exe /T >nul 2>&1
taskkill /F /IM DiscordCanary.exe /T >nul 2>&1
taskkill /F /IM DiscordPTB.exe /T >nul 2>&1

set "SRC_DIR=%~dp0windows"
if not exist "%SRC_DIR%\version.dll" (
    set "SRC_DIR=%~dp0"
)

if not exist "%SRC_DIR%\version.dll" (
    echo [!] Erro: Arquivo version.dll nao encontrado!
    pause
    exit /b 1
)

:: 1. Salvar drover.ini padrao
(
echo [drover]
echo proxy = http://127.0.0.1:9080
) > "%SRC_DIR%\drover.ini"

:: 2. Criar pasta permanente para o Tor silencioso no sistema
set "APP_DATA_DIR=%LOCALAPPDATA%\Discord-Drover"
mkdir "%APP_DATA_DIR%" >nul 2>&1

if exist "%SRC_DIR%\tor.exe" (
    copy /Y "%SRC_DIR%\tor.exe" "%APP_DATA_DIR%\tor.exe" >nul
)

set "FOUND=0"

echo [*] Instalando bypass nas pastas do Discord...

if exist "%LOCALAPPDATA%\Discord" (
    for /d %%D in ("%LOCALAPPDATA%\Discord\app-*") do (
        if exist "%%D\Discord.exe" (
            copy /Y "%SRC_DIR%\version.dll" "%%D\" >nul
            copy /Y "%SRC_DIR%\drover.ini" "%%D\" >nul
            if exist "%SRC_DIR%\drover-packet.bin" copy /Y "%SRC_DIR%\drover-packet.bin" "%%D\" >nul
            echo [+] Instalado com sucesso no Discord: %%~nxD
            set "FOUND=1"
        )
    )
)

if exist "%LOCALAPPDATA%\DiscordCanary" (
    for /d %%D in ("%LOCALAPPDATA%\DiscordCanary\app-*") do (
        if exist "%%D\DiscordCanary.exe" (
            copy /Y "%SRC_DIR%\version.dll" "%%D\" >nul
            copy /Y "%SRC_DIR%\drover.ini" "%%D\" >nul
            if exist "%SRC_DIR%\drover-packet.bin" copy /Y "%SRC_DIR%\drover-packet.bin" "%%D\" >nul
            echo [+] Instalado com sucesso no Discord Canary: %%~nxD
            set "FOUND=1"
        )
    )
)

if exist "%LOCALAPPDATA%\DiscordPTB" (
    for /d %%D in ("%LOCALAPPDATA%\DiscordPTB\app-*") do (
        if exist "%%D\DiscordPTB.exe" (
            copy /Y "%SRC_DIR%\version.dll" "%%D\" >nul
            copy /Y "%SRC_DIR%\drover.ini" "%%D\" >nul
            if exist "%SRC_DIR%\drover-packet.bin" copy /Y "%SRC_DIR%\drover-packet.bin" "%%D\" >nul
            echo [+] Instalado com sucesso no Discord PTB: %%~nxD
            set "FOUND=1"
        )
    )
)

if "!FOUND!"=="0" (
    echo [!] Nenhuma pasta de instalacao do Discord foi encontrada em %LOCALAPPDATA%\Discord.
    pause
    exit /b 1
)

:: 3. Criar o launcher permanente
copy /Y "%~dp0abrir-discord.bat" "%APP_DATA_DIR%\abrir-discord.bat" >nul 2>&1

:: 4. Criar atalho na Area de Trabalho apontando para o launcher invisivel
echo [*] Criando atalho "Discord (Drover)" na Area de Trabalho...
set "TARGET_BAT=%APP_DATA_DIR%\abrir-discord.bat"
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut([System.IO.Path]::Combine([Environment]::GetFolderPath('Desktop'), 'Discord (Drover).lnk')); $s.TargetPath='%TARGET_BAT%'; $s.Save()" >nul 2>&1

echo.
echo ========================================================
echo        [+] INSTALACAO CONCLUIDA COM SUCESSO!           
echo ========================================================
echo.
echo O Tor autonomo silencioso e o Drover foram instalados!
echo Nao precisa abrir navegador nem instalar programas extras.
echo.
echo [*] Iniciando o Tor e abrindo o Discord agora...
call "%APP_DATA_DIR%\abrir-discord.bat"
