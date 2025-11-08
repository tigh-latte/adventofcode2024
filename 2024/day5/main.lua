#!/usr/bin/env luajit

---@alias Rules table<string, boolean>

local input = arg[1] or "./day5/input.txt"

---@param name string
---@param rules Rules
local function debug_map(name, rules)
	for page, rule in pairs(rules) do
		print(name, page, "->", rule)
	end
end




---@return Rules,  integer[][]
local function read_file()
	local f = io.open(input, "r")
	if not f then error("failed to open input", 2) end

	local rules = {}

	for line in f:lines() do
		line = line --[[@as string]]
		if line == "" then break end

		rules[line] = true
	end

	local updates = {}
	for line in f:lines() do
		local update = {}
		line = line --[[@as string]]
		for page in line:gmatch("(%d+)") do
			table.insert(update, tonumber(page))
		end

		table.insert(updates, update)
	end

	f:close()

	return rules, updates
end

---@param pages integer[]
local function debug_list(pages)
	if not pages then return "nil" end
	local s = "["
	for _, page in ipairs(pages) do
		s = s .. tostring(page) .. ","
	end
	return s .. "]"
end

local function part1()
	local rules, updates = read_file()

	local tally = 0

	for _, update in ipairs(updates) do
		local all_valid = true

		print("list", debug_list(update))
		for i = 1, #update do
			local after = { unpack(update, i + 1, #update) }
			local before = { unpack(update, 1, i - 1) }

			local page = update[i]

			print("before", debug_list(before))

			local found = true

			if after and #after > 0 then
				for _, a in ipairs(after) do
					local rule = page .. "|" .. a
					if not rules[rule] then
						found = false
						break
					end
				end
			end
			if before and #before > 0 then
				for _, b in ipairs(before) do
					local rule = b .. "|" .. page
					if not rules[rule] then
						found = false
						break
					end
				end
			end

			if not found then
				all_valid = false
				break
			end
		end
		if all_valid then
			tally = tally + update[math.ceil(#update / 2)]
		end
	end

	return tally
end

local function part2()
	local rules, updates = read_file()

	local tally = 0

	local incorrect = {}

	for _, update in ipairs(updates) do
		local all_valid = true

		for i = 1, #update do
			local after = { unpack(update, i + 1, #update) }
			local before = { unpack(update, 1, i - 1) }

			local page = update[i]

			print("before", debug_list(before))

			local found = true

			if after and #after > 0 then
				for _, a in ipairs(after) do
					local rule = page .. "|" .. a
					if not rules[rule] then
						found = false
						break
					end
				end
			end
			if before and #before > 0 then
				for _, b in ipairs(before) do
					local rule = b .. "|" .. page
					if not rules[rule] then
						found = false
						break
					end
				end
			end

			if not found then
				all_valid = false
				break
			end
		end
		if not all_valid then
			table.insert(incorrect, update)
		end
	end

	for _, item in ipairs(incorrect) do
		print(debug_list(item))
	end
end

print("part 1: ", part1())
print("part 2: ", part2())
