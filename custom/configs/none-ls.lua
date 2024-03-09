local null_ls = require("null-ls")
local null_ls_utils = require("null-ls.utils")

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

local eslintDiagnostics = require("none-ls.diagnostics.eslint_d")
local eslintFormatting = require("none-ls.formatting.eslint_d")

local root_has_file = function(files)
  return function(utils)
    return utils.root_has_file(files)
  end
end

local eslint_root_files = { ".eslintrc", ".eslintrc.js", ".eslintrc.json" }
local prettier_root_files = { ".prettierrc", ".prettierrc.js", ".prettierrc.json" }
local stylua_root_files = { "stylua.toml", ".stylua.toml" }

local opts = {
  eslint_formatting = {
    condition = function(utils)
      local has_eslint = root_has_file(eslint_root_files)(utils)
      local has_prettier = root_has_file(prettier_root_files)(utils)
      return has_eslint and not has_prettier
    end,
  },
  eslint_diagnostics = {
    condition = root_has_file(eslint_root_files),
  },
  prettier_formatting = {
    condition = root_has_file(prettier_root_files),
  },
  stylua_formatting = {
    condition = root_has_file(stylua_root_files),
  },
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  sources = {
    -- JS/TS
    eslintDiagnostics.with(opts.eslint_diagnostics),
    eslintFormatting.with(opts.eslint_formatting),
    formatting.prettier.with(opts.prettier_formatting),
    -- Lua
    formatting.stylua,
    -- Python
    formatting.black,
    diagnostics.mypy,
    -- Go
    formatting.gofumpt,           -- go install -v github.com/incu6us/goimports-reviser/v3@latest
    formatting.goimports_reviser, -- go install mvdan.cc/gofumpt@latest
    formatting.golines,           -- go install github.com/segmentio/golines@latest
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

