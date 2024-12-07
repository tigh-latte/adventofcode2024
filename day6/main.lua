#!/usr/bin/env luajit

local input = arg[1] or "./day6/input.txt"

---@return string[][]
local function read_file()
	local f = io.open(input, "r")
	if not f then error("failed to open input", 2) end

	local grid = {}

	for row in f:lines() do
		row = row --[[@as string]]

		local columns = {}

		for c in row:gmatch "." do
			table.insert(columns, c)
		end

		table.insert(grid, columns)
	end

	f:close()

	return grid
end

---@param grid string[][]
---@return integer
---@return integer
local function locate_guard(grid)
	for i = 1, #grid do
		for j = 1, #grid[i] do
			local current = grid[i][j]
			if current == "^" or current == ">" or current == "v" or current == "<" then
				return i, j
			end
		end
	end
	return 0, 0
end
---
---@param grid string[][]
local function print_grid(grid)
	for _, row in ipairs(grid) do
		print(table.concat(row, ""))
	end
end

---@param grid string[][
---@param x integer
---@param y integer
---@return integer, integer
local function move_guard(grid, x, y)
	local dx, dy = 0, 0
	local guard = grid[x][y]
	local ng = guard
	if guard == "^" then
		dx = 1
		ng = ">"
	elseif guard == ">" then
		dy = -1
		ng = "v"
	elseif guard == "<" then
		dy = 1
		ng = "^"
	elseif guard == "v" then
		dx = -1
		ng = "<"
	end


	local n = grid[x - dx][y - dy]
	while true do
		if not n or (n == "#" or n == "O") then
			grid[x][y] = ng
			break
		end

		grid[x][y] = "X"
		x = x - dx
		y = y - dy
		grid[x][y] = ng


		if x == 0 or y == 0 or x == #grid or y == #grid[x] then
			break
		end

		n = (grid[x - dx] or {})[y - dy]
	end

	return x, y
end

---@param grid string[][]
---@param x integer
---@param y integer
---@return boolean
local function has_loop(grid, x, y)
	local visited = {}
	while x ~= 1 and y ~= 1 and x ~= #grid and y ~= #grid[1] do
		x, y = move_guard(grid, x, y)
		local v = visited[x .. "," .. y]
		if not v then
			visited[x .. "," .. y] = grid[x][y]
		elseif v == grid[x][y] then
			return true
		end
	end
	return false
end

---@return integer
local function part1()
	local grid = read_file()

	local x, y = locate_guard(grid)
	while x ~= 0 and y ~= 0 and x ~= #grid and y ~= #grid[1] do
		x, y = move_guard(grid, x, y)
	end

	local tally = 0

	for _, row in ipairs(grid) do
		for _, col in ipairs(row) do
			if col == "X" then
				tally = tally + 1
			end
		end
	end

	return tally + 1
end

local function part2()
	local grid = read_file()

	---@param tbl table
	local function clone(tbl)
		local cpy = {}
		for k, v in ipairs(tbl) do
			if type(v) == "table" then
				cpy[k] = clone(v)
			else
				cpy[k] = v
			end
		end
		return cpy
	end

	local x, y = locate_guard(grid)
	local tally = 0

	for i = 1, #grid do
		for j = 1, #grid[i] do
			if grid[i][j] == "." then
				local gc = clone(grid)
				gc[i][j] = "O"

				if has_loop(gc, x, y) then
					tally = tally + 1
				end
			end
		end
	end

	return tally
end

print("part 1: ", part1())
print("part 2: ", part2())
