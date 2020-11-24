#!/bin/bash

## I am using Ldoc and my own Ldoc -> emmylua generator:
## https://github.com/Insality/emmylua-from-ldoc-annotations

emmylua_generator_path=~/code/lua/emmylua-from-ldoc-annotations

echo "Update Ldoc"
ldoc .

echo ""
echo "Update EmmyLua annotations"
original_path=$(pwd)
bash $emmylua_generator_path/export.sh $original_path
mv $emmylua_generator_path/annotations.lua $original_path/annotations.lua
