#!/usr/bin/env luajit

local input = arg[1] or "./day10/input.txt"

---@return integer[][]
local function read_file()
	local f = io.open(input)
	if not f then error("failed to open file", 2) end

	local rows = {}

	for line in f:lines() do
		line = line --[[@as string]]
		local cols = {}
		for char in line:gmatch "." do
			table.insert(cols, tonumber(char))
		end

		table.insert(rows, cols)
	end

	return setmetatable(rows, {
		__index = function(_, _)
			return {}
		end,
	})
end

---@param trials integer[][]
---@return integer[][]
local function get_start_points(trials)
	local coords = {}
	for i, r in ipairs(trials) do
		for j, c in ipairs(r) do
			if c == 0 then
				table.insert(coords, { i, j })
			end
		end
	end

	return coords
end

---@param map integer[][]
---@param x integer
---@param y integer
---@param has_visited fun(integer, integer): boolean
---@return integer
local function traverse(map, x, y, has_visited)
	local height = map[x][y]
	if has_visited(x, y) then return 0 end

	if height == 9 then return 1 end

	local score = 0

	local above = map[x - 1][y]
	if above and above == height + 1 then
		score = score + traverse(map, x - 1, y, has_visited)
	end

	local below = map[x + 1][y]
	if below and below == height + 1 then
		score = score + traverse(map, x + 1, y, has_visited)
	end

	local left = map[x][y - 1]
	if left and left == height + 1 then
		score = score + traverse(map, x, y - 1, has_visited)
	end

	local right = map[x][y + 1]
	if right and right == height + 1 then
		score = score + traverse(map, x, y + 1, has_visited)
	end

	return score
end


local function part1()
	local map = read_file()

	local visited = {}
	local function has_visited(x, y)
		local coord_key = x .. "," .. y
		if visited[coord_key] then return true end
		visited[coord_key] = true
		return false
	end

	local tally = 0
	local start_points = get_start_points(map)
	for _, point in ipairs(start_points) do
		local i, j = unpack(point)
		local score = traverse(map, i, j, has_visited)
		tally = tally + score
	end

	return tally
end

local function part2()
	local map = read_file()

	local function has_visited() return false end

	local tally = 0
	local start_points = get_start_points(map)
	for _, point in ipairs(start_points) do
		local i, j = unpack(point)
		local score = traverse(map, i, j, function(x, y) return false end)
		tally = tally + score
	end

	return tally
end

print("part 1:", part1())
print("part 2:", part2())
