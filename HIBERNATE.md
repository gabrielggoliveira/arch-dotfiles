# Configuração de Hibernação no Arch Linux (Btrfs + UKI)

Este documento explica como a hibernação foi configurada no sistema e como o script `setup_hibernate.sh` automatiza esse processo para sistemas que utilizam **Btrfs** (como sistema de arquivos raiz) e **Unified Kernel Images (UKI)** com `systemd-boot`.

---

## 📋 Pré-requisitos & Desafios da Hibernação

A hibernação exige salvar o conteúdo completo da memória RAM em um disco persistente (não-volátil) antes de desligar a máquina.
1. **Incompatibilidade com zram**: O `zram` armazena dados de swap compactados na própria RAM. Por ser volátil, não pode ser utilizado para hibernação.
2. **Requisitos do Btrfs**: O Btrfs não permite arquivos de swap em subvolumes com snapshots ativos. Além disso, arquivos de swap Btrfs exigem a desativação do Copy-on-Write (No-COW) e o mapeamento do offset físico do arquivo no disco (`resume_offset`).
3. **Unified Kernel Image (UKI)**: Com UKI, os parâmetros de inicialização do kernel ficam embutidos no arquivo `.efi` de boot, sendo necessária a regeneração da imagem do kernel (`mkinitcpio`) após modificar os parâmetros do kernel.

---

## 🛠️ O que o script `setup_hibernate.sh` faz?

O script realiza as seguintes etapas de forma automática e segura:

1. **Criação do Subvolume & Swapfile**:
   * Cria um subvolume dedicado `/swap` para evitar snapshots.
   * Cria um arquivo de swap (`/swap/swapfile`) dinamicamente calculado para o tamanho da sua RAM + 1GB de buffer.
   * Desativa o Copy-on-Write (`chattr +C`) e desabilita a compressão para o arquivo de swap.
   * Aloca o tamanho necessário utilizando `dd` e formata o arquivo com `mkswap`.

2. **Ativação e Persistência**:
   * Ativa o arquivo de swap imediatamente (`swapon`).
   * Adiciona a entrada correspondente em `/etc/fstab` para montagem automática no boot.

3. **Cálculo de Parâmetros de Boot**:
   * Identifica o **UUID** do sistema de arquivos raiz.
   * Calcula o **offset físico** (`resume_offset`) do arquivo de swap usando a ferramenta integrada do btrfs (`btrfs inspect-internal map-swapfile`).

4. **Configuração de Boot (Kernel & Initramfs)**:
   * Atualiza os parâmetros do kernel em `/etc/kernel/cmdline` com as opções `resume=UUID=...` e `resume_offset=...`.
   * Insere o hook `resume` no arquivo `/etc/mkinitcpio.conf` logo após o hook `block`.
   * Executa o `mkinitcpio -P` para reconstruir o UKI (`/boot/EFI/Linux/arch-linux.efi`) com as novas configurações embutidas.

---

## 🚀 Como executar

Basta executar o script com permissões de administrador (`sudo`):

```bash
sudo ./setup_hibernate.sh
```

Após o término da execução, **reinicie o sistema** para carregar os novos parâmetros do kernel no boot.

```bash
sudo reboot
```

---

## 🔍 Verificação

Para confirmar se a hibernação e o swap estão funcionando perfeitamente após reiniciar:

1. **Verificar o Swap Ativo**:
   ```bash
   swapon --show
   ```
   *Você deverá ver tanto o `/dev/zram0` quanto o `/swap/swapfile` ativos.*

2. **Verificar se a Hibernação é suportada**:
   Executar o comando abaixo (irá hibernar o computador imediatamente):
   ```bash
   systemctl hibernate
   ```
