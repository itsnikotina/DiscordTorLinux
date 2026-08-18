# DiscordTorLinux 🛡️🚀

> Solução definitiva para rodar o **Discord no Linux** sem bloqueio regional de compartilhamento de tela / lives e com bypass de restrição de chat de voz (DPI), utilizando **Discord Drover** e túnel **Tor**.

---

## 🇧🇷 Português

### ❓ O que é este projeto?
No Brasil e em outras regiões com restrições governamentais ou de operadoras, o Discord bloqueia o recurso de **compartilhamento de tela (transmissão ao vivo)** baseado na geolocalização do seu endereço IP, além de causar instabilidades em chats de voz via UDP.

Este projeto porta a ferramenta **Discord Drover** nativamente para o **Linux**:
1. **Bypass de Bloqueio Regional de Tela/Lives**: Roteia o tráfego do Discord através de um túnel seguro do **Tor** (`HTTPTunnel`), atribuindo um IP internacional e liberando o compartilhamento de tela.
2. **Bypass de Voz UDP (WebRTC)**: Intercepta e manipula os pacotes iniciais de áudio/vídeo (`libdrover.so` via `LD_PRELOAD`) para contornar bloqueios por DPI em operadoras.
3. **100% Automático**: O inicializador gerencia o serviço do Tor em segundo plano e abre o Discord sem precisar configurar nada manualmente.

---

### ⚡ Instalação Rápida (1 Comando)

1. Clone o repositório e entre na pasta:
```bash
git clone https://github.com/itsnikotina/DiscordTorLinux.git
cd DiscordTorLinux
```

2. Execute o instalador:
```bash
chmod +x install.sh && ./install.sh
```

Pronto! O instalador vai compilar a biblioteca, instalar as dependências necessárias (`tor`, `gcc`, `make`) e criar o atalho no seu menu de programas.

---

### 🎮 Como Usar

- **Pelo Menu de Aplicativos**: Procure por **Discord (Drover)** e clique para abrir.
- **Pelo Terminal**: Digite `discord-drover`.

> 💡 **Nota**: Ao abrir, o Tor e os patches anti-bloqueio iniciam automaticamente em segundo plano.

---

### 🗑️ Desinstalação

Se quiser remover o Discord Drover do sistema:
```bash
./uninstall.sh
```

---

## 🇺🇸 English

### ❓ About
Discord Drover for Linux forces Discord to bypass regional voice/streaming blocks by routing connections through a local Tor HTTP tunnel and applying custom UDP packet manipulation (`libdrover.so` via `LD_PRELOAD`).

### ⚡ Installation
```bash
git clone https://github.com/itsnikotina/DiscordTorLinux.git
cd DiscordTorLinux
chmod +x install.sh && ./install.sh
```

Launch Discord via your application launcher (**Discord (Drover)**) or by typing `discord-drover` in your terminal.

---

### 📜 Licença / Créditos
- Baseado na lógica original do [discord-drover](https://github.com/hdrover/discord-drover) de @hdrover.
- Port nativo para Linux desenvolvido em C (`LD_PRELOAD`).
