# EmmyLua Annotations

## Overview

Emmylua can help you with autocomplete via prepared annotations for this extension. The annotations are generated from [LDoc documentation](https://insality.github.io/defold-adam/).

## How to use

If you use this extension as a dependency, copy the /annotations.lua file to you project root. You can rename it to `annotations-adam.lua` for example to exclude name conflict with other dependency annotations.

In the code, you should to declare type on require module, like this:

```lua
---@type adam
local adam = require("adam.adam")

---@type adam.actions
local actions = require("adam.actions")
```

## Links

https://emmylua.github.io/
https://github.com/EmmyLua/VSCode-EmmyLua