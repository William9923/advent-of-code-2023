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

function find_left_calibration_value(calibration)
	for i = 1, #calibration do
		if tonumber(string.sub(calibration, i, i)) then
			return string.sub(calibration, i, i)
		end
	end
end

function find_left_calibration_value_with_letter(calibration)
	for i = 1, #calibration do
		if tonumber(string.sub(calibration, i, i)) then
			return string.sub(calibration, i, i)
		end

		for key, val in pairs(letterToNumMap) do
			if string.sub(calibration, i, i + #key - 1) == key then
				return tostring(val)
			end
		end
	end
end

function find_right_calibration_value(calibration)
	for i = #calibration, 1, -1 do
		if tonumber(string.sub(calibration, i, i)) then
			return string.sub(calibration, i, i)
		end
	end
end

function find_right_calibration_value_with_letter(calibration)
	for i = #calibration, 1, -1 do
		if tonumber(string.sub(calibration, i, i)) then
			return string.sub(calibration, i, i)
		end
		for key, val in pairs(letterToNumMap) do
			if string.sub(calibration, i - #key + 1, i) == key then
				return tostring(val)
			end
		end
	end
end

function find_calibration_value(calibration)
	local left = find_left_calibration_value(calibration)
	local right = find_right_calibration_value(calibration)
	return tonumber(left .. right, 10)
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
	local left = find_left_calibration_value_with_letter(calibration)
	local right = find_right_calibration_value_with_letter(calibration)
	return tonumber(left .. right, 10)
end

local part = arg[1]
if part == nil then
	print("No part selected... (supported part: [1,2])")
	return
else
	print(string.format("Part: %d", part))
end

if part == "1" then
	local ans = 0
	for _, line in pairs(cio.lines()) do
		ans = ans + find_calibration_value(line)
	end
	print(ans)
end

if part == "2" then
	local ans = 0
	for _, line in pairs(cio.lines()) do
		ans = ans + find_calibration_value_with_letter(line)
	end
	print(ans)
end
