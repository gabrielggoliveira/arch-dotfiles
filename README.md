# Arch Linux Dotfiles

Este repositório contém a lista de pacotes e arquivos de configuração (dotfiles) para replicar meu setup do Arch Linux com Hyprland em qualquer máquina.

## Conteúdo do Repositório

- **`packages.txt`**: Lista de pacotes explícitos do sistema (instalados via `pacman`).
- **`aur_packages.txt`**: Lista de pacotes do Arch User Repository (AUR) instalados via helper (como `yay`).
- **`dotfiles/`**: Arquivos de configuração de usuário (`.bashrc`, `.bash_profile`, `hyprland.conf`, etc.).
- **`install.sh`**: Script automatizado para instalar todos os pacotes oficiais e criar links simbólicos (symlinks) seguros para as configurações.

## Requisitos

1. Uma instalação básica do Arch Linux funcionando.
2. Git instalado:
   ```bash
   sudo pacman -S git --needed
   ```

## Como Usar

1. Clone este repositório para a sua máquina (recomenda-se clonar dentro de uma pasta `~/workspace/` ou no seu diretório home):
   ```bash
   git clone <URL_DO_SEU_REPOSITORIO> ~/workspace/arch-dotfiles
   ```
2. Acesse a pasta do repositório:
   ```bash
   cd ~/workspace/arch-dotfiles
   ```
3. Execute o script de instalação para pacotes oficiais e dotfiles:
   ```bash
   ./install.sh
   ```
4. Para instalar os pacotes adicionais do AUR (como o `noctalia-shell`), você pode usar o `yay` (que é instalado automaticamente se você usar o script de compilação ou se já o tiver):
   ```bash
   yay -S --needed - < aur_packages.txt
   ```

## Funcionamento do Script de Instalação

O script `install.sh` executa as seguintes etapas de forma segura:
1. **Verificação**: Confirma se está rodando no Arch Linux.
2. **Instalação de Pacotes**: Instala todos os pacotes listados em `packages.txt` usando `pacman -S --needed`. Os pacotes que já estiverem instalados serão pulados automaticamente.
3. **Links Simbólicos (Symlinks)**: Cria links simbólicos apontando para os arquivos do repositório. 
   - *Nota de Segurança:* Se já existir um arquivo de configuração real no seu computador (por exemplo, um `.bashrc` antigo), o script criará um backup dele com a extensão `.backup` (ex: `.bashrc.backup`) antes de criar o link.

## Explicação dos Pacotes

Os pacotes listados em `packages.txt` estão divididos entre a base essencial do sistema e os pacotes específicos do ambiente Hyprland:

### 1. Pacotes Essenciais do Sistema (Base)
Estes pacotes formam a fundação do Arch Linux, gerenciamento de hardware, compilação de código e ferramentas administrativas básicas:
* **`base`**: Pacote base do Arch Linux contendo os utilitários fundamentais de sistema.
* **`base-devel`**: Grupo de ferramentas essenciais para compilação (compiladores como `gcc`, utilitários como `pkg-config`, etc.).
* **`linux`**: O Kernel do Linux.
* **`linux-firmware`**: Firmwares necessários para compatibilidade de placas e dispositivos de hardware.
* **`intel-ucode`**: Atualizações de microcódigo de segurança e estabilidade para processadores Intel.
* **`sudo`**: Utilitário para permitir execução de comandos como administrador.
* **`efibootmgr`**: Ferramenta para gerenciar entradas de boot no firmware UEFI.
* **`btrfs-progs`**: Utilitários para gerenciar partições formatadas em Btrfs.
* **`snapper`**: Ferramenta para criação e gestão de snapshots (restauração rápida de sistema).
* **`zram-generator`**: Gerador automático para configurar ZRAM (melhoria de performance e uso de memória RAM).
* **`openssh`**: Cliente e servidor de SSH seguro.
* **`pipewire-pulse`**: Camada de compatibilidade do PulseAudio para o PipeWire (essencial para que navegadores e outros aplicativos de desktop consigam reproduzir som).
* **`git`**: Sistema de controle de versão de código.
* **`cmake` e `make`**: Ferramentas de automação de compilação.
* **`nano`**: Editor de texto rápido via terminal.

### 2. Pacotes Específicos do Hyprland e Interface
Estes pacotes são responsáveis pelo ambiente gráfico, aparência, terminal, fontes e utilitários de produtividade:
* **`brightnessctl`**: Utilitário de linha de comando para controlar o brilho da tela (laptops/monitores).
* **`hyprland`**: O compositor Wayland (Window Manager) que gerencia as janelas do sistema.
* **`hyprlauncher`**: Menu iniciador de aplicativos leve.
* **`hyprpaper`**: Utilitário para gerenciar e alternar papéis de parede.
* **`hyprpolkitagent`**: Agente de autenticação Polkit nativo do Hyprland (janelas de permissão administrativa).
* **`waybar`**: Barra de status personalizável na tela.
* **`mako`**: Daemon leve para exibir notificações do sistema.
* **`kitty`**: Emulador de terminal acelerado por GPU.
* **`dolphin`**: Gerenciador de arquivos gráfico (desenvolvido pelo KDE).
* **`firefox`**: Navegador de internet principal.
* **`xdg-desktop-portal-hyprland`**: Backend do portal desktop para Hyprland (necessário para compartilhamento de tela, gravação e etc.).
* **`xdg-desktop-portal-gtk`**: Portal desktop complementar baseado em GTK (usado para caixas de diálogo de escolha de arquivos).
* **`ttf-jetbrains-mono-nerd`**: Fonte JetBrains Mono com suporte a ícones (Nerd Fonts).
* **`ttf-nerd-fonts-symbols-common`**: Fonte de símbolos comuns de ícones adicionais para a interface.

### 3. Pacotes do AUR (Arch User Repository)
Estes pacotes são instalados a partir do repositório da comunidade (AUR) e requerem um helper como o `yay`:
* **`yay-bin`**: O helper do AUR mais popular do Arch Linux, usado para buscar, baixar e compilar pacotes da comunidade automaticamente.
* **`noctalia-shell`**: Desktop shell elegante e minimalista voltado para compositores Wayland (fornece barras de tarefas, widgets, dock, notificações e área de controle).

