#!/usr/bin/env luajit

local input = arg[1] or "./day9/input.txt"

---@return string[]
local function read_file()
	local f = io.open(input)
	if not f then error("error reading file", 2) end

	local result = {}
	local is_file = true
	local id = 0

	local l = f:read("*l") --[[@as string]]
	for c in l:gmatch "." do
		local blocks = tonumber(c)
		if not blocks then error("fuck", 2) end

		for _ = 1, blocks do
			table.insert(result, is_file and id or ".")
		end
		if is_file then id = id + 1 end
		is_file = not is_file
	end

	f:close()

	return result
end

local function part1()
	local fs = read_file()

	local tally = 0
	local i, j = 1, #fs
	while true do
		while fs[i] and fs[i] ~= "." do i = i + 1 end
		while fs[j] and fs[j] == "." do j = j - 1 end
		if i >= j then break end

		fs[i], fs[j] = fs[j], fs[i]
	end

	i = 1
	while fs[i] ~= "." do
		local pos = i - 1
		tally = tally + (pos * fs[i])
		i = i + 1
	end

	return tally
end

local function part2()
	local fs = read_file()

	local tally = 0
	local pos = #fs
	while true do
		if not fs[pos] then break end
		while fs[pos] and fs[pos] == "." do pos = pos - 1 end
		local n_end = pos
		local n_start = pos
		while fs[n_start] and fs[n_start] == fs[n_end] do n_start = n_start - 1 end

		local needed_slots = n_end - n_start

		for i = 1, pos do
			if fs[i] and fs[i] == "." then
				local count = 0
				for j = i, i + needed_slots - 1 do
					if not fs[j] then break end
					if fs[j] ~= "." then break end
					count = count + 1
					if count == needed_slots then break end
				end
				if count == needed_slots then
					for j = 0, needed_slots - 1 do
						local l, r = fs[i + j], fs[n_end - j]
						fs[n_end - j], fs[i + j] = l, r
					end
					break
				end
			end
		end

		pos = n_start
	end

	for i = 1, #fs do
		if fs[i] ~= "." then
			tally = tally + ((i - 1) * fs[i])
		end
	end


	return tally
end

print("part 1:", part1())
print("part 2:", part2())
