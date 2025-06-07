return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = function()
        require("gitsigns").setup({
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            auto_attach = true,
            signcolumn = true, -- Toggle with ':Gitsigns toggle_signs'
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pox = "eol", -- eol | overlay | right_align
            },
        })
    end,
}
