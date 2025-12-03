#!/usr/bin/env luajit

local input = arg[1] or "2025/day02/input.txt"

---@param path string
---@return table[]
local function read_input(path)
	local f = io.open(path)
	if not f then
		error("failed to open file", 2)
	end

	local lines = f:read("*a") --[[@as string]]
	f:close()

	local ranges = {}
	for l, r in lines:gmatch("(%d+)-(%d+)") do
		table.insert(ranges, { start = tonumber(l), _end = tonumber(r) })
	end

	return ranges
end

local function part1()
	local ranges = read_input(input)

	local sum = 0
	for _, range in ipairs(ranges) do
		for i = range.start, range._end do
			local s = tostring(i)
			if #s % 2 == 0 then
				local mid = #s / 2
				local l, r = s:sub(1, mid), s:sub(mid + 1, #s)
				if l == r then sum = sum + i end
			end
		end
	end

	print(sum)
end

local function part2()
	local ranges = read_input(input)
	local sum = 0

	local access = function(id, len)
		local l, r = 1, len
		local seq = id:sub(l, r)

		l = len + 1
		r = len + len
		while l <= #id do
			local part = id:sub(l, r)
			if seq ~= part then return false end
			l = r + 1
			r = r + len
		end

		return true
	end

	for _, range in ipairs(ranges) do
		for i = range.start, range._end do
			local s = tostring(i)
			for j = 1, #s / 2 do
				local found = false
				if #s % j == 0 then
					if access(s, j) then
						found = true
						sum = sum + i
					end
				end
				if found then break end
			end
		end
	end

	print(sum)
end

part1()
part2()
