
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

-- Quotes
vim.keymap.set({ 'n', 'i' }, '°', '\'')

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

-- Diagno
vim.keymap.set( 'n', 'grd', function ()
    vim.diagnostic.open_float()
end, { desc = 'Show Diagnostic float message', silent = true })

-- }}}

-- #PLUGINS MANAGEMENT  {{{
vim.pack.add({
    { src = "https://github.com/L3MON4D3/LuaSnip.git", name = "luasnip" },
    { src = "https://github.com/nvim-lua/plenary.nvim.git" },
    { src = "https://github.com/nvim-telescope/telescope.nvim.git", name = "telescope" },
    {
	src = "https://github.com/nvim-lualine/lualine.nvim",
        name = "lualine",
	load = true
    },
    {
	src = "https://github.com/saghen/blink.cmp.git",
	name = "blink.cmp",
	load = true,
	-- See LSP section below
    },
    {
	src = "https://github.com/NeogitOrg/neogit.git",
	name = "neogit",
	load = true,
    }
})

require 'lualine'.setup({theme = 'horizon'})

vim.api.nvim_create_autocmd({'BufEnter'}, {
    pattern = 'init.lua',
    callback = function()
	local ls = require 'luasnip'
	local s = ls.snippet local t = ls.text_node local i = ls.insert_node

	local ft = s('ft', {
	    t('-- #'), i(1), t( { ' {{{',  '-- }}}' }),
	})

	ls.add_snippets("lua", { ft })

	vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
	vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
	vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})
    end
})

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
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities = require 'blink.cmp'.get_lsp_capabilities(capabilities)

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

vim.lsp.config('*', {
    on_attach = function(_, bufnr)
	vim.keymap.set( 'n', '<Leader>d', function()
	    vim.diagnostic.jump { count=1, float=true }
	end, { buffer = bufnr })

	vim.keymap.set( 'n', '<Leader>s', function()
	    vim.diagnostic.jump { count=-1, float=true }
	end, { buffer = bufnr })

	vim.keymap.set( 'n', 'ghh', function()
	    vim.lsp.buf.hover()
	end, { buffer = bufnr })

	-- Options {{{2
	vim.o.relativenumber = true
	vim.o.fileformat='unix'
	-- }}}

	-- Reload Blink {{{2
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
	vim.notify("Blink loaded", vim.log.levels.INFO)
	-- }}}
    end
})

-- #LUA_LS {{{2
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
-- }}}

-- #RURST_ANALYZER {{{2
local rust_analyzer_config = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { {'Cargo.tom'} },
    capabilities = capabilities,
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
-- }}}

-- #CLANGD {{{2
local clangd_config = {
    cmd = {'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed'},
    filetypes = { 'c', 'cpp' },
    root_markers = { '.git', 'compile_commands.json', 'compile_flags.txt' },
    capabilities = capabilities,
}
-- }}}

vim.lsp.config('lua_ls', lua_lsp_config)
vim.lsp.config('rust_analyzer', rust_analyzer_config)
vim.lsp.config('clangd', clangd_config)

vim.api.nvim_create_autocmd( {'FileType'}, {
    pattern = {'rust'},
    callback = function ()
	vim.lsp.enable('rust_analyzer')
	vim.keymap.set('n', '<F9>', ':Wterm cargo run<CR>')
    end
})

vim.api.nvim_create_autocmd( {'FileType'}, {
    pattern = {'lua'},
    callback = function ()
	vim.lsp.enable('lua_ls')
    end
})

vim.api.nvim_create_autocmd( {'FileType'}, {
    pattern = {'c', 'cpp'},
    callback = function ()
	vim.lsp.enable('clangd')
    end
})

-- }}}

-- #WTERM {{{2
function makeWterm()
    local Wterm = {
	show = function (cmdline)
	    -- calc term geometry
	    local ww = vim.api.nvim_win_get_width(0)
	    local wh = vim.api.nvim_win_get_height(0)
	    local width = math.floor(ww * 0.8)
	    local height = math.floor(wh * 0.8)

	    local col = math.floor((ww - width)/2)
	    local row = math.floor((wh - height)/2)

	    -- create buffer
	    local buf = vim.api.nvim_create_buf(false, false)
	    -- create window
	    local _ = vim.api.nvim_open_win(buf, true, {
		border = 'rounded',
		relative = 'editor',
		style = 'minimal',
		title = 'wterm',
		row = row,
		col = col,
		height = height,
		width = width,
	    })
	    -- open term in buffer
	    vim.api.nvim_buf_call(buf, function ()
		---@diagnostic disable-next-line: deprecated
		local ch = vim.fn.termopen(vim.o.shell)
		if cmdline ~= nil then
		    vim.api.nvim_chan_send(ch, cmdline .. "\r\n")
		else
		    vim.cmd('startinsert')
		end
	    end)
	end
    }
    vim.api.nvim_create_user_command('WRun', function (opts)
	if #opts.args == 0 then
	    return
	end
	if package.loaded['wterm'] ~= nil then
	    package.loaded['wterm'].show(opts.args)
	end
    end, {nargs = '*'})
    return Wterm
end

package.loaded['wterm'] = makeWterm()
-- }}}

