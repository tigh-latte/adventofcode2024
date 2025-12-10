#!/usr/bin/env luajit

table.unpack = table.unpack or unpack

local input = arg[1] or "2025/day06/input.txt"

---@param path string
---@return table[][]
local function read_input(path)
	local f = io.open(path)
	if not f then
		error("failed to open file", 2)
	end

	local problems = {}
	for line in f:lines() do
		local problem = {}
		if line:match "(%d+)" then
			for num in line:gmatch "(%d+)" do
				table.insert(problem, tonumber(num))
			end
		else
			for op in line:gmatch "(%p)" do
				table.insert(problem, op)
			end
		end

		table.insert(problems, problem)
	end

	f:close()

	return problems
end

---@param path string
---@return string[][]
local function read_input2(path)
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
	local homework = read_input(input)

	local total = 0
	for i in ipairs(homework[1]) do
		local op = homework[#homework][i]
		local running = op == "*" and 1 or 0
		for j = 1, #homework - 1 do
			if op == "*" then
				running = running * homework[j][i]
			else
				running = running + homework[j][i]
			end
		end
		total = total + running
	end

	print(total)
end

local function part2()
	local t = read_input2(input)

	local start = #t[1]
	local total = 0
	while start > 1 do
		local _end = start
		for j = start, 1, -1 do
			if t[#t][j] ~= " " then
				_end = j
				break
			end
		end

		local op = t[#t][_end]
		local running = op == "*" and 1 or 0
		for j = start, _end, -1 do
			local num = 0
			for k = 1, #t - 1 do
				if t[k][j] ~= " " then
					num = (num * 10) + tonumber(t[k][j])
				end
			end

			if op == "*" then
				running = running * num
			else
				running = running + num
			end
		end

		start = _end - 2

		-- print(running)
		total = total + running
	end

	print(total)
end

part1()
part2()
