#!/usr/bin/env luajit

table.unpack = table.unpack or unpack

local input = arg[1] or "2025/day07/input.txt"

---@param path string
---@return string[][]
local function read_input(path)
	local f = io.open(path)
	if not f then
		error("failed to open file", 2)
	end

	local chars = {}
	for line in f:lines() do
		local l = {}
		for c in line:gmatch "." do
			table.insert(l, c)
		end
		table.insert(chars, l)
	end

	return chars
end

local function part1()
	local manifold = read_input(input)

	local sp = 0
	for i, c in ipairs(manifold[1]) do
		if c == "S" then
			sp = i
			break
		end
	end

	local track
	track = function(y, x, visited)
		if y == #manifold then return 0 end
		local key = tostring(y) .. ":" .. tostring(x)
		if visited[key] then
			return 0
		end
		if manifold[y + 1][x] == "^" then
			visited[key] = true
			return 1 + track(y + 1, x + 1, visited) + track(y + 1, x - 1, visited)
		else
			return track(y + 1, x, visited)
		end
	end

	print(track(1, sp, {}))
end

local function part2()
	local manifold = read_input(input)

	local sp = 0
	for i, c in ipairs(manifold[1]) do
		if c == "S" then
			sp = i
			break
		end
	end

	local track
	track = function(y, x, vals)
		if y == #manifold then return 1 end
		local key = tostring(y) .. ":" .. tostring(x)
		if vals[key] ~= nil then
			return vals[key]
		end
		if manifold[y + 1][x] == "^" then
			local result = track(y + 1, x + 1, vals) + track(y + 1, x - 1, vals)
			vals[key] = result
			return vals[key]
		else
			return track(y + 1, x, vals)
		end
	end

	print(track(1, sp, {}))
end

part1()
part2()
