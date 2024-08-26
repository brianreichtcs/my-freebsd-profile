-- Mason is a Neovim plugin that allows you to easily mnage external editor
-- tooling such as LSP servers.
return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ansiblels",
                    "bashls",
                    "cssls",
                    "html",
                    "jsonls",
                    "intelephense",
                    "perlnavigator",
                    "sqlls"

                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({})
        end
    }
}

