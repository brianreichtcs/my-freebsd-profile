return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        -- Setup Treesitter
        local treeSitterConfig = require("nvim-treesitter.configs")
        treeSitterConfig.setup({
            ensure_installed = {
                "lua",
                "vim",
                "vimdoc",
                "javascript",
                "php"
            },
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            }
        })
    end
}

