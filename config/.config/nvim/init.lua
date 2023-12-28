-- [[
--     Brian Reich's Neovim configuration.
--
--     Sets up basic editor configurations such as tabbing to 4 spaces,
--     marker at column 80. Sets leader key to <space>, so in command mode
--     press space followed by command keys.
--
--     Sets up color scheme.
--
--     Sets up plugins.
-- ]]

-- Setup four-space tabbing
vim.cmd("set expandtab")
vim.cmd("set tabstop=4")
vim.cmd("set softtabstop=4")
vim.cmd("set shiftwidth=4")

-- Mark line 80
vim.cmd("set colorcolumn=80")

-- Setup Clipboard
vim.cmd("set clipboard+=unnamedplus")

-- Set vim "leader" key to space
vim.g.mapleader = " "

-- Automatically intend next line when appropriate.
vim.cmd("set autoindent")

-- [[ 
-- Setup the Lazy package manager. We are going to setup Lazy to load plugin
-- files from ~/.config/nvim/lua/plugins/*, so we can split up our
-- configuration into individual files for each plugin.
--
-- See: https://github.com/folke/lazy.nvim
-- ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
