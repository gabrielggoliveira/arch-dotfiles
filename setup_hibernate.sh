#!/bin/bash
set -euo pipefail

# This script must be run as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root (sudo)." >&2
  exit 1
fi

SWAP_DIR="/swap"
SWAP_FILE="${SWAP_DIR}/swapfile"

# Dynamically calculate swap size (RAM + 1GB buffer)
RAM_KB=$(grep MemTotal /proc/meminfo | awk '{print $2}')
RAM_MB=$((RAM_KB / 1024))
SWAP_SIZE_MB=$((RAM_MB + 1024))

echo "=== 1. Creating Btrfs Swap Volume & File ==="
if [ -f "$SWAP_FILE" ]; then
  CURRENT_SIZE=$(stat -c %s "$SWAP_FILE" 2>/dev/null || echo 0)
  REQUIRED_SIZE_BYTES=$((SWAP_SIZE_MB * 1024 * 1024))
  if [ "$CURRENT_SIZE" -ge "$REQUIRED_SIZE_BYTES" ]; then
    echo "Swapfile already exists with correct size at $SWAP_FILE. Skipping creation."
  else
    echo "Swapfile exists but is incomplete or invalid (size: $CURRENT_SIZE bytes, required: $REQUIRED_SIZE_BYTES bytes). Re-creating..."
    rm -f "$SWAP_FILE"
  fi
fi

if [ ! -f "$SWAP_FILE" ]; then
  if [ ! -d "$SWAP_DIR" ]; then
    echo "Creating subvolume $SWAP_DIR..."
    btrfs subvolume create "$SWAP_DIR"
  fi
  
  echo "Creating zero-length file and setting No-COW..."
  truncate -s 0 "$SWAP_FILE"
  chattr +C "$SWAP_FILE"

  echo "Allocating $SWAP_SIZE_MB MB for swapfile (this may take a few moments)..."
  dd if=/dev/zero of="$SWAP_FILE" bs=1M count="$SWAP_SIZE_MB" status=progress
  
  echo "Setting permissions..."
  chmod 600 "$SWAP_FILE"
  
  echo "Formatting as swap..."
  mkswap "$SWAP_FILE"
fi

echo "=== 2. Activating Swap ==="
if swapon --show | grep -q "$SWAP_FILE"; then
  echo "Swapfile is already active."
else
  echo "Activating swapfile..."
  swapon "$SWAP_FILE"
fi

echo "=== 3. Updating /etc/fstab ==="
if grep -q "$SWAP_FILE" /etc/fstab; then
  echo "Swapfile already configured in /etc/fstab."
else
  echo "Adding swapfile to /etc/fstab..."
  echo "${SWAP_FILE} none swap defaults 0 0" >> /etc/fstab
fi

echo "=== 4. Calculating Resume Parameters ==="
# Get the filesystem UUID containing the swapfile
UUID=$(findmnt -no UUID -T "$SWAP_FILE")
# Get the resume offset on Btrfs
OFFSET=$(btrfs inspect-internal map-swapfile -r "$SWAP_FILE")

echo "Detected UUID: $UUID"
echo "Detected Offset: $OFFSET"

echo "=== 5. Updating /etc/kernel/cmdline ==="
CMDLINE_FILE="/etc/kernel/cmdline"
if [ -f "$CMDLINE_FILE" ]; then
  # Backup
  cp "$CMDLINE_FILE" "${CMDLINE_FILE}.bak"
  echo "Backed up $CMDLINE_FILE to ${CMDLINE_FILE}.bak"
  
  # Read current contents
  CURRENT_CMDLINE=$(cat "$CMDLINE_FILE")
  
  # Remove existing resume/resume_offset if any
  NEW_CMDLINE=$(echo "$CURRENT_CMDLINE" | sed -E 's/\bresume=[^[:space:]]+//g' | sed -E 's/\bresume_offset=[^[:space:]]+//g' | sed -E 's/[[:space:]]+/ /g' | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')
  
  # Append new parameters
  NEW_CMDLINE="${NEW_CMDLINE} resume=UUID=${UUID} resume_offset=${OFFSET}"
  
  echo "$NEW_CMDLINE" > "$CMDLINE_FILE"
  echo "Updated $CMDLINE_FILE to:"
  cat "$CMDLINE_FILE"
else
  echo "Error: $CMDLINE_FILE not found. Please configure your bootloader manually." >&2
fi

echo "=== 6. Updating /etc/mkinitcpio.conf ==="
MKINITCPIO_CONF="/etc/mkinitcpio.conf"
if [ -f "$MKINITCPIO_CONF" ]; then
  # Backup
  cp "$MKINITCPIO_CONF" "${MKINITCPIO_CONF}.bak"
  echo "Backed up $MKINITCPIO_CONF to ${MKINITCPIO_CONF}.bak"
  
  # Check if resume hook is already in HOOKS
  if grep -E '^[[:space:]]*HOOKS=.*\bresume\b' "$MKINITCPIO_CONF" >/dev/null; then
    echo "resume hook already present in $MKINITCPIO_CONF."
  else
    # Insert 'resume' after 'block' in HOOKS
    sed -i -E '/^[[:space:]]*HOOKS=/s/\bblock\b/block resume/' "$MKINITCPIO_CONF"
    echo "Added 'resume' hook to HOOKS in $MKINITCPIO_CONF."
  fi
else
  echo "Error: $MKINITCPIO_CONF not found." >&2
fi

echo "=== 7. Regenerating Unified Kernel Image (UKI) ==="
echo "Running mkinitcpio -P..."
mkinitcpio -P

echo "=== Success! ==="
echo "Hibernation has been configured. Please REBOOT your system for the kernel parameters to take effect."
