#!/usr/bin/env luajit

local input = arg[1] or "2025/day01/input.txt"

---@param path string
---@return table[]
local function read_input(path)
	local f = io.open(path)
	if not f then
		error("failed to open file", 2)
	end

	local lines = f:read("*a") --[[@as string]]
	f:close()

	local rots = {}
	for l, r in lines:gmatch("([LR])(%d+)") do
		table.insert(rots, { dir = l, num = tonumber(r) })
	end

	return rots
end

local function part1()
	local start = 50
	local rots = read_input(input)

	local total_zeros = 0
	for _, rot in ipairs(rots) do
		if rot.dir == "L" then
			start = start - rot.num
		elseif rot.dir == "R" then
			start = start + rot.num
		end
		start = start % 100
		if start == 0 then
			total_zeros = total_zeros + 1
		end
	end

	print(total_zeros)
end

-- very very dumb solution. See if can sort off-by-one error in the better approach
local function part2()
	local start = 50
	local rots = read_input(input)

	local total_zeros = 0
	for _, rot in ipairs(rots) do
		local n = rot.num

		while n ~= 0 do
			if rot.dir == "L" then
				start = (start - 1) % 100
			else
				start = (start + 1) % 100
			end
			n = n - 1
			if start == 0 then
				total_zeros = total_zeros + 1
			end
		end
	end

	print(total_zeros)
end

part1()
part2()
