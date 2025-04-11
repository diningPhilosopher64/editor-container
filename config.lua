-- Sourabh's custom config

-- Replace with current user
local user = "sourabh"

-- Update path to your init.lua of your custom config
local init_path = string.format("/home/%s/dotfiles/lvim/init.lua", user)
dofile(init_path)