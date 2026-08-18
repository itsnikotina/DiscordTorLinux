@echo off
chcp 65001 >nul
title Discord Drover - Instalador Windows
color 0B

echo ========================================================
echo         Discord Drover (Windows) - Instalador          
echo ========================================================
echo.

:: 1. Fechar Discord se estiver aberto
echo [*] Fechando processos do Discord...
taskkill /F /IM Discord.exe /T >nul 2>&1
taskkill /F /IM DiscordCanary.exe /T >nul 2>&1
taskkill /F /IM DiscordPTB.exe /T >nul 2>&1

:: 2. Diretório dos arquivos do Windows
set "SRC_DIR=%~dp0windows"
if not exist "%SRC_DIR%\version.dll" (
    set "SRC_DIR=%~dp0"
)

if not exist "%SRC_DIR%\version.dll" (
    echo [!] Erro: Arquivo version.dll nao encontrado!
    pause
    exit /b 1
)

:: 3. Criar drover.ini padrão apontando pro Tor (porta 9150)
(
echo [drover]
echo proxy = socks5://127.0.0.1:9150
) > "%SRC_DIR%\drover.ini"

:: 4. Procurar pastas do Discord e copiar arquivos
set "FOUND=0"

echo [*] Instalando arquivos nas pastas do Discord...

for /d %%D in ("%LOCALAPPDATA%\Discord\app-*") do (
    if exist "%%D\Discord.exe" (
        copy /Y "%SRC_DIR%\version.dll" "%%D\" >nul
        copy /Y "%SRC_DIR%\drover.ini" "%%D\" >nul
        if exist "%SRC_DIR%\drover-packet.bin" copy /Y "%SRC_DIR%\drover-packet.bin" "%%D\" >nul
        echo [+] Instalado com sucesso no Discord: %%~nxD
        set "FOUND=1"
    )
)

for /d %%D in ("%LOCALAPPDATA%\DiscordCanary\app-*") do (
    if exist "%%D\DiscordCanary.exe" (
        copy /Y "%SRC_DIR%\version.dll" "%%D\" >nul
        copy /Y "%SRC_DIR%\drover.ini" "%%D\" >nul
        if exist "%SRC_DIR%\drover-packet.bin" copy /Y "%SRC_DIR%\drover-packet.bin" "%%D\" >nul
        echo [+] Instalado com sucesso no Discord Canary: %%~nxD
        set "FOUND=1"
    )
)

for /d %%D in ("%LOCALAPPDATA%\DiscordPTB\app-*") do (
    if exist "%%D\DiscordPTB.exe" (
        copy /Y "%SRC_DIR%\version.dll" "%%D\" >nul
        copy /Y "%SRC_DIR%\drover.ini" "%%D\" >nul
        if exist "%SRC_DIR%\drover-packet.bin" copy /Y "%SRC_DIR%\drover-packet.bin" "%%D\" >nul
        echo [+] Instalado com sucesso no Discord PTB: %%~nxD
        set "FOUND=1"
    )
)

if "%FOUND%"=="0" (
    echo [!] Nenhuma pasta de instalacao padrao do Discord foi encontrada.
    pause
    exit /b 1
)

:: 5. Criar atalho na Área de Trabalho para o launcher automático
echo [*] Criando atalho na Area de Trabalho...
set "TARGET_BAT=%~dp0abrir-discord.bat"
powershell -Command "$s=(New-Object -COM WScript.Shell).CreateShortcut([System.IO.Path]::Combine([Environment]::GetFolderPath('Desktop'), 'Discord (Drover).lnk')); $s.TargetPath='%TARGET_BAT%'; $s.Save()" >nul 2>&1

echo.
echo ========================================================
echo        [+] INSTALACAO CONCLUIDA COM SUCESSO! 🎉        
echo ========================================================
echo.
echo O Tor agora roda 100%% silencioso em segundo plano!
echo Um atalho "Discord (Drover)" foi criado na sua Area de Trabalho.
echo.
set /p ABRIR="Deseja abrir o Discord agora? (S/N): "
if /i "%ABRIR%"=="S" (
    call "%~dp0abrir-discord.bat"
)
