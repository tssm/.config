local n = vim.api

local pack = {}
local pack_path = '~/.local/share/nvim/site/pack/'

pack.install = function(source, dest, branch)
	local dest_full_path = n.nvim_call_function('expand', { pack_path .. dest })
	if n.nvim_call_function('isdirectory', { dest_full_path }) == 0 then
		n.nvim_call_function('mkdir', { dest_full_path, 'p' })
		n.nvim_call_function('jobstart', {
			'git clone ' .. source .. ' ' .. dest_full_path ..
			' --branch ' .. branch .. ' --depth 1',
			{ detach = 1 }})
	else
		n.nvim_call_function('jobstart', {
			'cd ' .. dest_full_path .. '&& git pull ',
			{ detach = 1 }})
	end
end

return pack
