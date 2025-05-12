return {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    enabled = true,
    main = "ibl",
    config = function()
        require("ibl").setup({
            indent = {
                char = "|",
                -- char = "┊",
                repeat_linebreak = false,
            },
            scope = {
                enabled = true,
                show_start = true,
                show_end = true,
                injected_languages = true,
            },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-treee",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                },
            },
        })
    end,
}
