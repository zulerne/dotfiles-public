-- Floating panes, one per tool and window. The key opens the pane in the
-- focused pane's directory; pressed again it minimizes the pane, and once more
-- brings it back. Quitting the program closes the pane.
--
-- Fields: key, name (action name: lowercase letters, digits, underscores),
-- title (command palette), command (argv; a shell when omitted), bounds
-- ({x, y, w, h} as fractions of the window; default_bounds when omitted),
-- keywords (extra command palette search words).
local default_bounds = { 0.05, 0.05, 0.9, 0.9 }

local floats = {
	{ key = "cmd+s", name = "scratch_float", title = "Scratch Terminal", keywords = "scratch terminal shell" },
	{ key = "cmd+g", name = "lazygit_float", title = "Lazygit", command = { "lazygit" }, keywords = "git" },
	{ key = "cmd+y", name = "yazi_float", title = "Yazi", command = { "yazi" }, keywords = "files manager" },
}

local terminal = "com.superlogical.terminal"

-- Return a call's result, raising its error instead of ignoring it.
local function check(result, err)
	if err then
		error(err)
	end
	return result
end

-- The focused pane's directory: what the shell last reported, else its foreground process.
local function focused_cwd(ctx)
	local pwd = rex.block.call(terminal, "pwd", { block_id = ctx.block_id })
	if pwd and pwd.pwd then
		return (pwd.pwd:gsub("^file://[^/]*", ""))
	end
	local proc = rex.block.call(terminal, "process", { block_id = ctx.block_id })
	return proc and proc.foreground and proc.foreground.cwd
end

local function has_block(layer, block_id)
	for _, block in ipairs(layer.blocks) do
		if block.block_id == block_id then
			return true
		end
	end
	return false
end

-- The window holding block_id, else the active one.
local function current_window(view, block_id)
	local active
	for _, window in ipairs(view.windows) do
		for _, layer in ipairs(window.layers) do
			if has_block(layer, block_id) then
				return window
			end
		end
		if window.window_id == view.active_window_id then
			active = window
		end
	end
	return active
end

-- The floating layer in window with a block labelled label.
local function find_float(window, label)
	for _, layer in ipairs(window.layers) do
		if layer.kind == "floating" then
			for _, block in ipairs(layer.blocks) do
				if block.label == label then
					return layer
				end
			end
		end
	end
end

local function toggle_float(spec, ctx)
	local label = "float:" .. spec.name
	local window = current_window(check(rex.session.view({})), ctx.block_id)
	local layer = window and find_float(window, label)

	if not layer then
		check(rex.session.new_layer({
			window_id = window and window.window_id,
			bounds = spec.bounds or default_bounds,
			layout = rex.layout.block({
				flavor = terminal .. ".shell",
				label = label,
				options = { command = spec.command, cwd = focused_cwd(ctx) },
			}),
			focus = true,
		}))
	elseif layer.state ~= "minimized" and has_block(layer, window.focused_block_id) then
		check(rex.session.set_layer_state({ layer_id = layer.layer_id, state = "minimized" }))
	else
		-- Minimized, or visible behind another pane: bring it forward.
		check(rex.session.set_layer_state({ layer_id = layer.layer_id, state = "normal", focus = true }))
	end
end

for _, spec in ipairs(floats) do
	rex.action({
		name = spec.name,
		title = spec.title,
		keywords = (spec.keywords or "") .. " float",
		run = function(ctx)
			toggle_float(spec, ctx)
		end,
	})
	if spec.key then
		rex.bind(spec.key, spec.name)
	end
end
