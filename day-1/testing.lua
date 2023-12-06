function find_occurrence(text, substring)
	local occurrence = {}
	local startPos = 1

	while true do
		local start, finish = string.find(text, substring, startPos)
		if start == nil then
			break
		end

		table.insert(occurrence, start)
		startPos = finish + 1
	end

	return occurrence
end

local example = "Hello, hello, hello, how are you?"
local sub = "hello"

local positions = find_occurrence(example, sub)

if #positions > 0 then
	print("Substring found")
	for _, pos in ipairs(positions) do
		print(pos)
	end
else
	print("Substring not found")
end
