#!/usr/bin/env python3
import json
import subprocess

def main():
    try:
        # Get notifications list
        res = subprocess.run(["makoctl", "list"], capture_output=True, text=True)
        out = res.stdout.strip()
        
        count = 0
        if out:
            try:
                data = json.loads(out)
                # makoctl list returns a structure: {"data": [[{notification1}, {notification2}]]}
                notifications = data.get("data", [[]])[0]
                count = len(notifications)
            except Exception:
                pass
        
        # Get current mode
        mode_res = subprocess.run(["makoctl", "mode"], capture_output=True, text=True)
        mode = mode_res.stdout.strip()
        
        # Format the output based on mode and count
        if mode == "dnd":
            text = f"󰂛 {count}" if count > 0 else "󰂛"
            alt = "dnd"
            class_name = "dnd"
            tooltip = f"Do Not Disturb (DND) Active\n{count} unread notifications"
        else:
            text = f"󰂚 {count}" if count > 0 else "󰂚"
            alt = "default"
            class_name = "default"
            tooltip = f"{count} notifications"
            
        print(json.dumps({
            "text": text,
            "alt": alt,
            "class": class_name,
            "tooltip": tooltip
        }))
        
    except Exception as e:
        print(json.dumps({
            "text": "󰂚",
            "alt": "error",
            "class": "error",
            "tooltip": f"Error: {str(e)}"
        }))

if __name__ == "__main__":
    main()
