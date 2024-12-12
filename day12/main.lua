#!/usr/bin/env luajit

local input = arg[1] or "./day12/input.txt"

---@return string[][]
local function read_file()
	local f = io.open(input)
	if not f then error("error opening file", 2) end

	local rows = {}
	for line in f:lines() do
		local cols = {}
		for c in line:gmatch "." do
			table.insert(cols, c)
		end

		table.insert(rows, cols)
	end

	f:close()

	return setmetatable(rows, {
		__index = function(_, _)
			return {}
		end,
	})
end

---@return integer
local function count_corners(grid, coord)
	local total = 0
	local i, j = unpack(coord)

	local current = grid[i][j]

	local above = grid[i - 1][j]
	local below = grid[i + 1][j]
	local left = grid[i][j - 1]
	local right = grid[i][j + 1]
	local diagul = grid[i - 1][j - 1]
	local diagur = grid[i - 1][j + 1]
	local diagll = grid[i + 1][j - 1]
	local diaglr = grid[i + 1][j + 1]

	-- check if ┑
	-- O
	-- X O
	-- if current ~= above and current ~= right and current ~= diagur then
	if current ~= above and current ~= right then
		total = total + 1
	end

	-- check if ┑
	-- x X
	-- O x
	if current == left and current == below and current ~= diagll then
		total = total + 1
	end

	-- check if ┖
	-- O X
	--   O
	if current ~= below and current ~= left then
		total = total + 1
	end


	-- check if ┖
	-- x O
	-- X x
	if current == above and current == right and current ~= diagur then
		total = total + 1
	end

	-- check if ┙
	-- X O
	-- O
	if current ~= below and current ~= right then
		total = total + 1
	end

	-- check if ┙
	-- O x
	-- x X
	if current == above and current == left and current ~= diagul then
		total = total + 1
	end

	-- check if ┎
	--   O
	-- O X
	if current ~= above and current ~= left then
		total = total + 1
	end

	-- check if ┎
	-- X x
	-- x O
	if current == right and current == below and current ~= diaglr then
		total = total + 1
	end

	return total
end

local function build_region(farms, region, visited, coord)
	local i, j = unpack(coord)

	if visited[i .. "|" .. j] then return end
	visited[i .. "|" .. j] = true

	region.area = region.area + 1
	local current = farms[i][j]

	region.corners = region.corners + count_corners(farms, coord)

	if i == 1 or farms[i - 1][j] ~= current then
		region.perim = region.perim + 1
	else
		build_region(farms, region, visited, { i - 1, j })
	end

	if j == 1 or farms[i][j - 1] ~= current then
		region.perim = region.perim + 1
	else
		build_region(farms, region, visited, { i, j - 1 })
	end

	if i == #farms or farms[i + 1][j] ~= current then
		region.perim = region.perim + 1
	else
		build_region(farms, region, visited, { i + 1, j })
	end

	if j == #farms[i] or farms[i][j + 1] ~= current then
		region.perim = region.perim + 1
	else
		build_region(farms, region, visited, { i, j + 1 })
	end
end

local function part1()
	local farms = read_file()

	local lands = {}
	local visited = {}
	for i, row in ipairs(farms) do
		for j, col in ipairs(row) do
			local region = { perim = 0, area = 0, corners = 0 }
			if not lands[col] then lands[col] = {} end
			build_region(farms, region, visited, { i, j })

			if region.perim > 0 and region.area > 0 then
				table.insert(lands[col], region)
			end
		end
	end

	local tally1 = 0
	local tally2 = 0
	for c, regions in pairs(lands) do
		for i, region in ipairs(regions) do
			tally1 = tally1 + (region.perim * region.area)
			tally2 = tally2 + (region.corners * region.area)
		end
	end

	return tally1, tally2
end


local p1, p2 = part1()
print("part 1:", p1)
print("part 2:", p2)
