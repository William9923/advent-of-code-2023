local status_ok, cio = pcall(require, "libs.cio")
if not status_ok then
	print("cannot import libs.io library")
end

local status_ok, tbl = pcall(require, "libs.tbl")
if not status_ok then
	print("cannot import libs.tbl library")
end

local status_ok, inspect = pcall(require, "inspect")
if not status_ok then
	print("cannot import inspect library")
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

function find_calibration_value_with_letter(calibration)
	local num_occurence = {}

	for i = 1, 10, 1 do
		local occurrence = find_occurrence(calibration, tostring(i))
		for _, idx in ipairs(occurrence) do
			num_occurence[idx] = i
		end
	end

	for k, v in pairs(letterToNumMap) do
		local occurrence = find_occurrence(calibration, k)
		for _, idx in ipairs(occurrence) do
			num_occurence[idx] = v
		end
	end

	local first = ""
	local last = ""

	local sortedKeys = tbl.sort_keys(num_occurence)
	for _, key in ipairs(sortedKeys) do
		local num = num_occurence[key]
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

local ans = 0
for _, line in pairs(cio.lines()) do
	ans = ans + find_calibration_value_with_letter(line)
end
print(ans)
