---@class gen
local M = {}

---@class gen.Generator
---@field generate fun(self: gen.Generator): any[]
---@operator call(number): gen.ParameterisedGenerator
---@operator mul(gen.Generator): gen.SequenceGenerator

---@class gen.TerminalGenerator: gen.Generator
---@field private terminal any

---@class gen.SequenceGenerator: gen.Generator
---@field private left gen.Generator
---@field private right gen.Generator

---@class gen.ParameterisedGenerator
---@field private generator gen.Generator
---@field private weight number

---@param dest table
---@param source table
---@return table
local function merge(dest, source)
	for k, v in pairs(source) do
		dest[k] = v
	end
	return dest
end

local parameterised_generator_mt, generator_mt

generator_mt = {
	---@param self gen.Generator
	---@param weight number
	---@return gen.ParameterisedGenerator
	__call = function(self, weight)
		return setmetatable({ generator = self, weight = weight }, parameterised_generator_mt)
	end,

	---@param self gen.Generator
	---@param other gen.Generator
	---@return gen.SequenceGenerator
	__mul = function(self, other)
		return {}
	end,
}

local terminal_mt = merge({
	__index = {
		---@param self gen.TerminalGenerator
		---@return unknown
		generate = function(self)
			---@diagnostic disable-next-line: invisible
			return self.terminal
		end,
	},
}, generator_mt)

---@param el any
---@return gen.TerminalGenerator
function M.terminal(el)
	return setmetatable({ terminal = el }, terminal_mt)
end

return M
