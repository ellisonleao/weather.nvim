# weather.nvim

A simple Weather floating window in your Neovim

Prerequisites: Neovim 0.7+

# Installing

Using `vim-plug`

```
Plug 'ellisonleao/weather.nvim'
```

# Configuration

City

```lua
vim.g.weather_city = "Amsterdam"
```

# Usage

```
:Weather CITY
```

If `CITY` is not provided, it will use `g:weather_city` param or default value, which is
the city from your IP Address

# Screenshot

![](https://i.postimg.cc/QNvyCv6K/Screenshot-from-2020-10-27-23-03-07.png)
