#!/usr/bin/env luajit

local input = arg[1] or "./day8/input.txt"

---@param g string[][]
local function grid_to_string(g)
	local s = {}

	for _, r in ipairs(g) do
		table.insert(s, table.concat(r, ""))
	end

	return table.concat(s, "\n")
end

---@return string[][]
local function read_file()
	local f = io.open(input)
	if not f then error("failed to read file", 2) end

	local rows = {}

	for line in f:lines() do
		line = line --[[@as string]]

		local cols = {}
		for m in line:gmatch "." do
			table.insert(cols, m)
		end

		table.insert(rows, cols)
	end

	f:close()

	setmetatable(rows, {
		__tostring = grid_to_string,
	})

	return rows
end

---@param grid string[][]
---@return table<string, integer[][]>
local function nodes(grid)
	local n = setmetatable({}, {
		__index = function(self, k)
			self[k] = {}
			return self[k]
		end,
	})
	for i, row in ipairs(grid) do
		for j, col in ipairs(row) do
			if col == "." then goto continue end
			table.insert(n[col], { i, j })
			::continue::
		end
	end

	return n
end

---@return integer
local function part1()
	local grid = read_file()
	local tally = 0

	local function clone(tbl)
		local c = {}
		for k, v in pairs(tbl) do
			if type(tbl) == "table" then
				c[k] = { unpack(v) }
			else
				c[k] = v
			end
		end

		return setmetatable(c, {
			__tostring = grid_to_string,
		})
	end

	local nn = nodes(grid)
	local g = clone(grid)

	for _, coords in pairs(nn) do
		for i = 1, #coords - 1 do
			for j = i + 1, #coords do
				local l, r = coords[i], coords[j]
				local rdiff = l[1] - r[1]
				local cdiff = l[2] - r[2]

				local new_node = { l[1] + rdiff, l[2] + cdiff }
				local second = { r[1] - rdiff, r[2] - cdiff }

				if g[new_node[1]] and g[new_node[1]][new_node[2]] then
					g[new_node[1]][new_node[2]] = "#"
				end
				if g[second[1]] and g[second[1]][second[2]] then
					g[second[1]][second[2]] = "#"
				end
			end
		end
	end

	for _, row in ipairs(g) do
		for _, col in ipairs(row) do
			if col == "#" then
				tally = tally + 1
			end
		end
	end

	return tally
end

---@return integer
local function part2()
	local grid = read_file()
	local tally = 0

	local function clone(tbl)
		local c = {}
		for k, v in pairs(tbl) do
			if type(tbl) == "table" then
				c[k] = { unpack(v) }
			else
				c[k] = v
			end
		end

		return setmetatable(c, {
			__tostring = grid_to_string,
		})
	end

	local nn = nodes(grid)
	local g = clone(grid)

	for _, coords in pairs(nn) do
		for i = 1, #coords - 1 do
			for j = i + 1, #coords do
				local l, r = coords[i], coords[j]
				local rdiff = l[1] - r[1]
				local cdiff = l[2] - r[2]

				local new_nodes = { { l[1], l[2] } }
				while true do
					local current = new_nodes[#new_nodes]

					local next = { current[1] + rdiff, current[2] + cdiff }
					if next[1] < 1 or #g < next[1] then
						break
					end
					if next[2] < 1 or #g[1] < next[2] then
						break
					end

					table.insert(new_nodes, next)
				end

				table.insert(new_nodes, { r[1], r[2] })
				while true do
					local current = new_nodes[#new_nodes]

					local next = { current[1] - rdiff, current[2] - cdiff }
					if next[1] < 1 or #g < next[1] then
						break
					end
					if next[2] < 1 or #g[1] < next[2] then
						break
					end

					table.insert(new_nodes, next)
				end

				for _, node in ipairs(new_nodes) do
					if g[node[1]] and g[node[1]][node[2]] then
						g[node[1]][node[2]] = "#"
					end
				end
			end
		end
	end

	for _, row in ipairs(g) do
		for _, col in ipairs(row) do
			if col == "#" then
				tally = tally + 1
			end
		end
	end

	return tally
end


print("part 1:", part1())
print("part 2:", part2())
