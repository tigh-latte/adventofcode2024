local unpack = table.unpack or unpack

---@param input string
---@return integer[][]
local function read_input(input)
	local f = io.open(input)
	if not f then
		return {}
	end

	local lines = f:read("*a") --[[@as string]]
	f:close()

	local left, right = {}, {}
	for l, r in lines:gmatch("(%d+)%s+(%d+)\n") do
		table.insert(left, tonumber(l))
		table.insert(right, tonumber(r))
	end

	local function ascending(l, r)
		return l < r
	end

	table.sort(left, ascending)
	table.sort(right, ascending)

	return { left, right }
end

---@return integer
local function part1()
	local left, right = unpack(read_input("input.txt"))
	if left == nil or right == nil then
		print("failed")
		return -1
	end

	local tally = 0
	for i in ipairs(left) do
		tally = tally + math.abs(left[i] - right[i])
	end

	return tally
end

---@return integer
local function part2()
	local left, right = unpack(read_input("input.txt"))
	if left == nil or right == nil then
		print("failed")
		return -1
	end

	local tally = 0
	local cur = 0
	local idx = 1
	local similarity = 0

	for _, v in ipairs(left) do
		if idx > #left then
			break
		end
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

print("distances", part1())
print("similarity", part2())
