local test = require("files.test.test")
-- test sets the TESTING global so it goes first

local gen = require("files.lib.gen")

test.test({
	{
		name = "Trivial terminal",
		body = function()
			test.eq(gen.terminal("test"):generate(), { "test" })
		end,
	},
	{
		name = "Sequence",
		body = function()
			---@type gen.SequenceGenerator
			local sequence = gen.terminal(1) * gen.terminal(2)
			test.eq(sequence:generate(), { 1, 2 })
		end,
	},
	{
		name = "Long Sequence",
		body = function()
			local one = gen.terminal(1)
			local two = gen.terminal(2)
			local sequence = one * two * one * two
			test.eq(sequence:generate(), { 1, 2, 1, 2 })
		end,
	},
})
