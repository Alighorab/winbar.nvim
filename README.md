# Winbar.nvim
- A simple winbar plugin written in Lua.
- It just shows the currently open buffers.
- It does not show special buffers like: `packer`, `help`, `NvimTree`, 
or `floating windows`

---
## Installing
With [packer.nvim]:
````lua
use("Alighorab/winbar.lua", {
    requires = {'nvim-tree/nvim-web-devicons'}
})
````

---
## Usage
- Somewhere in your `init.lua`:
````lua
require("winbar").setup()
````

[packer.nvim]: https://github.com/wbthomason/packer.nvim
