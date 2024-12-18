#!/usr/bin/env lua5.1

local input = arg[1] or "day1/input.txt"

---@param path string
---@return integer[], integer[]
local function read_input(path)
	local f = io.open(path)
	if not f then
		error("failed to open file", 2)
	end

	local lines = f:read("*a") --[[@as string]]
	f:close()

	local left, right = {}, {}
	for l, r in lines:gmatch("(%d+)%s+(%d+)\n") do
		table.insert(left, l)
		table.insert(right, r)
	end

	return left, right
end

---@return integer
local function part1()
	local left, right = read_input(input)
	table.sort(left)
	table.sort(right)

	local tally = 0
	for i in ipairs(left) do
		tally = tally + math.abs(left[i] - right[i])
	end

	return tally
end

---@return integer
local function part2()
	local left, right = read_input(input)
	local occurences = {}
	for _, v in ipairs(right) do
		occurences[v] = (occurences[v] or 0) + 1
	end

	local tally = 0
	for _, v in ipairs(left) do
		tally = tally + v * (occurences[v] or 0)
	end

	return tally
end

local ok, res = pcall(part1)
if not ok then
	print("failed to calcuate distances", res)
else
	print("part 1:", res)
end

ok, res = pcall(part2)
if not ok then
	print("failed to calcuate similarity", res)
else
	print("part 2:", res)
end
