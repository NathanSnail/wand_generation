local ansi = require("files.lib.ansi")

local FAIL = ansi.RED_FG .. ansi.BOLD
local PASS = ansi.GREEN_FG .. ansi.BOLD
local PARTIAL = ansi.YELLOW_FG .. ansi.BOLD

TESTING = true

---@class tests
local M = {
	passed = true,
	---@type string[]
	errors = {},
	rng = require("files.lib.random"),
}

---@class (exact) tests.test
---@field name string
---@field body fun()

---@param a any
---@param b any
---@return boolean
local function eq_impl(a, b)
	-- this way we don't need to do any traversal if they are obviously equal
	if rawequal(a, b) then return true end

	if type(a) ~= type(b) then return false end
	if type(a) == "table" then
		if not eq_impl(getmetatable(a), getmetatable(b)) then return false end

		for k, v in pairs(a) do
			if not eq_impl(rawget(b, k), v) then return false end
		end

		for k, v in pairs(b) do
			if not eq_impl(rawget(a, k), v) then return false end
		end

		return true
	end

	-- we weren't a table and weren't `rawequal` so we aren't equal
	-- functions don't get checked properly but idc
	return false
end

local function fail(reason)
	M.passed = false
	local info = debug.getinfo(3, "Sl")
	table.insert(
		M.errors,
		("%s[%s:%d]%s %s"):format(FAIL, info.short_src, info.currentline, ansi.RESET, reason)
	)
end

---@param any any
---@return string
local function pretty_print(any)
	if type(any) == "string" then return '"' .. any .. '"' end
	if type(any) == "table" then
		local s = "{"
		local len = #any
		for i = 1, len do
			s = s .. pretty_print(rawget(any, i)) .. ", "
		end
		for k, v in pairs(any) do
			if not (type(k) == "number" and 1 <= k and k <= len and math.fmod(k, 1) == 0) then
				s = s .. "[" .. pretty_print(k) .. "] = " .. pretty_print(v) .. ", "
			end
		end
		s = s .. "}"
		return s
	end
	return tostring(any)
end

---@param a any
---@param b any
function M.eq(a, b)
	if not eq_impl(a, b) then
		fail(("Expected %s == %s"):format(pretty_print(a), pretty_print(b)))
	end
end

---@param a any
---@param b any
function M.neq(a, b)
	if eq_impl(a, b) then fail(("Expected %s != %s"):format(pretty_print(a), pretty_print(b))) end
end

---@param tests tests.test[]
function M.test(tests)
	local num_passed = 0
	---@class test.Fail
	---@field number integer
	---@field name string

	---@type test.Fail[]
	local failed = {}
	for test_num, test in ipairs(tests) do
		M.passed = true
		M.errors = {}
		local succ, err = pcall(test.body)
		if not succ then fail("Got an error " .. err) end

		---@param col ansi.code
		---@param result string
		local function show_test(col, result)
			print(
				("%sTest %d/%d (%s) %s.%s"):format(
					col,
					test_num,
					#tests,
					test.name,
					result,
					ansi.RESET
				)
			)
		end
		if not M.passed then
			show_test(FAIL, "failed")
			for _, v in ipairs(M.errors) do
				print(v)
			end
			table.insert(failed, { number = test_num, name = test.name })
		else
			show_test(PASS, "passed")
			num_passed = num_passed + 1
		end
	end

	if #failed == 0 then
		print(("%sAll %d tests passed."):format(PASS, #tests))
	else
		print(
			("%s%d/%d tests passed"):format(num_passed ~= 0 and PARTIAL or FAIL, num_passed, #tests)
		)
	end
end

return M
