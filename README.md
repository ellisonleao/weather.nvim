# weather.nvim

A simple Weather floating window in your Neovim

**Only works in Neovim 0.5 versions**

# Installing

Using `vim-plug`

```
Plug 'npxbr/weather.nvim'
```

# Configuration

City

```
let g:weather_city = "Amsterdam"
```

# Usage

```
:Weather CITY
```

If `CITY` is not provided, it will use `g:weather_city` param or default value, which is
the city from your IP Address

# Screenshot

![](https://postimg.cc/9ztpNgHc)
