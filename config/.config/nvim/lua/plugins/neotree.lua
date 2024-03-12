return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        "3rd/image.nvim"
    },
    opts = {
        filesystem = {
            filtered_items = {
                -- Show filtered items
                visible = true,
                -- Show the number of hidden files
                show_hidden_count = true,
                -- Don't hide .files
                hide_dot_files = false,
                -- Don't hide files listed in .gitignore
                hide_gitignored = false
            }
        }
    },
    config = function()
        vim.keymap.set('n', '<C-n>', ':Neotree filesystem toggle reveal left<CR>')
    end
}

