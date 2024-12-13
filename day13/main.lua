#!/usr/bin/env luajit

---@class Game
---@field A integer[]
---@field B integer[]
---@field Prize integer[]

local input = arg[1] or "./day13/demo.txt"

---@return Game[]
local function read_file()
	local f = io.open(input)
	if not f then error("failed to open file", 2) end

	---@type Game[]
	local games = { { A = {}, B = {}, Prize = {} } }
	for line in f:lines() do
		line = line --[[@as string]]
		---@type Game
		local game = games[#games]

		local part, x, y = line:match("(.): ..(%d+)[^%d]*(%d+)")
		if part then
			if part == "A" then
				game.A = { tonumber(x), tonumber(y) }
			elseif part == "B" then
				game.B = { tonumber(x), tonumber(y) }
			elseif part == "e" then
				game.Prize = { tonumber(x), tonumber(y) }
			end
		else
			table.insert(games, { A = {}, B = {}, Prize = {} })
		end
	end

	f:close()
	return games
end

local function part1()
	local games = read_file()
	return 0
end

local function part2()
	return 0
end

print("part 1:", part1())
print("part 2:", part2())
