# DiscordTorLinux 🛡️🚀 (Linux & Windows)

> Solução definitiva para rodar o **Discord no Linux e no Windows** sem bloqueio regional de compartilhamento de tela / lives e com bypass de restrição de chat de voz (DPI), utilizando **Discord Drover** e túnel **Tor**.

---

## 🇧🇷 Guia de Instalação e Uso

### 🐧 Opção 1: No Linux (Ubuntu, Mint, Debian, Arch, Fedora, etc.)

#### 1. Instalação em 1 Comando
Clone o repositório e execute o instalador:
```bash
git clone https://github.com/itsnikotina/DiscordTorLinux.git
cd DiscordTorLinux
chmod +x install.sh && ./install.sh
```

#### 2. Como Usar
- Abra pelo menu de programas clicando em **Discord (Drover)**.
- Ou pelo terminal digitando `discord-drover`.

> 💡 **Nota**: No Linux, o serviço do Tor e os patches anti-bloqueio iniciam automaticamente em segundo plano!

---

### 🪟 Opção 2: No Windows (1-Click `.bat`)

#### 1. Instalação
1. Baixe o repositório como `.zip` (ou use `git clone`).
2. Extraia os arquivos.
3. Dê dois cliques no arquivo:
   👉 **`instalar-windows.bat`**

#### 2. Como Usar
1. Baixe e abra o [Tor Browser](https://www.torproject.org/) no Windows e clique no botão roxo **Conectar** (deixe ele aberto em segundo plano).
2. Abra o Discord normalmente pelo atalho da sua área de trabalho!

#### 3. Desinstalação no Windows
- Dê dois cliques em **`desinstalar-windows.bat`**.

---

## 🇺🇸 English Guide

### 🐧 Linux Installation
```bash
git clone https://github.com/itsnikotina/DiscordTorLinux.git
cd DiscordTorLinux
chmod +x install.sh && ./install.sh
```
Launch Discord using the **Discord (Drover)** desktop icon or by running `discord-drover`.

### 🪟 Windows Installation
1. Double-click **`instalar-windows.bat`**.
2. Open **Tor Browser**, click **Connect** (leave running in background).
3. Open Discord as usual.

---

### 📜 Licença / Créditos
- Baseado na lógica original do [discord-drover](https://github.com/hdrover/discord-drover) de @hdrover.
- Port nativo para Linux desenvolvido em C (`LD_PRELOAD`) e scripts de automação Windows (.bat) por @itsnikotina.
