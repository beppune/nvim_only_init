
local rust_analyzer_config = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { {'Cargo.tom'} },
    capabilities = require 'lspcap',
    settings = {
	['rust-analyzer'] = {
	    completion = {
		autoimport = {
		    enable = true
		},
	    },
	},
    },
}

vim.lsp.config('rust_analyzer', rust_analyzer_config)
vim.lsp.enable('rust_analyzer')

vim.keymap.set('i', ';', '<Esc>A;')
