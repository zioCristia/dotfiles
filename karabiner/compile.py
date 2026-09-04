#!/usr/bin/env python3
import os
import json

def compile_karabiner():
    # Setup directories
    karabiner_dir = os.path.dirname(os.path.realpath(__file__))
    rules_dir = os.path.join(karabiner_dir, "rules")
    output_path = os.path.join(karabiner_dir, "karabiner.json")

    print("🛠️  Compiling Karabiner rules from:", rules_dir)

    # Base Karabiner structure
    config = {
        "machine_specific": {
            "krbn-8c159426-c760-4135-b528-977dd45f0b05": {
                "external_editor_path": "/Applications/Visual Studio Code.app"
            }
        },
        "profiles": [
            {
                "complex_modifications": {
                    "rules": []
                },
                "name": "Default profile",
                "selected": True,
                "virtual_hid_keyboard": {
                    "keyboard_type_v2": "iso"
                }
            }
        ]
    }

    # Load and append rules in alphabetical order
    rules = []
    if not os.path.exists(rules_dir):
        print(f"Error: Rules directory '{rules_dir}' does not exist.")
        return False

    for filename in sorted(os.listdir(rules_dir)):
        if filename.endswith(".json"):
            file_path = os.path.join(rules_dir, filename)
            print(f"  -> Loading rule: {filename}")
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    rule_data = json.load(f)
                    rules.append(rule_data)
            except Exception as e:
                print(f"❌ Error parsing {filename}: {e}")
                return False

    # Insert compiled rules into profile
    config["profiles"][0]["complex_modifications"]["rules"] = rules

    # Write output config
    try:
        with open(output_path, "w", encoding="utf-8") as f:
            json.dump(config, f, indent=4)
        print(f"✅ Compilation complete! Output saved to: {output_path}")
        return True
    except Exception as e:
        print(f"❌ Error writing output file: {e}")
        return False

if __name__ == "__main__":
    compile_karabiner()
