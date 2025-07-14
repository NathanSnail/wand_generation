---@class gen
local M = {}

local rng = require("files.lib.random")

---@class gen.Generator
---@field kind string
---@field generate fun(self: gen.Generator): any[]
---@operator call(number): gen.ParameterisedGenerator
---@operator mul(gen.Generator): gen.SequenceGenerator

---@class gen.TerminalGenerator: gen.Generator
---@field terminal any
---@field kind "gen.TerminalGenerator"

---@class gen.SequenceGenerator: gen.Generator
---@field left gen.Generator
---@field right gen.Generator
---@field kind "gen.SequenceGenerator"

---@class gen.ChoiceGenerator: gen.Generator
---@field choices gen.ParameterisedGenerator[]
---@field kind "gen.ChoiceGenerator"
---@operator add(gen.ParameterisedGenerator | gen.ChoiceGenerator): gen.ChoiceGenerator

---@class gen.WrappedGenerator: gen.Generator
---@field generator gen.Generator
---@field kind "gen.WrappedGenerator"

---@class gen.ParameterisedGenerator
---@field generator gen.Generator
---@field weight number
---@field kind "gen.ParameterisedGenerator"
---@operator add(gen.ParameterisedGenerator | gen.ChoiceGenerator): gen.ChoiceGenerator

---@param dest table
---@param source table
---@return table
local function merge(dest, source)
	for k, v in pairs(source) do
		dest[k] = v
	end
	return dest
end

---@param first any[]
---@param second any[]
---@return any[]
local function concat(first, second)
	local output = {}

	for _, v in ipairs(first) do
		table.insert(output, v)
	end
	for _, v in ipairs(second) do
		table.insert(output, v)
	end
	return output
end

local parameterised_generator_mt, generator_mt, sequence_mt

generator_mt = {
	---@param self gen.Generator
	---@param weight number
	---@return gen.ParameterisedGenerator
	__call = function(self, weight)
		return setmetatable(
			{ generator = self, weight = weight, kind = "gen.ParameterisedGenerator" },
			parameterised_generator_mt
		)
	end,

	---@param self gen.Generator
	---@param other gen.Generator
	---@return gen.SequenceGenerator
	__mul = function(self, other)
		return setmetatable(
			{ left = self, right = other, kind = "gen.SequenceGenerator" },
			sequence_mt
		)
	end,
}

local choice_mt

---@param a gen.ParameterisedGenerator | gen.ChoiceGenerator
---@param b gen.ParameterisedGenerator | gen.ChoiceGenerator
---@return gen.ChoiceGenerator
local function choice_add(a, b)
	---@param side gen.ParameterisedGenerator | gen.ChoiceGenerator
	---@return gen.Generator[]
	local function get_choices(side)
		if side.kind == "gen.ParameterisedGenerator" then
			return { side }
		else
			return side.choices
		end
	end

	local gens_a = get_choices(a)
	local gens_b = get_choices(b)
	local gens = concat(gens_a, gens_b)
	return setmetatable({ choices = gens, kind = "gen.ChoiceGenerator" }, choice_mt)
end

parameterised_generator_mt = { __add = choice_add }

local terminal_mt = merge({
	__index = {
		---@param self gen.TerminalGenerator
		---@return any[]
		generate = function(self)
			return { self.terminal }
		end,
	},
}, generator_mt)

sequence_mt = merge({
	__index = {
		---@param self gen.SequenceGenerator
		---@return any[]
		generate = function(self)
			-- we need left before right
			local left = self.left:generate()
			local right = self.right:generate()

			return concat(left, right)
		end,
	},
}, generator_mt)

choice_mt = merge({
	__add = choice_add,
	__index = {
		---@param self gen.ChoiceGenerator
		---@return any[]
		generate = function(self)
			local total_weight = 0
			for _, v in ipairs(self.choices) do
				total_weight = total_weight + v.weight
			end

			local cutoff = rng.random()
			local sum = 0
			for _, v in ipairs(self.choices) do
				sum = sum + v.weight
				if cutoff < sum / total_weight then return v.generator:generate() end
			end

			error(
				"gen.ChoiceGenerator didn't have any choices that were less than the random cutoff, impossible!"
			)
		end,
	},
}, generator_mt)

local wrapped_mt = merge({
	__index = {
		---@param self gen.WrappedGenerator
		---@return any[]
		generate = function(self)
			return self.generator:generate()
		end,
	},
}, generator_mt)

---@param el any
---@return gen.TerminalGenerator
function M.terminal(el)
	return setmetatable({ terminal = el, kind = "gen.TerminalGenerator" }, terminal_mt)
end

---This lets you nest choices, so (a | b) | c rather than a | b | c
---This is useful for more complex weight behaviours so that the choices are made seperately
---@param generator gen.Generator
---@return gen.WrappedGenerator
function M.wrap(generator)
	return setmetatable({ generator = generator, kind = "gen.WrappedGenerator" }, wrapped_mt)
end

return M
