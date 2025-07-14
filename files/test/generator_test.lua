local test = require("files.test.test")
-- test sets the TESTING global so it goes first

local generators = require("files.lib.generators")

test.test({
	{
		name = "Trivial terminal",
		body = function()
			test.eq(generators.terminal("test"):generate(), "test")
		end,
	},
})
