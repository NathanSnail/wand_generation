local test = require "files.test.test"

test.test({
	{
		name = "Testing setup works",
		body = function()
			test.eq(1 + 1, 2)
		end,
	},
	{
		name = "Failing",
		body = function()
			test.eq(1, 2)
		end,
	},
	{
		name = "Tables",
		body = function()
			test.eq({ 1, 2, 3 }, { 1, 2, 3 })
		end,
	},
	{
		name = "Failing tables",
		body = function()
			test.eq({}, { 1 })
		end,
	},
	{
		name = "Failing Throwing",
		body = function()
			error("boom")
		end,
	},
	{
		name = "Not Equal",
		body = function()
			test.neq(1, 2)
		end,
	},
	{
		name = "Failing Not Equal",
		body = function()
			test.neq(1, 1)
		end,
	},
})
