-- Weather module for weather.nvim plugin
local win, buf
local M = {}

-- creates :Weather command
local function create_command()
  vim.cmd(
    "command! -bang -nargs=? Weather lua require('weather').show_weather(<f-args>)")
end

local function create_window()
  -- window size and pos
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")
  local win_height = math.ceil(height * 0.6 - 8)
  local win_width = math.ceil(width * 0.3 - 6)
  local x_pos = 1
  local y_pos = width - win_width

  local win_opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    height = win_height,
    row = x_pos,
    col = y_pos,
  }

  -- create preview buffer and set local options
  buf = vim.api.nvim_create_buf(false, true)
  win = vim.api.nvim_open_win(buf, true, win_opts)

  -- create mapping to close buffer
  vim.api.nvim_buf_set_keymap(buf, "n", "q",
                              ":lua require('weather').close_window()<cr>",
                              {noremap = true, silent = true})

  -- kill buffer on close
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_win_set_option(win, "winblend", 80)
end

-- creates a buffer window with weather output
function M.show_weather(city)
  create_window()

  -- handle city global param
  -- can either be g:weather_city or a param in :Weather command
  local city_param
  if vim.g.weather_city ~= nil then
    city_param = vim.g.weather_city
  elseif city ~= nil then
    city_param = city
  else
    city_param = ""
  end

  local command = string.format("curl https://wttr.in/%s'?'0", city_param)
  vim.api.nvim_call_function("termopen", {command})
end

-- closes floating window
function M.close_window()
  vim.api.nvim_win_close(win, true)
end

-- main function
function M.init()
  create_command()
end

return M
