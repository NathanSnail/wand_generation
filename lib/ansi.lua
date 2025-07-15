---@class ansi.code
---@operator concat(ansi.code): ansi.code

---@class ansi
local M = {
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	RESET = 0,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BOLD = 1,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BLACK_FG = 30,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BLACK_BG = 40,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	RED_FG = 31,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	RED_BG = 41,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	GREEN_FG = 32,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	GREEN_BG = 42,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	YELLOW_FG = 33,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	YELLOW_BG = 43,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BLUE_FG = 34,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BLUE_BG = 44,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	MAGENTA_FG = 35,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	MAGENTA_BG = 45,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	CYAN_FG = 36,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	CYAN_BG = 46,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	WHITE_FG = 39,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	WHITE_BG = 49,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_BLACK_FG = 90,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_BLACK_BG = 100,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_RED_FG = 91,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_RED_BG = 101,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_GREEN_FG = 92,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_GREEN_BG = 102,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_YELLOW_FG = 93,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_YELLOW_BG = 103,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_BLUE_FG = 94,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_BLUE_BG = 104,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_MAGENTA_FG = 95,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_MAGENTA_BG = 105,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_CYAN_FG = 96,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_CYAN_BG = 106,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_WHITE_FG = 97,
	---@type ansi.code
	---@diagnostic disable-next-line: assign-type-mismatch
	BRIGHT_WHITE_BG = 107,
}
for k, v in pairs(M) do
	---@diagnostic disable-next-line: assign-type-mismatch
	M[k] = ("%s[%dm"):format(string.char(27), v)
end

return M
