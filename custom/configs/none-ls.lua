local null_ls = require("null-ls")
local null_ls_utils = require("null-ls.utils")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local eslintDiagnostics = require("none-ls.diagnostics.eslint")
local eslintFormatting = require("none-ls.formatting.eslint")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
  sources = {
    eslintDiagnostics,
    eslintFormatting.with({
      condition = function(utils)
        return utils.root_has_file(".eslintrc.js") and not utils.root_has_file(".prettierrc")
      end,
    }),
    formatting.prettier.with({
      condition = function(utils)
        return utils.root_has_file(".prettierrc")
      end,
      extra_filetypes = { "svelte" },
    }),
    formatting.stylua,
    -- Python
    formatting.black,
    diagnostics.mypy,
    -- Golang
    formatting.gofumpt,               -- go install -v github.com/incu6us/goimports-reviser/v3@latest
    formatting.goimports_reviser,     -- go install mvdan.cc/gofumpt@latest
    formatting.golines,               -- go install github.com/segmentio/golines@latest
  },
  -- configure format on save
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})
