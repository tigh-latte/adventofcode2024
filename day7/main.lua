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

local function iter_ops(n, ...)
	local operators = { ... }
	local stack = { { index = 1, combination = {} } }

	---@return string[]?
	return function()
		if #stack == 0 then
			return
		end

		while true do
			local state = table.remove(stack)
			local current = state.combination
			local idx = state.index

			if #current == n then
				return current
			end

			for i = #operators, 1, -1 do
				local comb = { unpack(current) }
				table.insert(comb, operators[i])
				table.insert(stack, { index = idx + 1, combination = comb })
			end
		end
	end
end

local function part1()
	local eqs = read_file()

	local tally = 0

	for _, eq in ipairs(eqs) do
		local answer = eq[1]
		local operands = { unpack(eq, 2) }

		for comb in iter_ops(#operands - 1, "+", "*") do
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

		for comb in iter_ops(#operands - 1, "+", "*", "|") do
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
