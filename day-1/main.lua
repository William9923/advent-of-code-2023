-- see if the file exists
function file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

-- get all lines from a file, returns an empty
-- list/table if the file does not exist
function lines_from(file)
	if not file_exists(file) then
		return {}
	end
	local lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

-- calibration first part: only numeric value
function find_calibration_value(calibration)
	local first = ""
	local last = ""
	for c in string.gmatch(calibration, ".") do
		local val = tonumber(c, 10)
		if val ~= nil then
			if first == "" then
				first = c
			else
				last = c
			end
		end
	end
	if last == "" then
		last = first
	end
	return tonumber(first .. last, 10)
end

-- calibration second part: include numeric letters
-- Logic:
-- 1. we could parse all => and linked them with an index (using table)
-- 2. after that, we just need to rank them -> choose earliest and latest
function findOccurrence(text, substring)
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

local letterToNumMap = {
	["one"] = 1,
	["two"] = 2,
	["three"] = 3,
	["four"] = 4,
	["five"] = 5,
	["six"] = 6,
	["seven"] = 7,
	["eight"] = 8,
	["nine"] = 9,
}
-- Function to get sorted keys from a table
function sortKeys(data)
    local keys = {}
    for key, _ in pairs(data) do
        table.insert(keys, key)
    end
    table.sort(keys)
    return keys
end

function find_calibration_value_with_letter(calibration)
	local numOccurrence = {}

	for i = 1, 10, 1 do
		local occurrence = findOccurrence(calibration, tostring(i))
		for _, idx in ipairs(occurrence) do
			numOccurrence[idx] = i
		end
	end

	for k, v in pairs(letterToNumMap) do
		local occurrence = findOccurrence(calibration, k)
		for _, idx in ipairs(occurrence) do
			numOccurrence[idx] = v
		end
	end

	local first = ""
	local last = ""

    local sortedKeys = sortKeys(numOccurrence)
    for _, key in ipairs(sortedKeys) do
        local num = numOccurrence[key]
		if first == "" then
			first = tostring(num)
		else
			last = tostring(num)
		end
	end

	if last == "" then
		last = first
	end
	return tonumber(first .. last, 10)
end

-- tests the functions above
local file = "input.txt"
local lines = lines_from(file)

-- print all line numbers and their contents
local ans = 0
for _, line in pairs(lines) do
    ans = ans + find_calibration_value_with_letter(line)
end
print(ans)
