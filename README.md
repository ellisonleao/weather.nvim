# weather.nvim

A simple Weather floating window in your Neovim

Prerequisites: Latest Neovim Stable

# Installing

Using `vim-plug`

```
Plug 'ellisonleao/weather.nvim'
```

Using `packer.nvim`

```
use({"ellisonleao/weather.nvim"})
```

# Configuration

The plugin comes with the default configs, which can be overridden:

```lua
require("weather").setup({
    city = "", -- with be used if no param is passed to :Weather
    win_height = int, -- popup height
    win_width = int, -- popup width
})
```

# Usage

```
:Weather [city]
```

# Screenshot

![](https://i.postimg.cc/QNvyCv6K/Screenshot-from-2020-10-27-23-03-07.png)
