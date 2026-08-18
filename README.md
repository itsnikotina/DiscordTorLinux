# DiscordTorLinux 🛡️🚀 (Linux & Windows)

> Solução definitiva para rodar o **Discord no Linux e no Windows** sem bloqueio regional de compartilhamento de tela / lives e com bypass de restrição de chat de voz (DPI), utilizando **Discord Drover** e motor **Tor 100% autônomo e silencioso** (sem necessidade de navegadores visuais).

---

## 🚀 O que este projeto faz?
1. **Bypass de Bloqueio Regional de Tela/Lives**: Roteia o login e gateway do Discord através de um túnel seguro do **Tor** (`HTTPTunnel`), atribuindo um IP internacional e liberando o compartilhamento de tela.
2. **Bypass de Voz UDP (WebRTC)**: Intercepta e manipula os pacotes de áudio/vídeo (`libdrover.so` no Linux / `version.dll` no Windows) para contornar bloqueios por DPI em operadoras.
3. **Uploads e Downloads em Velocidade Máxima**: Arquivos pesados (vídeos, fotos, mídias do Google Cloud Storage e CDNs) possuem rota direta (`--proxy-bypass-list`), sem passar pelo Tor, garantindo 100% da velocidade da sua fibra!
4. **100% Automático e Silencioso**: O Tor roda de forma invisível em segundo plano tanto no Linux quanto no Windows (não precisa abrir navegador nem janelas extras).

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

---

### 🪟 Opção 2: No Windows (1-Click `.bat`)

#### 1. Instalação (Tudo em 1)
1. Baixe o repositório como `.zip` (ou use `git clone`).
2. Extraia os arquivos.
3. Dê dois cliques no arquivo:
   👉 **`instalar-windows.bat`**

*(O instalador já configura o Discord, inclui o motor silencioso do Tor e cria o atalho na sua Área de Trabalho).*

#### 2. Como Usar no dia a dia
- Basta clicar no atalho **`Discord (Drover)`** na sua **Área de Trabalho**!
- O Tor iniciará de forma **100% invisível em segundo plano** e o Discord abrirá automaticamente com telas liberadas e uploads rápidos!

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
2. Click the new **Discord (Drover)** shortcut on your Desktop.

---

### 📜 Licença / Créditos
- Baseado na lógica original do [discord-drover](https://github.com/hdrover/discord-drover) de @hdrover.
- Port nativo para Linux desenvolvido em C (`LD_PRELOAD`) e pacote autônomo Windows (.bat + silent Tor) por @itsnikotina.
