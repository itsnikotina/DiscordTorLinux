#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"

echo "======================================================"
echo "    Discord Drover (Linux) - Instalador Automático    "
echo "======================================================"
echo ""

# 1. Verificar e instalar dependências essenciais
echo "[1/5] Verificando dependências (gcc, make, tor)..."
MISSING_PKGS=""
if ! command -v gcc >/dev/null 2>&1; then MISSING_PKGS="$MISSING_PKGS gcc"; fi
if ! command -v make >/dev/null 2>&1; then MISSING_PKGS="$MISSING_PKGS make"; fi
if ! command -v tor >/dev/null 2>&1; then MISSING_PKGS="$MISSING_PKGS tor"; fi

if [ -n "$MISSING_PKGS" ]; then
    echo "[*] Instalando pacotes necessários:$MISSING_PKGS..."
    sudo apt update && sudo apt install -y $MISSING_PKGS
fi

# 2. Compilar a biblioteca
echo "[2/5] Compilando libdrover.so..."
make -C "$SCRIPT_DIR" clean
make -C "$SCRIPT_DIR"

# 3. Criar diretórios locais
echo "[3/5] Configurando pastas do sistema..."
INSTALL_LIB_DIR="$HOME/.local/lib/discord-drover"
INSTALL_BIN_DIR="$HOME/.local/bin"
CONFIG_DIR="$HOME/.config/discord"
APP_DIR="$HOME/.local/share/applications"

mkdir -p "$INSTALL_LIB_DIR" "$INSTALL_BIN_DIR" "$CONFIG_DIR" "$APP_DIR"

# 4. Copiar arquivos
echo "[4/5] Instalando binários e atalhos..."
cp -f "$SCRIPT_DIR/libdrover.so" "$INSTALL_LIB_DIR/libdrover.so"
cp -f "$SCRIPT_DIR/discord-drover" "$INSTALL_BIN_DIR/discord-drover"
chmod +x "$INSTALL_BIN_DIR/discord-drover"

# Copiar para /usr/local/bin se tiver permissão (opcional)
sudo cp -f "$SCRIPT_DIR/discord-drover" /usr/local/bin/ 2>/dev/null || true
sudo cp -f "$SCRIPT_DIR/libdrover.so" /usr/local/lib/ 2>/dev/null || true

# Configurar drover.ini com o túnel HTTP do Tor por padrão
cat << 'EOF' > "$CONFIG_DIR/drover.ini"
[drover]
proxy = http://127.0.0.1:9080
EOF

if [ -f "$SCRIPT_DIR/drover-packet.bin" ]; then
    cp -f "$SCRIPT_DIR/drover-packet.bin" "$CONFIG_DIR/drover-packet.bin"
fi

# 5. Criar atalho no Menu de Aplicativos
echo "[5/5] Criando ícone no menu de aplicativos..."
ICON_PATH="discord"
if [ -f "/usr/share/discord/discord.png" ]; then
    ICON_PATH="/usr/share/discord/discord.png"
elif [ -f "$HOME/.config/discord/discord.png" ]; then
    ICON_PATH="$HOME/.config/discord/discord.png"
fi

cat << EOF > "$APP_DIR/discord-drover.desktop"
[Desktop Entry]
Name=Discord (Drover)
Comment=Discord sem bloqueio de tela/live (Drover + Tor)
GenericName=Internet Messenger
Exec=$INSTALL_BIN_DIR/discord-drover %U
Icon=$ICON_PATH
Type=Application
Categories=Network;InstantMessaging;
Path=$HOME
Terminal=false
StartupWMClass=discord
EOF
chmod +x "$APP_DIR/discord-drover.desktop"

echo ""
echo "======================================================"
echo "    [+] INSTALAÇÃO CONCLUÍDA COM SUCESSO! 🎉         "
echo "======================================================"
echo ""
echo "Como usar a partir de agora:"
echo "1. Abra o menu de aplicativos do Linux e procure por:"
echo "   'Discord (Drover)'"
echo "   (ou simplesmente digite 'discord-drover' no terminal)"
echo ""
echo "O Tor e o bypass do Drover vão iniciar automaticamente!"
echo ""
