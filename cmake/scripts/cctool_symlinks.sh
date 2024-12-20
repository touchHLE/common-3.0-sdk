#!/bin/bash
for file in arm-apple-darwin10-*; do
    target_name=${file#arm-apple-darwin10-}
    
    ln -sf "$file" "$target_name"
    echo "Created symlink: $target_name -> $file"
done