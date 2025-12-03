#!/usr/bin/env luajit

local input = arg[1] or "2025/day03/input.txt"

---@param path string
---@return integer[][]
local function read_input(path)
	local f = io.open(path)
	if not f then
		error("failed to open file", 2)
	end

	local lines = f:read("*a") --[[@as string]]
	f:close()

	local banks = { {} }
	for m in lines:gmatch("([0-9\n])") do
		if m == "\n" then
			table.insert(banks, {})
		else
			table.insert(banks[#banks], tonumber(m))
		end
	end

	if banks[#banks] == 0 then
		table.remove(banks)
	end

	return banks
end

local function part1()
	local banks = read_input(input)

	local total = 0
	for _, bank in ipairs(banks) do
		local fhigh = 0
		local curhigh = 0
		for i = 1, #bank - 1 do
			local battery = bank[i]
			if battery > fhigh then
				fhigh = battery
				local ten = fhigh * 10
				for j = i + 1, #bank do
					local voltage = ten + bank[j]
					curhigh = voltage > curhigh and voltage or curhigh
				end
			end
		end

		total = total + curhigh
	end

	print(total)
end

part1()
