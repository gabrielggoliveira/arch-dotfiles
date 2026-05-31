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
3. Execute o script de instalação para configurar todo o sistema:
   ```bash
   ./install.sh
   ```

## Funcionamento do Script de Instalação

O script `install.sh` executa as seguintes etapas de forma segura:
1. **Verificação**: Confirma se está rodando no Arch Linux.
2. **Instalação de Pacotes do Pacman**: Instala todos os pacotes oficiais listados em `packages.txt`.
3. **Instalação de Pacotes do AUR**: Verifica se o helper `yay` está instalado. Caso contrário, compila e instala o `yay-bin` automaticamente do AUR, e em seguida instala todos os pacotes de comunidade listados em `aur_packages.txt`.
4. **Links Simbólicos (Symlinks)**: Cria links simbólicos apontando para os arquivos do repositório. 
   - *Nota de Segurança:* Se já existir um arquivo de configuração real no seu computador (por exemplo, um `.bashrc` antigo), o script criará um backup dele com a extensão `.backup` (ex: `.bashrc.backup`) antes de criar o link.

## Explicação dos Pacotes

Os pacotes listados em `packages.txt` estão divididos entre a base essencial do sistema e os pacotes específicos do ambiente Hyprland:

### 1. Pacotes Essenciais do Sistema (Base)
Estes pacotes formam a fundação do Arch Linux, gerenciamento de hardware, compilação de código e ferramentas administrativas básicas:
* **`base`**: Pacote base do Arch Linux contendo os utilitários fundamentais de sistema.
* **`base-devel`**: Grupo de ferramentas essenciais para compilação (compiladores como `gcc`, utilitários como `pkg-config`, etc.).
* **`linux`**: O Kernel do Linux.
* **`linux-firmware`**: Firmwares necessários para compatibilidade de placas e dispositivos de hardware.
* **`intel-ucode`**: Atualizações de microcódigo de segurança e estabilidade para processadores Intel (crítico para prevenir instabilidades físicas nas 13ª/14ª gerações).
* **`thermald`**: Daemon oficial de controle térmico da Intel para gerenciar a temperatura do processador e evitar superaquecimento sob carga pesada.
* **`irqbalance`**: Utilitário que distribui dinamicamente as interrupções de hardware (IRQs) entre todas as CPUs para melhorar a latência e eficiência do sistema.
* **`vulkan-radeon`**: Driver Vulkan open-source (`radv`) para suporte a aceleração gráfica 3D moderna de placas de vídeo AMD Radeon.
* **`vulkan-tools`** e **`mesa-utils`**: Utilitários essenciais de diagnóstico para verificar o funcionamento do OpenGL (`glxinfo`) e Vulkan (`vulkaninfo`).
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
* **`sddm`**: Gerenciador de login gráfico (Display Manager) para inicializar a sessão do Hyprland.
* **`hyprlock`**: Bloqueador de tela rápido, seguro e customizável nativo para o Hyprland.
* **`waybar`**: Barra de status personalizável na tela.
* **`mako`**: Daemon leve para exibir notificações do sistema.
* **`kitty`**: Emulador de terminal acelerado por GPU.
* **`dolphin`**: Gerenciador de arquivos gráfico (desenvolvido pelo KDE).
* **`firefox`**: Navegador de internet principal.
* **`gamemode`**: Daemon e biblioteca da Feral Interactive que otimiza automaticamente o sistema para performance em jogos e tarefas de alta carga.
* **`xdg-desktop-portal-hyprland`**: Backend do portal desktop para Hyprland (necessário para compartilhamento de tela, gravação e etc.).
* **`xdg-desktop-portal-gtk`**: Portal desktop complementar baseado em GTK (usado para caixas de diálogo de escolha de arquivos).
* **`ttf-jetbrains-mono-nerd`**: Fonte JetBrains Mono com suporte a ícones (Nerd Fonts).
* **`ttf-nerd-fonts-symbols-common`**: Fonte de símbolos comuns de ícones adicionais para a interface.

### 3. Pacotes do AUR (Arch User Repository)
Estes pacotes são instalados a partir do repositório da comunidade (AUR) e requerem um helper como o `yay`:
* **`yay-bin`**: O helper do AUR mais popular do Arch Linux, usado para buscar, baixar e compilar pacotes da comunidade automaticamente.

## Otimizações Específicas do Sistema

### 1. Processador (Intel Core i5-14600KF)
* **Carregamento de Microcódigo**: O microcode `intel-ucode` é carregado de forma antecipada (early load) no boot pelo Unified Kernel Image (UKI) para garantir estabilidade e corrigir tensões/frequências automáticas da CPU.
* **Gerenciamento Térmico**: O serviço `thermald` gerencia a temperatura do processador de forma inteligente.
* **Distribuição de Interrupções**: O serviço `irqbalance` previne gargalos no núcleo principal (Core 0), balanceando as tarefas do sistema entre todos os núcleos de performance (P-cores) e eficiência (E-cores).

### 2. Placa de Vídeo (AMD Radeon RX 9070 XT)
* **Aceleração Gráfica Nativa**: O driver `amdgpu` é utilizado nativamente no Kernel.
* **API Vulkan (RADV)**: Habilitada através do pacote `vulkan-radeon` (Mesa RADV) para máxima performance de renderização 3D em Wayland e compatibilidade total com Wine/Proton (Steam).
* **Aceleração de Vídeo por Hardware**: Habilitada via driver `radeonsi_drv_video` (VA-API integrado ao Mesa) para decodificação de mídia por hardware sem sobrecarga de CPU.

### 3. Otimizações para Jogos na Steam
Para obter a melhor performance e compatibilidade em jogos na Steam sob o Arch Linux e Hyprland:

* **Multilib e Drivers de 32-bits**: 
  A Steam e muitos jogos antigos rodam em 32-bits. Para que funcionem corretamente, é necessário habilitar o repositório `[multilib]` no seu `/etc/pacman.conf` e instalar os pacotes de driver de 32-bits:
  ```bash
  sudo pacman -S lib32-mesa lib32-vulkan-radeon
  ```
* **Feral GameMode**:
  O pacote `gamemode` já está instalado no sistema. Para ativá-lo em um jogo da Steam, clique com o botão direito sobre o jogo na sua biblioteca, acesse **Propriedades > Geral > Opções de Inicialização** e insira:
  ```bash
  gamemoderun %command%
  ```
* **Proton e Proton-GE (GloriousEggroll)**:
  Para máxima compatibilidade com jogos de Windows, utilize o Proton (nativo da Steam) ou instale o **Proton-GE** (uma versão da comunidade com patches adicionais de performance e correção de vídeo). O Proton-GE pode ser instalado facilmente com o gerenciador gráfico `protonup-qt`.
* **Compilador de Shaders ACO**:
  O driver RADV já utiliza o compilador ACO por padrão, reduzindo drasticamente os engasgos (*stuttering*) causados por compilação de shaders durante a gameplay.
* **Gamescope (Opcional)**:
  Para jogos que apresentem problemas de foco, resolução ou dimensionamento no Hyprland (Wayland), instale o `gamescope` (micro-compositor da Valve) e use a seguinte opção de inicialização na Steam (substituindo `-r 180` pela taxa de atualização correta do monitor):
  ```bash
  gamescope -f -r 180 -- %command%
  ```

