
-- #OPTIONS {{{
vim.o.shiftwidth = 4
vim.o.softtabstop = 4

vim.o.number = true

vim.o.background = "dark"
vim.cmd.colorscheme "catppuccin"

vim.o.cursorline = true
vim.o.signcolumn = 'yes'

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
	vim.opt_local.formatoptions:remove { "c", "r", "o" }
    end,
})

vim.o.foldmethod = 'marker'
vim.o.hlsearch = false

if vim.version().minor >= 12 then
    require 'vim._core.ui2'.enable({})
end
-- }}}

-- #MAPPINGS {{{
-- Esc
vim.keymap.set( 'i', 'jj', '<Esc>', { silent = true } )
vim.keymap.set( 'i', 'JJ', '<Esc>:', { silent = true } )
vim.keymap.set( 't', '<Esc>', '<C-\\><C-N>' , { silent = true })

-- Brackets
vim.keymap.set('n', 'ç', '%')

-- Windows
vim.g.mapleader = ' '
vim.keymap.set( 'n', '<Leader>x', '<C-W>x', { silent = true } )
vim.keymap.set( 'n', '<Leader>o', '<C-W>o', { silent = true } )
vim.keymap.set( 'n', '<Leader>c', '<C-W>c', { silent = true } )
vim.keymap.set( 'n', '<Leader>v', '<C-W>v', { silent = true } )
vim.keymap.set( 'n', '<Leader>q', '<C-W>q', { silent = true } )
vim.keymap.set( 'n', '<Leader>w', '<C-W>w', { silent = true } )

-- Tabs
vim.keymap.set( 'n', '<Leader>t', ':tabnew<CR>', { silent = true })
vim.keymap.set( 'n', '<Leader>n', ':tabnext<CR>', { silent = true })

-- Command line
vim.keymap.set( 'n', '<Leader>g', ':', { silent = true })
vim.keymap.set( 'n', '<Leader>s', '/', { silent = true })
vim.keymap.set( 'c', 'jj', '<Esc>', { silent = true })
-- }}}

-- #PLUGINS {{{
vim.pack.add({
    { src = "https://github.com/L3MON4D3/LuaSnip.git", name = "luasnip" },
    { src = "https://github.com/nvim-lua/plenary.nvim.git" },
    { src = "https://github.com/nvim-telescope/telescope.nvim.git", name = "telescope", load = true },
    { src = "https://github.com/nvim-lualine/lualine.nvim", name = "lualine", load = true },
    { src = "https://github.com/saghen/blink.cmp.git", name = "blink.cmp" },
    { src = "https://github.com/NeogitOrg/neogit.git", name = "neogit" }
})

require 'lualine'.setup({options={theme='dracula'}})

-- }}}

-- #TELESCOPE {{{
local ts = require 'telescope.builtin'
vim.keymap.set('n', '<leader>ff', ts.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fb', ts.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', ts.help_tags, { desc = 'Telescope help tags' })
-- }}}

-- #LSP {{{
vim.diagnostic.config({
    virtual_text = true,
    float = {
	show_header = true,
	source = 'if_many',
	border = 'rounded',
	focusable = false,
    },
    update_in_insert = true,
    signs = true
})

vim.lsp.config('*', {
    on_attach = function(_, bufnr)
	vim.keymap.set( 'n', 'grd', function ()
	    vim.diagnostic.open_float()
	end, { desc = 'Show Diagnostic float message', silent = true })

	vim.keymap.set( 'n', '<Leader>d', function()
	    vim.diagnostic.jump { count=1, float=true }
	end, { buffer = bufnr })

	vim.keymap.set( 'n', '<Leader>s', function()
	    vim.diagnostic.jump { count=-1, float=true }
	end, { buffer = bufnr })

	vim.keymap.set( 'n', 'ghh', function()
	    vim.lsp.buf.hover()
	end, { buffer = bufnr })

	-- Options {{
	vim.o.relativenumber = true
	vim.o.fileformat='unix'

	-- Reload Blink {{
	package.loaded['blink.cmp'] = nil
	require('blink.cmp').setup({
	    keymap = {
		preset = 'super-tab'
	    },
	    sources = {
		default = { 'lsp', 'path', 'snippets', 'buffer' },
	    },
	    fuzzy = {
		implementation = 'lua'
	    },
	})
    end
})

-- }}}

-- #MODULES {{{
require 'wterm'
-- }}}
