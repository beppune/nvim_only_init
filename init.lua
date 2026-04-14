-- #HELPERS {{{
function _G.ReloadPlugin(name)
    local status, result = pcall(require(name))
    if not status then
	vim.notify( result, vim.log.level.INFO )
	return false
    end
    return result
end
-- }}}

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
vim.keymap.set( 'i', 'jj', '<Esc>', { silent = true } )
vim.keymap.set( 'i', 'JJ', '<Esc>:', { silent = true } )

vim.g.mapleader = ' '
vim.keymap.set( 'n', '<Leader>x', '<C-W>x', { silent = true } )
vim.keymap.set( 'n', '<Leader>o', '<C-W>o', { silent = true } )
vim.keymap.set( 'n', '<Leader>c', '<C-W>c', { silent = true } )
vim.keymap.set( 'n', '<Leader>v', '<C-W>v', { silent = true } )
vim.keymap.set( 'n', '<Leader>q', '<C-W>q', { silent = true } )

vim.keymap.set( 'n', '<Leader>w', '<C-W>w', { silent = true } )

vim.keymap.set( 'n', '<Leader>t', ':tabnew<CR>', { silent = true })
vim.keymap.set( 'n', '<Leader>n', ':tabnext<CR>', { silent = true })

vim.keymap.set( 't', '<Esc>', '<C-\\><C-N>' , { silent = true })

vim.keymap.set( 'n', '<CR>', 'zA' , { silent = true })

vim.keymap.set( 'n', 'grd', function ()
    vim.diagnostic.open_float()
end, { desc = 'Show Diagnostic float message', silent = true })
-- }}}

-- #PLUGINS MANAGEMENT  {{{
vim.pack.add({
    { src = "https://github.com/L3MON4D3/LuaSnip.git", name = "luasnip" },
})

vim.api.nvim_create_autocmd({'BufEnter'}, {
    pattern = 'init.lua',
    callback = function(args)
	local ls = require 'luasnip'
	local s = ls.snippet local t = ls.text_node local i = ls.insert_node

	local ft = s('ft', {
	    t('-- #'), i(1), t( { ' {{{',  '-- }}}' }),
	})

	ls.add_snippets("all", { ft })

	vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
	vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
	vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
    end
})
-- }}}

