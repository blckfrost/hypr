return {
    "lervag/vimtex",
    lazy = false,
    ft = { "tex", "plaintex", "bib" },
    config = function()
        vim.g.vimtex_view_method = "zathura"
        vim.g.vimtex_compiler_method = "latexrun"
        vim.g.vimtext_compiler_latexrun = {
            options = { "-pdf", "interaction=nonstopmod", "-synctex=1" },
        }
        vim.keymap.set("n", "<leader>ll", function()
            vim.cmd("VimtexCompile")
        end)
        vim.cmd([[
        filetype plugin indent on
        ]])
    end,
}
