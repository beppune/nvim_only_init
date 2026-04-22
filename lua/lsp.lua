
local capabilities = require 'lspcap'

local root_markers1 = {
  '.emmyrc.json',
  '.luarc.json',
  '.luarc.jsonc',
}
local root_markers2 = {
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
}

local lua_lsp_config = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers1, root_markers2, { '.git' } }
    or vim.list_extend(vim.list_extend(root_markers1, root_markers2), { '.git' }),
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = 'Disable' },
      runtime = { version = 'LuaJIT' },
      diagnostics = {
	  globals = { 'vim' },
      },
      workspace = {
	  library = vim.api.nvim_get_runtime_file("", true)
      }
    },
  },
  capabilities = capabilities,
}

vim.lsp.config('lua_ls', lua_lsp_config)

