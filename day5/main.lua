#!/usr/bin/env luajit

---@class Node
---@field next table<integer, Node>
---@field value integer
local Node = {}
Node.__index = Node


---@alias Rules table<integer, integer[]>

local input = arg[2] or "./day5/demo.txt"

---@return Rules, Rules, integer[][]
local function read_file()
	local f = io.open(input, "r")
	if not f then error("failed to open input", 2) end

	local before, after = {}, {}

	for line in f:lines() do
		line = line --[[@as string]]
		if line == "" then break end

		local l, r = line:match("(%d+)|(%d+)")
		l, r = tonumber(l), tonumber(r)

		if not before[l] then
			before[l] = {}
		end
		table.insert(before[l], r)

		if not after[r] then
			after[r] = {}
		end
		table.insert(after[r], l)
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

	return before, after, updates
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

---@param name string
---@param rules Rules
local function debug_map(name, rules)
	for page, rule in pairs(rules) do
		print(name, page, "->", debug_list(rule))
	end
end


---@param vv any[]
---@param v any
---@param page any
local function contains(vv, v, page)
	for val in pairs(vv) do
		if val == page then goto continue end
		print("comparing", val, v)
		if val == v then return true end
		::continue::
	end

	return false
end

---@param before integer[]
---@param after integer[]
---@param visited table<integer, boolean>
---@param update integer[]
---@param page integer
---@return boolean
local function is_valid_page_update(before, after, visited, update, page)
	print("page", page)
	print("after", debug_list(after))
	if before then
		for _, b in ipairs(before) do
			if b ~= page then
				if contains(update, b, page) and visited[b] then
					return false
				end
			end
		end
	end
	if after then
		for _, a in ipairs(after) do
			if a ~= page then
				local con = contains(update, a, page)
				if con and not visited[a] then
					return false
				end
			end
		end
	end
	return true
end

local function part1()
	local before, after, updates = read_file()

	local tally = 0

	for _, update in ipairs(updates) do
		local visited = {}
		local all_valid = true
		for _, page in ipairs(update) do
			if not is_valid_page_update(before[page], after[page], update, visited, page) then
				all_valid = false
				break
			end
			visited[page] = true
		end
		if all_valid then
			print("valid", debug_list(update))
			tally = tally + update[math.ceil(#update / 2)]
		end
	end

	return tally
end


print("part 1: ", part1())
-- print("part 2: ", part2())
