#!/usr/bin/env luajit

table.unpack = table.unpack or unpack

local input = arg[1] or "2025/day05/input.txt"

---@param path string
---@return string[][]
local function read_input(path)
	local f = io.open(path)
	if not f then
		error("failed to open file", 2)
	end

	local ranges = {}
	local ids = {}
	local ctx = 1
	for line in f:lines() do
		if line == "" then
			ctx = 2
		elseif ctx == 1 then
			local start, _end = line:match "(%d+)-(%d+)"
			table.insert(ranges, { tonumber(start), tonumber(_end) })
		elseif ctx == 2 then
			table.insert(ids, tonumber(line))
		end
	end

	f:close()

	return ranges, ids
end

local function part1()
	local ranges, ids = read_input(input)

	local fresh = 0
	for _, id in ipairs(ids) do
		for _, range in ipairs(ranges) do
			local s, e = unpack(range)
			if s <= id and id <= e then
				fresh = fresh + 1
				break
			end
		end
	end

	print(fresh)
end

local function part2()
	local ranges = read_input(input)
	local combined = {}
	for _, range in ipairs(ranges) do
		local s, e = unpack(range)
		local set = false
		for i, c in ipairs(combined) do
			local rs, re = unpack(c)
			if s < rs and re < e then
				set = true
				rs = s
				re = e
			elseif s < rs and e < re then
				set = true
				rs = s
			elseif rs < s and re < e then
				set = true
				re = e
			end

			if set then
				combined[i] = { rs, re }
				break
			end
		end


		if not set then
			table.insert(combined, { s, e })
		end
		set = false
	end

	for _, c in ipairs(combined) do
		print(table.concat(c, "-"))
	end
end

part1()
part2()
