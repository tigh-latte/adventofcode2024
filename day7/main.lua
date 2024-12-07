#!/usr/bin/env luajit

local input = arg[1] or "./day7/input.txt"

---@return integer[][]
local function read_file()
	local f = io.open(input, "r")
	if not f then error("failed to read file", 2) end

	local equations = {}
	for line in f:lines() do
		line = line --[[@as string]]

		local parts = {}
		for m in line:gmatch("([^: ]+)") do
			local num = tonumber(m)
			if not num then error("invalid input") end
			table.insert(parts, num)
		end

		table.insert(equations, parts)
	end

	f:close()

	return equations
end

---@param n integer
---@param ... string
local function iter_combinations(n, ...)
	local operators = { ... }
	local result = {}
	local function combine(current, remaining)
		if remaining == 0 then
			table.insert(result, current)
			return
		end

		for _, value in ipairs(operators) do
			local next = { unpack(current) }
			table.insert(next, value)
			combine(next, remaining - 1)
		end
	end

	combine({}, n)

	local i = 0
	return function()
		i = i + 1
		return result[i]
	end
end

local function part1()
	local eqs = read_file()

	local tally = 0

	for _, eq in ipairs(eqs) do
		local answer = eq[1]
		local operands = { unpack(eq, 2) }

		for comb in iter_combinations(#operands - 1, "+", "*") do
			local result = operands[1]
			for i = 2, #operands do
				result = ({
					["+"] = function(a, b) return a + b end,
					["*"] = function(a, b) return a * b end,
				})[comb[i - 1]](result, operands[i])
			end

			if result == answer then
				tally = tally + result
				break
			end
		end
	end

	return tally
end

local function part2()
	local eqs = read_file()

	local tally = 0

	for _, eq in ipairs(eqs) do
		local answer = eq[1]
		local operands = { unpack(eq, 2) }

		for comb in iter_combinations(#operands - 1, "+", "*", "|") do
			local result = operands[1]
			local ops = { result }
			for i = 2, #operands do
				result = ({
					["+"] = function(a, b) return a + b end,
					["*"] = function(a, b) return a * b end,
					["|"] = function(a, b) return tonumber(tostring(a) .. tostring(b)) end,
				})[comb[i - 1]](result, operands[i])
				table.insert(ops, comb[i - 1])
				table.insert(ops, operands[i])
			end

			if result == answer then
				tally = tally + result
				break
			end
		end
	end

	return tally
end

print("part 1:", string.format("%.0f", part1()))
print("part 2:", string.format("%.0f", part2()))
