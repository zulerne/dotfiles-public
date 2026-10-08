local function setup()
	local downloads = os.getenv("HOME") .. "/Downloads"
	ps.sub("ind-sort", function(opt)
		local cwd = cx.active.current.cwd

		if tostring(cwd) == downloads then
			opt.by, opt.reverse, opt.dir_first = "mtime", true, false
		else
			opt.by, opt.reverse, opt.dir_first = "natural", false, true
		end

		return opt
	end)
end

return { setup = setup }
