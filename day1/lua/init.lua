local unpack = table.unpack or unpack

---@param input string
---@return integer[], integer[]
local function read_input(input)
	local f = io.open(input)
	if not f then
		error("failed to open file", 2)
	end

	local lines = f:read("*a") --[[@as string]]
	f:close()

	local left, right = {}, {}
	for l, r in lines:gmatch("(%d+)%s+(%d+)\n") do
		table.insert(left, l)
		table.insert(right, r)
	end

	local function ascending(l, r)
		return l < r
	end

	table.sort(left, ascending)
	table.sort(right, ascending)

	return left, right
end

---@return integer
local function part1()
	local left, right = read_input("input.txt")

	local tally = 0
	for i in ipairs(left) do
		tally = tally + math.abs(left[i] - right[i])
	end

	return tally
end

---@return integer
local function part2()
	local left, right = read_input("input.txt")

	local tally = 0
	local idx = 1

	local cur, similarity
	for _, v in ipairs(left) do
		if v ~= cur then
			similarity = 0
			cur = v

			while right[idx] and cur > right[idx] do
				idx = idx + 1
			end

			while v == right[idx] do
				similarity = similarity + 1
				idx = idx + 1
			end
		end
		tally = tally + (similarity * cur)
	end

	return tally
end

local ok, res = pcall(part1)
if not ok then
	print("failed to calcuate distances", res)
else
	print("distances", res)
end

ok, res = pcall(part2)
if not ok then
	print("failed to calcuate similarity", res)
else
	print("similarity", res)
end
