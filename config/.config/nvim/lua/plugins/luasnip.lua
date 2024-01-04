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

        -- Setup keymap for expand or jump
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
    
        -- Setup keymap for jump back
        vim.keymap.set(
            {"i", "s"},
            "<c-j>",
            function()
                if ls.jumpable(-1) then
                    ls.jump(-1)
                end
            end,
            { silent = true }
        )

        -- Setup keymap for list
        vim.keymap.set(
            "i",
            "<c-l>",
            function()
                if ls.choice_active() then
                    ls.change_choice(1)
                end
            end
        )

        -- Shortcut to souce luasnips which will reload snippets
        vim.keymap.set(
            "n",
            "<leader><leader>s",
            "<cmd>source ~/.config/nvim/lua/plugin/luasnip.lua<CR>"
        )

        -- Snippets, yay!
        ls.snippets = {
            all = {
                -- available to any file type
            },
            php = {
                ls.parser.parse_snippet("expand", "// this is what was expanded!")
            }
        }
    end
}

