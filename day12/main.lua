#!/usr/bin/env luajit

local input = arg[1] or "./day12/demo.txt"

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

	return rows
end

local function build_region(farms, region, visited, coord)
	local i, j = unpack(coord)

	if visited[i .. "|" .. j] then return end
	visited[i .. "|" .. j] = true

	region.area = region.area + 1
	local current = farms[i][j]

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
			local region = { perim = 0, area = 0 }
			if not lands[col] then lands[col] = {} end
			build_region(farms, region, visited, { i, j })

			if region.perim > 0 and region.area > 0 then
				table.insert(lands[col], region)
			end
		end
	end

	local tally = 0
	for c, regions in pairs(lands) do
		for i, region in ipairs(regions) do
			local cost = region.perim * region.area
			tally = tally + cost
		end
	end

	return tally
end

local function part2()
	local tally = 0
	return tally
end

print("part 1:", part1())
print("part 2:", part2())
