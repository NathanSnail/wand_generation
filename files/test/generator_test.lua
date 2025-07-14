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
	{
		name = "Choice",
		body = function()
			local choice = gen.terminal(1)(1) + gen.terminal(2)(1)
			test.rng.testing_rng = { 0.1 } -- we roll low so the first should part
			test.eq(choice:generate(), { 1 })
		end,
	},
	{
		name = "Chained Choices",
		body = function()
			local choice = gen.terminal(1)(1) + gen.terminal(2)(1) + gen.terminal(3)(1)
			-- if this isn't chained right, we'd out of bounds as we run out of rng values
			-- if this is chained right, we get the middle element
			test.rng.testing_rng = { 0.5 }
			test.eq(choice:generate(), { 2 })
		end,
	},
	{
		name = "Wrapped Choices",
		body = function()
			local choice = gen.wrap(gen.terminal(1)(1) + gen.terminal(2)(1))(1) + gen.terminal(3)(1)
			-- if this isn't chained right, we'd get 1 as the weight is low
			-- if this is chained right, we go low (first group) then high (2)
			test.rng.testing_rng = { 0.1, 0.9 }
			test.eq(choice:generate(), { 2 })
		end,
	},
})
