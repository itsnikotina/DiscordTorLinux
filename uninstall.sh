#!/bin/bash
set -e

echo "========================================"
echo "   Discord Drover - Linux Uninstaller   "
echo "========================================"

INSTALL_LIB_DIR="$HOME/.local/lib/discord-drover"
INSTALL_BIN_DIR="$HOME/.local/bin"
APP_DIR="$HOME/.local/share/applications"

echo "[*] Removendo arquivos instalados..."

rm -f "$INSTALL_LIB_DIR/libdrover.so"
if [ -d "$INSTALL_LIB_DIR" ]; then
    rmdir "$INSTALL_LIB_DIR" 2>/dev/null || true
fi

rm -f "$INSTALL_BIN_DIR/discord-drover"
rm -f "$APP_DIR/discord-drover.desktop"

echo "[+] Discord Drover foi desinstalado com sucesso!"
echo "Nota: Seus arquivos de configuração em ~/.config/discord/drover.ini foram mantidos."
