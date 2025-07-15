if TESTING then return end
---@param path string
---@return any
function require(path)
	local full_path = "mods/wand_generation"
	for part in path:gmatch("[^.]+") do
		full_path = full_path .. "/" .. part
	end
	full_path = full_path .. ".lua"
	return dofile_once(full_path)
end
