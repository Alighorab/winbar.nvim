# Winbar.nvim

<p align="center">
  <img src="./media/demo.gif" />
</p>

- A simple winbar plugin written in Lua.
- It just shows the currently open buffers.
- It does not show special buffers like: `packer`, `help`, `NvimTree`, 
or `floating windows`

---
## Requirements
- **Neovim 0.8.0 or later** build (latest [nightly] recommended)
- [`nvim-tree/nvim-web-devicons`] plugin

---
## Installing
With [packer.nvim]
````lua
use("Alighorab/winbar.lua", {
    requires = {'nvim-tree/nvim-web-devicons'}
})
````
or
````lua
use("Alighorab/winbar.lua", {
    requires = {'nvim-tree/nvim-web-devicons'},
    config = require("winbar").setup()
})
````
---
## Usage
Somewhere in your `init.lua`:
````lua
require("winbar").setup({})
````

## Options
Default options are:
````lua
options = {
    filename = "relative" -- could be "relative", "abs", or "short"
}
````

## TO-DO
- Check window width to fit many buffers.


[packer.nvim]: https://github.com/wbthomason/packer.nvim
[nightly]: https://github.com/neovim/neovim#install-from-source
[`nvim-tree/nvim-web-devicons`]: https://github.com/nvim-tree/nvim-web-devicons
