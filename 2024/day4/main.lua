#!/usr/bin/env luajit

local input = arg[2] or "day4/input.txt"

local WORD = { "X", "M", "A", "S" }

---@return string[][]
local function read_file()
	local f = io.open(input, "r")
	if not f then
		error("failed to open file", 2)
	end

	local lines = {}
	for line in f:lines() do
		local l = line --[[@as string]]
		local chars = {}
		for char in l:gmatch "." do
			table.insert(chars, char)
		end
		table.insert(lines, chars)
	end

	f:close()

	return lines
end

---@alias direction "n"|"s"|"w"|"e"|"nw"|"ne"|"sw"|"se"

---@param lines string[][]
---@param char integer
---@param direction direction
---@param x integer
---@param y integer
---@return boolean
local function find_xmas(lines, char, direction, x, y)
	local target = WORD[char]
	if not target then return true end

	if x == 0 or y == 0 or x > #lines or y > #lines[x] then return false end

	if lines[x][y] ~= target then return false end

	for d in direction:gmatch(".") do
		if d == "n" then
			y = y - 1
		elseif d == "s" then
			y = y + 1
		elseif d == "e" then
			x = x + 1
		elseif d == "w" then
			x = x - 1
		else
			error("unrecognised direction " .. d, 2)
		end
	end

	return find_xmas(lines, char + 1, direction, x, y)
end

---@param lines string[][]
---@param direction direction
---@param x integer
---@param y integer
---@return boolean
local function find_x_mas(lines, direction, x, y)
	if direction == "nw" then
		return lines[x - 1][y - 1] == "M" and lines[x + 1][y + 1] == "S"
	elseif direction == "ne" then
		return lines[x - 1][y + 1] == "M" and lines[x + 1][y - 1] == "S"
	elseif direction == "sw" then
		return lines[x + 1][y - 1] == "M" and lines[x - 1][y + 1] == "S"
	elseif direction == "se" then
		return lines[x + 1][y + 1] == "M" and lines[x - 1][y - 1] == "S"
	else
		error("unkown direction " .. direction, 2)
	end
end

---@return integer
local function part1()
	local lines = read_file()
	local tally = 0
	for i = 1, #lines do
		local chars = lines[i]
		for j = 1, #chars do
			for _, direction in ipairs({ "n", "s", "w", "e", "nw", "ne", "sw", "se" }) do
				if find_xmas(lines, 1, direction, i, j) then
					tally = tally + 1
				end
			end
		end
	end
	return tally
end

---@return integer
local function part2()
	local lines = read_file()
	local tally = 0
	for i = 2, #lines - 1 do
		local chars = lines[i]
		for j = 2, #chars - 1 do
			if chars[j] == "A" then
				local total_found = 0
				for _, dir in ipairs({ "nw", "ne", "sw", "se" }) do
					if find_x_mas(lines, dir, i, j) then
						total_found = total_found + 1
					end
				end
				if total_found == 2 then tally = tally + 1 end
			end
		end
	end

	return tally
end

print("part 1:", part1())
print("part 2:", part2())
