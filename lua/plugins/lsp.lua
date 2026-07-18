vim.pack.add({
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/folke/lazydev.nvim" },
    { src = "https://github.com/Bilal2453/luvit-meta" },
    { src = "https://github.com/mason-org/mason.nvim" },
})

-- lazydev -----------------------------------------
require("lazydev").setup({
    ft = "lua",
    library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
})

require("mason").setup({})

-- lsp setup ---------------------------------------
vim.lsp.enable({
    "gleam",
    "elp",
    "lua_ls",

    -- python
    "ruff",
    "ty",

    -- nix
    "nil_ls",

    -- inclusivity
    "woke",

    -- web
    "prettier",
    "biome",
    "cssls",

    -- rust
    "rust_analyzer",

    -- markdown
    "markdown_oxide",

    -- toml
    "taplo",
})

-- keybinds / settings
vim.keymap.set("n", "<leader>ff", vim.lsp.buf.format, { desc = "Format File" })

vim.lsp.inlay_hint.enable(true)

-- format on write
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(event)
        vim.lsp.buf.format({ bufnr = event.buf })
    end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
        -- Function to map specific lsp related items
        local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gb', "''", '[G]o [B]ack')
        map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
        map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', "v")
        map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclartion')


        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = true })

            -- Highlight references of the word under cursor when cursor rests for a little while
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            -- Clear highlights when cursor moves again
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = event.buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })

            -- handle LspDetach
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.api.nvim_create_autocmd({ 'LspDetach' }, {
                group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                callback = function(event2)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                end,
            })
        end
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
        end
    end,
})
