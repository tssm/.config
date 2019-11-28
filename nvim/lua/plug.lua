local n = vim.api
local pack_path = '~/.local/share/nvim/site/pack/'

plug = function(source, dest, branch, callback)
	local dest_full_path = n.nvim_call_function('expand', { pack_path .. dest })
	if n.nvim_call_function('isdirectory', { dest_full_path }) == 0 then
		n.nvim_call_function('mkdir', { dest_full_path, 'p' })
		local job = 'git clone ' .. source .. ' ' .. dest_full_path ..
			' --branch ' .. branch .. ' --depth 1'
		if callback then
			job = job .. ' && cd ' .. dest_full_path .. ' && ' .. callback
		end
		-- TODO Assign the callback to on_exit when support for Lua's functions is
		-- added
		n.nvim_call_function('jobstart', { job, { detach = 1 }})
	else
		local job = 'sh -c "PREV_COMMIT=`git rev-parse HEAD` && git pull && ' ..
			'if [ $PREV_COMMIT != `git rev-parse HEAD` ]; then ' ..
			(callback or 'exit 0') .. '; fi"'
		n.nvim_call_function('jobstart', { job,
			{ cwd = dest_full_path, detach = 1 }})
		-- TODO Assign the callback to on_exit when support for Lua's functions is
		-- added
	end

	-- TODO Call after callbak when support for Lua's functions is added
	local doc_path = dest_full_path .. '/doc'
	if n.nvim_call_function('isdirectory', { doc_path }) ~= 0 then
		n.nvim_command('helptags ' .. doc_path)
	end
end
