# DiscordTorLinux 🛡️🚀 (Linux & Windows)

> Solução definitiva para rodar o **Discord no Linux e no Windows** sem bloqueio regional de compartilhamento de tela / lives e com bypass de restrição de chat de voz (DPI), utilizando **Discord Drover** e túnel **Tor** (100% silencioso e em segundo plano).

---

## 🇧🇷 Guia de Instalação e Uso

### 🐧 Opção 1: No Linux (Ubuntu, Mint, Debian, Arch, Fedora, etc.)

#### 1. Instalação em 1 Comando
Abra o terminal e execute:
```bash
git clone https://github.com/itsnikotina/DiscordTorLinux.git
cd DiscordTorLinux
chmod +x install.sh && ./install.sh
```

#### 2. Como Usar
- Abra pelo menu de programas procurando por **Discord (Drover)**.
- Ou pelo terminal digitando `discord-drover`.

> 💡 **100% Silencioso**: O Tor e os patches anti-bloqueio iniciam automaticamente em segundo plano sem abrir nenhuma janela!

---

### 🪟 Opção 2: No Windows (1-Click `.bat`)

#### 1. Pré-requisito
- Tenha o [Tor Browser](https://www.torproject.org/) instalado no computador (não precisa abrir o navegador, o script usa o motor oculto dele).

#### 2. Instalação
1. Baixe o repositório como `.zip` (ou use `git clone`).
2. Extraia os arquivos.
3. Dê dois cliques no arquivo:
   👉 **`instalar-windows.bat`**

#### 3. Como Usar
- Um atalho **Discord (Drover)** será criado na sua **Área de Trabalho**.
- Basta clicar nele! O Tor iniciará de forma **100% invisível em segundo plano** e o Discord abrirá com as transmissões de tela liberadas!

#### 4. Desinstalação no Windows
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
2. Click the new **Discord (Drover)** shortcut on your Desktop (Tor launches invisibly in the background).

---

### 📜 Licença / Créditos
- Baseado na lógica original do [discord-drover](https://github.com/hdrover/discord-drover) de @hdrover.
- Port nativo para Linux desenvolvido em C (`LD_PRELOAD`) e scripts de automação Windows (.bat) por @itsnikotina.
