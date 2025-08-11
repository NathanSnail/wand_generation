if TESTING then return end
---@param modname string
---@return any
function require(modname)
	return dofile_once(("mods/wand_generation/%s.lua"):format((modname:gsub("%.", "/"))))
end
