#!/usr/bin/env python3
"""
Sprite conversion tool for Game Boy assembly sprites
Converts between .sprite (assembly .DB format) and .bin (raw binary) formats
"""

import os
import re
import sys
from pathlib import Path

def sprite_to_bin(sprite_file, bin_file):
    """Convert .sprite file to .bin file"""
    try:
        with open(sprite_file, 'r') as f:
            content = f.read()
        
        # Extract hex values from .DB statements
        hex_pattern = r'\.DB\s+((?:\$[0-9A-Fa-f]{2}(?:,\s*)?)+)'
        matches = re.findall(hex_pattern, content)
        
        binary_data = bytearray()
        
        for match in matches:
            # Split by comma and clean up
            hex_values = [val.strip() for val in match.split(',')]
            for hex_val in hex_values:
                if hex_val.startswith('$'):
                    # Convert hex to byte
                    byte_val = int(hex_val[1:], 16)
                    binary_data.append(byte_val)
        
        with open(bin_file, 'wb') as f:
            f.write(binary_data)
        
        print(f"Converted {sprite_file} -> {bin_file} ({len(binary_data)} bytes)")
        return True
        
    except Exception as e:
        print(f"Error converting {sprite_file}: {e}")
        return False

def bin_to_sprite(bin_file, sprite_file):
    """Convert .bin file to .sprite file"""
    try:
        with open(bin_file, 'rb') as f:
            binary_data = f.read()
        
        output_lines = []
        
        # Process 16 bytes at a time (one tile)
        for i in range(0, len(binary_data), 16):
            chunk = binary_data[i:i+16]
            if len(chunk) == 0:
                break
                
            # Format as .DB statement with hex values
            hex_values = [f"${byte:02X}" for byte in chunk]
            line = ".DB " + ",".join(hex_values)
            output_lines.append(line)
        
        # Add final newline
        output_lines.append("")
        
        with open(sprite_file, 'w') as f:
            f.write("\n".join(output_lines))
        
        print(f"Converted {bin_file} -> {sprite_file} ({len(binary_data)} bytes)")
        return True
        
    except Exception as e:
        print(f"Error converting {bin_file}: {e}")
        return False

def convert_all_sprites_to_bin():
    """Convert all .sprite files to .bin in assets folder"""
    sprites_dir = Path("src/sprites")
    assets_dir = Path("assets")
    
    # Create assets directory if it doesn't exist
    assets_dir.mkdir(exist_ok=True)
    
    if not sprites_dir.exists():
        print(f"Error: {sprites_dir} directory not found!")
        return False
    
    sprite_files = list(sprites_dir.glob("*.sprite"))
    if not sprite_files:
        print(f"No .sprite files found in {sprites_dir}")
        return False
    
    success_count = 0
    for sprite_file in sprite_files:
        bin_file = assets_dir / (sprite_file.stem + ".bin")
        if sprite_to_bin(sprite_file, bin_file):
            success_count += 1
    
    print(f"\nConverted {success_count}/{len(sprite_files)} sprite files to binary")
    return success_count == len(sprite_files)

def convert_all_bins_to_sprite():
    """Convert all .bin files back to .sprite in src/sprites folder"""
    assets_dir = Path("assets")
    sprites_dir = Path("src/sprites")
    
    if not assets_dir.exists():
        print(f"Error: {assets_dir} directory not found!")
        return False
    
    bin_files = list(assets_dir.glob("*.bin"))
    if not bin_files:
        print(f"No .bin files found in {assets_dir}")
        return False
    
    success_count = 0
    for bin_file in bin_files:
        sprite_file = sprites_dir / (bin_file.stem + ".sprite")
        if bin_to_sprite(bin_file, sprite_file):
            success_count += 1
    
    print(f"\nConverted {success_count}/{len(bin_files)} binary files to sprites")
    return success_count == len(bin_files)

def main():
    if len(sys.argv) < 2:
        print("Usage:")
        print("  python convert_sprites.py to_bin     - Convert all .sprite to .bin")
        print("  python convert_sprites.py to_sprite  - Convert all .bin to .sprite")
        print("  python convert_sprites.py sprite_to_bin <file.sprite> <file.bin>")
        print("  python convert_sprites.py bin_to_sprite <file.bin> <file.sprite>")
        return
    
    command = sys.argv[1]
    
    if command == "to_bin":
        convert_all_sprites_to_bin()
    elif command == "to_sprite":
        convert_all_bins_to_sprite()
    elif command == "sprite_to_bin" and len(sys.argv) == 4:
        sprite_to_bin(sys.argv[2], sys.argv[3])
    elif command == "bin_to_sprite" and len(sys.argv) == 4:
        bin_to_sprite(sys.argv[2], sys.argv[3])
    else:
        print("Invalid command or arguments")
        main()

if __name__ == "__main__":
    main()