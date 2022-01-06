# GitHub Theme

Yet another GitHub theme for Neovim.

Should support all existing themes. I use `dark_dimmed` exclusively, so I have
not fully tested all other themes. I have also only focused on languages that I
personally use. Feel free to open a pull request or issue.

## Features

* LSP & Treesitter


## Requirements

* Neovim >= 0.5.0


## Installation

[packer](https://github.com/wbthomason/packer.nvim)

```lua
use {
    'jsgv/github-theme.nvim',
    config = function ()
        require('github-theme').setup({
            theme = 'dark_dimmed'
        })
    end
}
```

## Why?

The existing implementations lacked all the various modes and I felt that they did
not look exactly as I expected. Also, all their color rules were defined in the plugin
whereas this plugin gets its color rules from the same place that the official
VSCode plugin does. Also, I wanted to learn plugin development with Lua.

