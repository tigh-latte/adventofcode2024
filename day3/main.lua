#!/usr/bin/env lua

local input = arg[2] or "./day3/input.txt"

---@return string[]
local function read_file()
	local f = io.open(input, "r")
	if not f then error("failed to open file", 2) end

	local lines = {}
	for line in f:lines() do
		table.insert(lines, line)
	end

	f:close()

	return lines
end

---@return integer
local function part1()
	local lines = read_file()

	local tally = 0
	for _, line in ipairs(lines) do
		for left, right in line:gmatch([[mul%((%d+),(%d+)%)]]) do
			tally = tally + (left * right)
		end
	end

	return tally
end

local function part2()
	local lines = read_file()

	local tally = 0
	local _do = true

	for _, line in ipairs(lines) do
		for i = 1, #line do
			local cur = line:sub(i, #line)
			if cur:find("^do%(%)") then
				_do = true
			end
			if cur:find("^don't%(%)") then
				_do = false
			end
			if _do then
				local left, right = cur:match("^mul%((%d+),(%d+)%)")
				if left and right then
					tally = tally + (left * right)
				end
			end
		end
	end

	return tally
end

print("part 1:", part1())
print("part 2:", part2())
