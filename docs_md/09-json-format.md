# JSON Format

## Overview

Adam Instance can be described and loaded with JSON format. It's requred to make external visual editor for Defold-Adam.


## How to create

Currently you can see only `/json_exampe.script` to see the JSON struct.


## How to use

There is no difference to use, but you have to use `adam:parse(json_string)` instead of `adam:new(...)`. All other stuff are identical.


## Visual Editor Metadata

If required, JSON can store metadata for visual editor (block colors, positions, tabs and any other way are required for editing)
