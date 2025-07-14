---@class random
local M = {
	---If we are `TESTING` then these values from 0 to 1 will be used as the results of random
	---@type number[]
	testing_rng = {},
}

if not TESTING then
	function M.set_seed(x, y)
		SetRandomSeed(x, y)
	end
else
	function M.set_seed() end
end

if not TESTING then
	---0 -> real `[0, 1)`
	---1 -> int `[0, a]`
	---2 -> int `[a, b]`
	---@param a integer?
	---@param b integer?
	---@return number
	function M.random(a, b)
		return Random(a, b)
	end
else
	---0 -> real `[0, 1)`
	---1 -> int `[0, a]`
	---2 -> int `[a, b]`
	---@param a integer?
	---@param b integer?
	---@return number
	function M.random(a, b)
		local value = M.testing_rng[1]
		table.remove(M.testing_rng, 1)

		if a then
			b = b or 0
			return math.floor((b - a + 1) * value + a)
		end
		return value
	end
end

return M
