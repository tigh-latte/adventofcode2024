#!/usr/bin/env lua

---@param path string
---@return integer[][]
local function read_input(path)
	local f = io.open(path)
	if not f then
		error("failed to open file", 2)
	end

	local report = {}
	for line in f:lines() do
		local levels = {}

		for v in line:gmatch("([^ ]+)") do
			table.insert(levels, tonumber(v))
		end

		table.insert(report, levels)
	end

	f:close()

	return report
end

---@return integer
local function part1()
	local report = read_input(arg[2] or "day2/input.txt")

	local tally = 0

	for _, levels in ipairs(report) do
		local ascending --[[@as boolean?]]
		local safe = true

		for i = 1, #levels - 1 do
			local current = levels[i]
			local next = levels[i + 1]

			local diff = next - current

			if diff == 0 then safe = false end

			if ascending == nil then
				ascending = diff > 0
			end


			if ascending and diff < 0 then safe = false end
			if not ascending and diff > 0 then safe = false end
			if math.abs(diff) < 1 or 3 < math.abs(diff) then safe = false end
			if not safe then break end
		end

		if safe then tally = tally + 1 end
	end

	return tally
end

---@return integer
local function part2()
	local report = read_input(arg[2] or "day2/input.txt")

	---@param tbl table
	table.copy = function(tbl)
		local cpy = {}
		for k, v in ipairs(tbl) do
			cpy[k] = v
		end
		return cpy
	end


	local tally = 0

	---@param levels integer[]
	---@return boolean
	local function is_safe(levels)
		local ascending --[[@as boolean?]]

		for i = 1, #levels - 1 do
			local current = levels[i]
			local next = levels[i + 1]
			local diff = next - current

			if diff == 0 then return false end
			if ascending == nil then ascending = diff > 0 end

			if ascending and diff < 0 then return false end
			if not ascending and diff > 0 then return false end
			if math.abs(diff) < 1 or 3 < math.abs(diff) then return false end
		end

		return true
	end

	for _, levels in ipairs(report) do
		local safe = is_safe(levels)
		if not safe then
			for i = 1, #levels do
				local clone = table.copy(levels)
				table.remove(clone, i)
				safe = is_safe(clone)
				if safe then break end
			end
		end

		if safe then tally = tally + 1 end
	end

	return tally
end

print("part 1:", part1())
print("part 2:", part2())
