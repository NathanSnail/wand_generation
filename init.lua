function get_setting(name)
	return tonumber(ModSettingGet("tweakeroo." .. name)) or 0
end

function get_setting_i(name)
	return math.floor(get_setting(name))
end

-- local zoom = get_setting_i("zoom")
-- print("\n\n\n\nyeah this is mod init\n\n\n\n")
-- print(tostring(ModSettingGet("tweakeroo.screenhax")))
-- if ModSettingGet("tweakeroo.screenhax") then
-- 	print("\n\n\n\nwow\n\n\n\n")
-- 	local content = ModTextFileGetContent("data/shaders/post_final.frag")
-- 	local pos = content:find("const float SCREEN_W = 427.0;")
-- 	local start = content:sub(1, pos-1)
-- 	local next = content:sub(pos + #
-- 		[[	const float SCREEN_W = 427.0;
-- 	const float SCREEN_H = 242.0;]])
-- 	local new = start ..
-- 	"\nconst float SCREEN_W = " .. zoom * 427 .. ".0;\n"..
-- 	"const float SCREEN_H = ".. zoom * 242 .. ".0;\n" ..
-- 	next
-- 	print(new)
-- 	ModTextFileSetContent("data/shaders/post_final.frag",new)
-- else
-- 	zoom = math.max(zoom, 1)
-- end

local content = "<MagicNumbers\n"
	.. "\n"
	.. 'VIRTUAL_RESOLUTION_X="'
	.. math.floor(get_setting("zoom") * 427)
	.. '"\n'
	.. 'VIRTUAL_RESOLUTION_Y="'
	.. math.floor(get_setting("zoom") * 242)
	.. '"\n'
	.. 'STREAMING_CHUNK_TARGET="'
	.. get_setting_i("chunks")
	.. '"\n'
	.. 'CAMERA_MOUSE_INTERPOLATION_SPEED="'
	.. 0.25 * get_setting("mouse")
	.. '"\n'
	.. 'CAMERA_POSITION_INTERPOLATION_SPEED="'
	.. 3.52 * get_setting("position")
	.. '"\n'
	.. 'DESIGN_DAY_CYCLE_SPEED="'
	.. 0.0015 * get_setting("day")
	.. '"\n'
	.. 'APPARITION_MIN_BONES_REQUIRED="'
	.. get_setting_i("bones")
	.. '"\n'
	.. 'BIOME_APPARITION_CHANCE="'
	.. get_setting_i("ghost")
	.. '"\n'
	.. 'CAMERA_RECOIL_AMOUNT="'
	.. get_setting("recoil")
	.. '"\n'
	.. 'CAMERA_RECOIL_ATTACK_SPEED="'
	.. 0.15 * get_setting("attack")
	.. '"\n'
	.. 'CAMERA_RECOIL_RELEASE_SPEED="'
	.. 15 * get_setting("release")
	.. '"\n'
	.. 'STREAMING_AUTOSAVE_PERIOD_SECONDS="'
	.. get_setting_i("autosave")
	.. '"\n'
	-- "DEBUG_GIF_WIDTH=\"" .. math.floor(get_setting("gif") * 640) .. "\"\n" ..
	-- "DEBUG_GIF_HEIGHT=\"" .. math.floor(get_setting("gif") * 360) .. "\"\n" ..
	-- "DEBUG_DEBUG_REPLAY_RECORDER_FPS=\"" .. get_setting_i("fps") .. "\"\n" ..
	-- "DEBUG_GIF_RECORD_60FPS=\"" .. ((get_setting_i("fps") >=1) and "1" or "0") .. "\"\n" ..
	.. 'UI_MAX_PERKS_VISIBLE="'
	.. get_setting_i("perk")
	.. '"\n'
	.. 'UI_LOW_HP_THRESHOLD="'
	.. get_setting("hp") / 25
	.. '"\n'
	.. 'UI_LOW_HP_WARNING_FLASH_FREQUENCY="'
	.. get_setting("flash")
	.. '"\n'
	.. 'REPORT_DAMAGE_SCALE="'
	.. get_setting("damage")
	.. '"\n'
	.. 'GRID_MAX_UPDATES_PER_FRAME="'
	.. get_setting_i("updates")
	.. '"\n'
	.. "GRID_MIN_UPDATES_PER_FRAME="
	.. get_setting_i("min")
	.. '"\n'
	.. "GRID_FLEXIBLE_MAX_UPDATES="
	.. get_setting_i("flex")
	.. '"\n'
	.. 'THROW_UI_TIMESTEP_COEFF="'
	.. get_setting_i("throw")
	.. '"\n'
	.. 'GRID_RENDER_TILE_SIZE="'
	.. get_setting_i("render")
	.. '"\n'
	.. 'DRAW_PARALLAX_BACKGROUND="'
	.. get_setting_i("bg")
	.. '"\n'
	.. 'DRAW_PARALLAX_BACKGROUND_BEFORE_DEPTH="'
	.. get_setting_i("parallax")
	.. '"\n'
	.. 'UI_WOBBLE_AMOUNT_DEGREES="'
	.. get_setting_i("degrees")
	.. '"\n'
	.. 'UI_WOBBLE_SPEED="'
	.. get_setting_i("wobble")
	.. '"\n'
	.. (get_setting_i("seed") == 0 and "" or ('WORLD_SEED="' .. get_setting_i("seed") .. '"\n'))
	-- -- "INVENTORY_STASH_X=\"" .. 185 .. "\"\n" ..
	-- -- "INVENTORY_STASH_Y=\"" .. 40 .. "\"\n" ..
	.. " >\n</MagicNumbers>"
ModTextFileSetContent("mods/tweakeroo/files/virtual_magic.xml", content)
ModMagicNumbersFileAdd("mods/tweakeroo/files/virtual_magic.xml")

-- render border and grid tile size are stupid
local c = ModTextFileGetContent("data/shaders/post_final.frag")
c = c:gsub(
	", tex_coord_fogofwar",
	", vec2(tex_coord_fogofwar.x,tex_coord_fogofwar.y - (1.0-"
		.. string.format("%.3f", get_setting("zoom"))
		.. ")*0.044)"
) -- fun ~= 0.044
ModTextFileSetContent("data/shaders/post_final.frag", c)

-- local c = ModTextFileGetContent("data/shaders/post_glow1.frag")
-- c = c:gsub("* offset",
-- 	"* offset /" ..
-- 	string.format("%.3f", get_setting("zoom")))
-- ModTextFileSetContent("data/shaders/post_glow1.frag", c)

-- local c = ModTextFileGetContent("data/shaders/post_glow2.frag")
-- c = c:gsub("* offset",
-- 	"* offset /" ..
-- 	string.format("%.3f", get_setting("zoom")))
-- ModTextFileSetContent("data/shaders/post_glow2.frag", c)
