return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        -- Load vscode style snippets from other plugins
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Build our own snippets here
        local ls = require "luasnip"
        local s = ls.snippet
        local t = ls.text_node
        local i = ls.insert_node

        ls.add_snippets("php", {
            s("hello", {
                t('print("hello world")')
            })
        })

        -- Setup keymaps
        vim.keymap.set(
            {"i", "s"},
            "<c-k>",
            function()
                if ls.expand_or_jumpable() then
                    ls.expand_or_jump()
                end
            end,
            { silent = true }
        )
    end
}

