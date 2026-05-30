# Arch Linux Dotfiles

Este repositório contém a lista de pacotes e arquivos de configuração (dotfiles) para replicar meu setup do Arch Linux com Hyprland em qualquer máquina.

## Conteúdo do Repositório

- **`packages.txt`**: Lista de pacotes explícitos do sistema (instalados via `pacman`).
- **`dotfiles/`**: Arquivos de configuração de usuário (`.bashrc`, `.bash_profile`, `hyprland.conf`, etc.).
- **`install.sh`**: Script automatizado para instalar todos os pacotes e criar links simbólicos (symlinks) seguros para as configurações.

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
3. Execute o script de instalação:
   ```bash
   ./install.sh
   ```

## Funcionamento do Script de Instalação

O script `install.sh` executa as seguintes etapas de forma segura:
1. **Verificação**: Confirma se está rodando no Arch Linux.
2. **Instalação de Pacotes**: Instala todos os pacotes listados em `packages.txt` usando `pacman -S --needed`. Os pacotes que já estiverem instalados serão pulados automaticamente.
3. **Links Simbólicos (Symlinks)**: Cria links simbólicos apontando para os arquivos do repositório. 
   - *Nota de Segurança:* Se já existir um arquivo de configuração real no seu computador (por exemplo, um `.bashrc` antigo), o script criará um backup dele com a extensão `.backup` (ex: `.bashrc.backup`) antes de criar o link.
