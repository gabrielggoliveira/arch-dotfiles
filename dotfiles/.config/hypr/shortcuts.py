#!/usr/bin/env python3
import os
import re

CONF_PATH = os.path.expanduser("~/.config/hypr/hyprland.conf")

# ANSI Color Codes
C_HEADER = "\033[95m"
C_KEY = "\033[96m"
C_DESC = "\033[97m"
C_RESET = "\033[0m"
C_BOLD = "\033[1m"
C_BORDER = "\033[90m"

def parse_shortcuts():
    if not os.path.exists(CONF_PATH):
        return []
    
    shortcuts = []
    current_comment = ""
    
    with open(CONF_PATH, "r") as f:
        for line in f:
            line = line.strip()
            
            # Catch comments
            if line.startswith("#"):
                comment = line.lstrip("#").strip()
                # Skip stub comments
                if "STUB" not in comment and "Use the default" not in comment:
                    current_comment = comment
                continue
            
            # Match bind lines
            # Example: bind = $mainMod, Q, exec, $terminal
            # Example: bindel = , XF86AudioRaiseVolume, exec, wpctl...
            match = re.match(r"^bind[a-z]*\s*=\s*([^,]*)\s*,\s*([^,]*)\s*,\s*(.*)$", line)
            if match:
                mods_raw = match.group(1).strip()
                key = match.group(2).strip()
                action = match.group(3).strip()
                
                # Format modifiers
                mods = mods_raw.replace("$mainMod", "SUPER")
                mods = mods.replace(" ", " + ")
                if mods.endswith("+"):
                    mods = mods[:-2].strip()
                
                shortcut = f"{mods} + {key}" if mods else key
                # Replace Return with Enter for better readability
                shortcut = shortcut.replace("Return", "Enter")
                
                # Description
                desc = current_comment if current_comment else action
                # Clean up action a bit for better readability if no comment
                if not current_comment:
                    desc = desc.replace("exec, ", "").replace("command -v ", "")
                
                shortcuts.append((shortcut, desc))
                current_comment = ""
            elif line == "":
                # Reset comment on empty lines to avoid associating unrelated comments
                current_comment = ""
                
    return shortcuts

def main():
    shortcuts = parse_shortcuts()
    
    # Header
    print(f"\n{C_HEADER}{C_BOLD}  ATALHOS DO HYPRLAND{C_RESET}")
    print(f"{C_BORDER}  {'=' * 65}{C_RESET}\n")
    
    if not shortcuts:
        print("  Nenhum atalho encontrado.")
    else:
        # Sort or just display
        for shortcut, desc in shortcuts:
            print(f"  {C_KEY}{shortcut:<30}{C_RESET} {C_DESC}{desc}{C_RESET}")
            
    print(f"\n{C_BORDER}  {'=' * 65}{C_RESET}")
    input(f"\n  Pressione {C_BOLD}[Enter]{C_RESET} para fechar...")

if __name__ == "__main__":
    main()
