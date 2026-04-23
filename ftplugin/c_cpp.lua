
local clangd_config = {
    cmd = {'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed'},
    filetypes = { 'c', 'cpp' },
    root_markers = { '.git', 'compile_commands.json', 'compile_flags.txt' },
    capabilities = require 'lspcap',
}

vim.lsp.config('clangd', clangd_config)
vim.lsp.enable('clangd')

vim.keymap.set('i', ';', '<Esc>A;')

