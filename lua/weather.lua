-- Weather module for weather.nvim plugin
local win, buf
local M = {}

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
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  local win_height = math.ceil(height * 0.6 - 18)
  local win_width = math.ceil(width * 0.3 - 20)
  local x_pos = 1
  local y_pos = width - win_width

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
function M.show_weather(city)
  -- validate city

  create_window()

  -- handle city global param
  -- can either be g:weather_city or a param in :Weather command
  local city_param = ""
  if vim.g.weather_city ~= nil then
    city_param = vim.g.weather_city
  elseif city ~= nil then
    city_param = encode(city)
  end

  local command = string.format("curl https://wttr.in/%s'?'0", city_param)
  vim.fn.termopen(command)
end

-- closes floating window
function M.close_window()
  vim.api.nvim_win_close(win, true)
end

-- main function
function M.init()
  if vim.version().minor < 7 then
    vim.api.nvim_err_writeln("weather.nvim: you must use neovim 0.7 or higher")
    return
  end

  -- creates :Weather command
  vim.api.nvim_create_user_command("Weather", function(params)
    M.show_weather(params.args)
  end, { nargs = "*" })
end

return M
