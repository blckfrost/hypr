return {

    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },

    config = function()
        local nvim_lsp = require("lspconfig")

        local keymap = vim.keymap

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local opts = { noremap = true, silent = true }

        local on_attach = function(client, bufnr)
            opts.buffer = bufnr

            opts.desc = "Restart Lsp"
            keymap.set("n", "<leader>ls", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

            opts.desc = "Lsp Info"
            keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", opts)

            opts.desc = "Show buffer diagnostics"
            keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show diagnostics for file

            opts.desc = "Show LSP references"
            keymap.set("n", "<leader>lR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

            opts.desc = "Show available code actions"
            keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions

            opts.desc = "Show lsp definitions"
            keymap.set("n", "<leader>lD", "<cmd>Lspsaga goto_definition <cr>", opts)

            opts.desc = "Show line diagnostics"
            keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- shows diagnostics for a line

            opts.desc = "Go to previous diagnostic"
            keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

            opts.desc = "Go to next diagnostic"
            keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

            opts.desc = "Show documentation for what is under cursor"
            keymap.set("n", "K", vim.lsp.buf.hover, opts)

            opts.desc = "Rename all ref of symbol under cursor"
            keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, opts)

            opts.desc = "Sig help"
            keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, opts)

            if client.server_capabilities.inlayHintProvider then
                -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                vim.lsp.inlay_hint.enable(true)
            else
                vim.lsp.inlay_hint.enable(false)
            end
        end

        --  default server configurations
        local servers = {
            "bashls",
            "html",
            "clangd",
            "ts_ls",
            "lua_ls",
            "eslint",
            "marksman",
            "tailwindcss",
            "pyright",
            "rust_analyzer",
            "texlab",
            "jsonls",
            "sqlls",
            "postgres_lsp",
            "prismals",
        }

        for _, lsp in ipairs(servers) do
            nvim_lsp[lsp].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end

        -- [C/C++]
        nvim_lsp.clangd.setup({
            capabilities = {
                offsetEncoding = { "utf-16" },
                capabilities, -- for cmp stuff
            },
            on_attach = on_attach,
            cmd = { "clangd", "-j=4", "--inlay-hints" },
        })

        -- [CSS]
        nvim_lsp.cssls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "css", "less", "scss", "sass" },
        })

        -- [GO]
        nvim_lsp.gopls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            cmd = { "gopls" },
            root_markers = { "go.work", "go.mod", ".git" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            settings = {
                gopls = {
                    completeUnimported = true,
                    usePlaceholders = true,
                    semanticTokens = true,
                    staticcheck = true,
                    analyses = {
                        unusedparams = true,
                        useany = true,
                        nilness = true,
                        unusedwrite = true,
                    },
                    hints = {
                        assignVariableTypes = true,
                        compositeLiteralFields = true,
                        compositeLiteralTypes = true,
                        constantValues = true,
                        functionTypeParameters = true,
                        parameterNames = true,
                        rangeVariableTypes = true,
                    },

                    codelenses = {
                        gc_details = false,
                        generate = true,
                        regenerate_cgo = true,
                        run_govulncheck = true,
                        test = true,
                        tidy = true,
                        upgrade_dependency = true,
                        vendor = true,
                    },
                },
            },
        })

        nvim_lsp.tailwindcss.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
                "html",
                "css",
                "javascript",
                "javascriptreact",
                "javascript",
                "typescript",
                "typescriptreact",
                "jsx",
                "tsx",
            },
        })
        nvim_lsp.html.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "html", "javascriptreact", "typescriptreact" },
        })

        nvim_lsp.ts_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = {
                "javascript",
                "javascriptreact",
                "javascript.jsx",
                "typescript",
                "typescriptreact",
                "typescript.tsx",
            },
            settings = {
                typescript = {
                    updateImportsOnFileMove = { enabled = "always" },
                    inlayHints = {
                        includeInlayEnumMemberValueHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayParameterNameHints = "literals", -- 'none' | 'literals' | 'all';
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayVariableTypeHints = true,
                    },
                    suggest = { suggestFunctionCalls = true },
                },
                javascript = {
                    updateImportsOnFileMove = { enabled = "always" },
                    inlayHints = {
                        includeInlayEnumMemberValueHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayVariableTypeHints = true,
                    },
                },
            },
        })

        vim.diagnostic.config({
            virtual_text = { spacing = 1, prefix = "󰊠 " },
            update_in_insert = false,
            severity_sort = true,
            underline = true,
            float = {
                focusable = true,
                spacing = 2,
                style = "minimal",
                border = "rounded",
                source = "if_many",
                header = { "  Diagnostics", "String" },
                suffix = "",
                prefix = function(_, _, _)
                    return "  ", "String"
                end,
            },

            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.INFO] = "󰋼 ",
                    [vim.diagnostic.severity.HINT] = " ",
                    hint = " ",
                },

                texthl = {
                    [vim.diagnostic.severity.ERROR] = "Error",
                    [vim.diagnostic.severity.WARN] = "Error",
                    [vim.diagnostic.severity.HINT] = "Hint",
                    [vim.diagnostic.severity.INFO] = "Info",
                },
                numhl = {
                    [vim.diagnostic.severity.ERROR] = "",
                    [vim.diagnostic.severity.WARN] = "",
                    [vim.diagnostic.severity.HINT] = "",
                    [vim.diagnostic.severity.INFO] = "",
                },
            },
        })

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
            border = "rounded",
            title = "hover",
        })

        vim.lsp.handlers["textDocument/signatureHelp"] =
            vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "single",
                title = "Sig help",
            })

        -- INLAY HINTS
        -- vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#a0a0a0", italic = true })
        if vim.lsp.inlay_hint then
            vim.keymap.set("n", "<Space>ih", function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, { desc = "Toggle Inlay Hints" })
        end
    end,
}
