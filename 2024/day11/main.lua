#!/usr/bin/env luajit

local Counter = {}
Counter.__index = Counter

local input = arg[1] or "./day11/input.txt"

---@return table<integer, integer>
local function read_file()
	local f = io.open(input)
	if not f then error("failed to read file", 2) end

	local l = f:read("*l") --[[@as string]]

	---@type integer[]
	local result = setmetatable({}, {
		__index = function(self, k)
			self[k] = 0
			return 0
		end,
	})
	for m in l:gmatch("%d+") do
		local d = tonumber(m)
		result[d] = result[d] + 1
	end

	return result
end

local function blink_map(stones, times)
	for _ = 1, times do
		local round = setmetatable({}, {
			__index = function(self, k)
				self[k] = 0
				return 0
			end,
		})
		for stone, count in pairs(stones) do
			if stone == 0 then
				round[1] = round[1] + count
			else
				local ndigits = math.floor(math.log10(stone) + 1)
				if ndigits % 2 == 0 then
					local mid = ndigits / 2
					local unit = math.pow(10, mid)
					local l = math.floor(stone / unit)
					local r = stone - (l * unit)

					round[l] = round[l] + count
					round[r] = round[r] + count
				else
					local product = stone * 2024
					round[product] = round[product] + count
				end
			end
		end
		stones = round
	end

	return stones
end

local function part1()
	local stones = read_file()

	stones = blink_map(stones, 25)

	local tally = 0
	for _, count in pairs(stones) do
		if count > 0 then
			tally = tally + count
		end
	end

	return tally
end

local function part2()
	local stones = read_file()

	stones = blink_map(stones, 75)

	local tally = 0
	for _, count in pairs(stones) do
		if count > 0 then
			tally = tally + count
		end
	end

	return tally
end

print("part 1", part1())
print("part 2:", string.format("%.0f", part2()))
