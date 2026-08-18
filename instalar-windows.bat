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

:: 3. Criar drover.ini padrão apontando pro Tor Browser (porta 9150)
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
    echo [*] Voce tambem pode usar o executavel: windows\drover.exe
    pause
    exit /b 1
)

echo.
echo ========================================================
echo        [+] INSTALACAO CONCLUIDA COM SUCESSO! 🎉        
echo ========================================================
echo.
echo COMO USAR NO WINDOWS:
echo 1. Abra o Tor Browser e clique no botao "Conectar".
echo    (Deixe ele aberto em segundo plano na porta padrao 9150)
echo 2. Abra o Discord normalmente pelo atalho da area de trabalho!
echo.
echo O compartilhamento de tela e as lives vao funcionar sem bloqueio!
echo.
set /p ABRIR="Deseja abrir o Discord agora? (S/N): "
if /i "%ABRIR%"=="S" (
    start "" "%LOCALAPPDATA%\Discord\Update.exe" --processStart Discord.exe
)

pause
