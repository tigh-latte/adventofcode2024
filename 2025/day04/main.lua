#!/usr/bin/env luajit

table.unpack = table.unpack or unpack

local input = arg[1] or "2025/day04/input.txt"

---@param path string
---@return string[][]
local function read_input(path)
	local f = io.open(path)
	if not f then
		error("failed to open file", 2)
	end

	local grid = {}
	for line in f:lines() do
		local cols = {}
		for c in line:gmatch "." do
			table.insert(cols, c)
		end
		table.insert(grid, cols)
	end

	f:close()

	return grid
end

---@return integer[][]
local function get_coords(grid)
	local coords = {}

	local check = function(x, y)
		local row = grid[y]
		local adjacent = 0
		for i = math.max(y - 1, 1), math.min(y + 1, #grid) do
			if x > 1 and grid[i][x - 1] == "@" then
				adjacent = adjacent + 1
			end
			if x < #row and grid[i][x + 1] == "@" then
				adjacent = adjacent + 1
			end
		end
		if y > 1 and grid[y - 1][x] == "@" then
			adjacent = adjacent + 1
		end
		if y < #grid and grid[y + 1][x] == "@" then
			adjacent = adjacent + 1
		end

		return adjacent
	end
	for y = 1, #grid do
		local row = grid[y]
		for x = 1, #row do
			local current = row[x]
			if current == "@" then
				local adjacent = check(x, y)
				if adjacent < 4 then
					table.insert(coords, { x, y })
				end
			end
		end
	end

	return coords
end

local function part1()
	local grid = read_input(input)
	local coords = get_coords(grid)
	print(#coords)
end

local function part2()
	local grid = read_input(input)
	local total = 0

	local coords = get_coords(grid)
	while #coords > 0 do
		total = total + #coords

		for _, coord in ipairs(coords) do
			local x, y = table.unpack(coord)
			grid[y][x] = "."
		end

		coords = get_coords(grid)
	end

	print(total)
end

part1()
part2()
