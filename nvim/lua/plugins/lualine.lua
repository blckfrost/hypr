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
    event = { "BufReadPost", "BufAdd", "BufNewFile" },
    config = function()
        local lualine = require("lualine")
        local lazy_status = require("lazy.status")
        lualine.setup({
            options = {
                icons_enabled = true,
                globalstatus = vim.o.laststatus == 3,
                theme = "auto",
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
                        icon = { "", color = { fg = "#fc5603" } },
                    },
                    {
                        virtual_env,
                        color = { fg = "grey" },
                    },
                },
                lualine_c = {
                    {
                        "diagnostics",
                        update_in_insert = true,
                        symbols = { error = " ", warn = " ", hint = " ", info = " " },
                        diagnostics_color = {
                            error = { fg = "red" },
                        },
                    },
                    {
                        "filetype",
                        icon_only = true,
                        separator = "",
                        padding = { left = 1, right = 0 },
                    },
                    {
                        "filename",
                        symbols = { readonly = " 󰌾 " },
                        path = 4,
                    },

                    "searchcount",
                },
                lualine_x = {

                    -- {
                    --     function()
                    --         return require("noice").api.status.command.get()
                    --     end,
                    --     cond = function()
                    --         return package.loaded["noice"]
                    --             and require("noice").api.status.command.has()
                    --     end,
                    -- },

                    {
                        lazy_status.updates,
                        cond = lazy_status.has_updates,
                        -- color = { fg = "#ff9e75" },
                    },
                    {
                        "diff",
                        symbols = { added = " ", modified = " ", removed = " " },
                        diff_color = {
                            added = { fg = "#98be65" },
                            modified = { fg = "orange" },
                            removed = { fg = "red" },
                        },
                    },

                    {
                        "macro_recording",
                        fmt = show_macro_recording,
                        color = { fg = "red" },
                    },
                    -- "encoding",
                    -- "fileformat",
                },
                lualine_y = {
                    { "progress", separator = " ", padding = { left = 1, right = 0 } },
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
