-- Weather module for weather.nvim plugin
local win, buf
local M = {}

M.config = {
  city = "",
  win_height = math.ceil(vim.o.lines * 0.6 - 18),
  win_width = math.ceil(vim.o.columns * 0.3 - 20),
}

-- encode params
local function encode(param)
  local function char_to_hex(c)
    return string.format("%%%02X", string.byte(c))
  end

  if param == nil then
    return
  end
  param = param:gsub("\n", "\r\n")
  param = param:gsub("([^%w ])", char_to_hex)
  param = param:gsub(" ", "+")
  return param
end

local function create_window()
  -- window size and pos
  local win_height = M.config.win_height
  local win_width = M.config.win_width
  local x_pos = 1
  local y_pos = vim.o.columns - win_width

  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = x_pos,
    col = y_pos,
    border = "single",
  }

  -- create preview buffer and set local options
  buf = vim.api.nvim_create_buf(false, true)
  win = vim.api.nvim_open_win(buf, true, win_opts)

  -- create mapping to close buffer
  vim.keymap.set("n", "q", M.close_window, { noremap = true, silent = true })

  -- kill buffer on close
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_win_set_option(win, "winblend", 80)
end

-- creates a buffer window with weather output
function M.show_weather(city_args)
  local city = city_args ~= "" and city_args or M.config.city
  city = encode(city)

  local command = string.format("curl https://wttr.in/%s'?'0", city)
  create_window()
  vim.fn.termopen(command)
end

-- closes floating window
function M.close_window()
  vim.api.nvim_win_close(win, true)
end

-- main function
function M.setup(config)
  if vim.version().minor < 7 then
    vim.api.nvim_err_writeln("weather.nvim: you must use neovim 0.7 or higher")
    return
  end

  M.config = vim.tbl_extend("force", M.config, config or {})

  -- creates :Weather command
  vim.api.nvim_create_user_command("Weather", function(params)
    M.show_weather(params.args)
  end, { nargs = "*" })
end

return M
