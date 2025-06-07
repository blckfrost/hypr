-- To show Macro recording message in Lualine
local function show_macro_recording()
    local recording_register = vim.fn.reg_recording()
    if recording_register == "" then
        return ""
    else
        return "recording @" .. recording_register
    end
end

local function virtual_env()
    if vim.bo.filetype ~= "python" then
        return ""
    end

    local venv_path = os.getenv("VIRTUAL_ENV")
    if venv_path then
        local venv_name = vim.fn.fnamemodify(venv_path, ":t")
        return string.format(" %s", venv_name)
    end
end

return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")
        lualine.setup({
            options = {
                icons_enabled = true,
                globalstatus = vim.o.laststatus == 3,
                -- theme = "auto",
                theme = {
                    normal = {
                        c = { fg = "#b4befe" },
                    },
                    inactive = {
                        c = { fg = "#b4befe" },
                    },
                },
                component_separators = "",
                section_separators = "",
                always_divide_middle = true,
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    {
                        "branch",
                        -- color #fc5603 reddish
                        icon = { "", color = { fg = "#b4befe" } },
                        color = { fg = "#cdd6f4", gui = "italic,bold" },
                        padding = 1,
                    },
                    {
                        virtual_env,
                        color = { fg = "grey" },
                    },
                },
                lualine_c = {
                    {
                        "diagnostics",
                        padding = 1,
                        update_in_insert = true,
                        symbols = {
                            error = " ",
                            warn = " ",
                            info = " ",
                            hint = " ",
                        },
                        diagnostics_color = {
                            error = { fg = "red" },
                        },
                    },
                    "%=",
                    {
                        "filetype",
                        icon_only = true,
                        separator = ".",
                        padding = { left = 1, right = 0 },
                        colored = false,
                    },
                    {

                        "filename",
                        file_status = true,
                        newfile_status = false,
                        path = 1,
                        padding = 1,
                        color = { fg = "#cdd6f4" },
                    },

                    "searchcount",
                },
                lualine_x = {

                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                    },
                    {
                        "diff",
                        symbols = { added = " ", modified = " ", removed = " " },
                        diff_color = {
                            added = { fg = "#98be65" },
                            modified = { fg = "orange" },
                            removed = { fg = "red" },
                        },
                        padding = 1,
                    },

                    {
                        "macro_recording",
                        fmt = show_macro_recording,
                        color = { fg = "red" },
                        icon = { "󰑋" },
                    },
                    -- "encoding",
                    -- "fileformat",
                },
                lualine_y = {
                    {
                        "progress",
                        padding = 1,
                        color = { fg = "#cdd6f4" },
                    },
                    {
                        "location",
                        icon = { "󰍒", align = "right" },
                        padding = { left = 0, right = 1 },
                    },
                },
                lualine_z = {

                    function()
                        return " " .. os.date("%R")
                    end,
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", file_status = true, path = 1 } },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            disabled_filetypes = { "alpha", "NvimTree" },
            extensions = { "fugitive", "nvim-tree", "lazy", "fzf" },
        })
    end,
}
