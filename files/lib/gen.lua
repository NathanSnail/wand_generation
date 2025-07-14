---@class gen
local M = {}

---@class gen.Generator
---@field generate fun(self: gen.Generator): any[]
---@operator call(number): gen.ParameterisedGenerator
---@operator mul(gen.Generator): gen.SequenceGenerator

---@class gen.TerminalGenerator: gen.Generator
---@field terminal any

---@class gen.SequenceGenerator: gen.Generator
---@field left gen.Generator
---@field right gen.Generator

---@class gen.ParameterisedGenerator
---@field generator gen.Generator
---@field weight number

---@param dest table
---@param source table
---@return table
local function merge(dest, source)
	for k, v in pairs(source) do
		dest[k] = v
	end
	return dest
end

local parameterised_generator_mt, generator_mt, sequence_mt

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
		return setmetatable({ left = self, right = other }, sequence_mt)
	end,
}

local terminal_mt = merge({
	__index = {
		---@param self gen.TerminalGenerator
		---@return any
		generate = function(self)
			return { self.terminal }
		end,
	},
}, generator_mt)

sequence_mt = merge({
	__index = {
		---@param self gen.SequenceGenerator
		---@return any
		generate = function(self)
			local output = {}

			for _, v in ipairs(self.left:generate()) do
				table.insert(output, v)
			end
			for _, v in ipairs(self.right:generate()) do
				table.insert(output, v)
			end

			return output
		end,
	},
}, generator_mt)

---@param el any
---@return gen.TerminalGenerator
function M.terminal(el)
	return setmetatable({ terminal = el }, terminal_mt)
end

return M
