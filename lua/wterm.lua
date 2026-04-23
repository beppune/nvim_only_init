
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

return Wterm
