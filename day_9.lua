local status_ok, inspect = pcall(require, "inspect")
if not status_ok then
	print("cannot import inspect library")
end

local status_ok, cio = pcall(require, "libs.cio")
if not status_ok then
	print("cannot import libs.io library")
end

local status_ok, collections = pcall(require, "libs.collections")
if not status_ok then
	print("cannot import libs.collections library")
end

local status_ok, cstrings = pcall(require, "libs.strings")
if not status_ok then
	print("cannot import libs.cstring library")
end

local status_ok, reducer = pcall(require, "libs.reducer")
if not status_ok then
	print("cannot import libs.reducer library")
end

local status_ok, cpart = pcall(require, "libs.part")
if not status_ok then
	print("cannot import libs.part library")
end

function parse_history(line)
	return collections.map(cstrings.split(line, " "), tonumber)
end

function find_diff(nums)
	local diffs = {}
	curr = nums[1]
	for i = 2, #nums, 1 do
		table.insert(diffs, nums[i] - curr)
		curr = nums[i]
	end
	return diffs
end

function is_zero_diff(nums)
	return collections.all(nums, function(value)
		return value == 0
	end)
end

function find_last_history(nums)
	local diffs = find_diff(nums)
	if is_zero_diff(diffs) then
		return nums[#nums]
	end
	return find_last_history(diffs) + nums[#nums]
end

function find_first_history(nums)
	local diffs = find_diff(nums)
	if is_zero_diff(diffs) then
		return nums[1]
	end
	return nums[1] - find_first_history(diffs)
end

local part = cpart.get_part()
print(string.format("Part: %d", part))

if part == "1" then
	local histories = {}
	for _, line in pairs(cio.lines()) do
		table.insert(histories, parse_history(line))
	end

	local ans = {}
	for _, history in pairs(histories) do
		table.insert(ans, find_last_history(history))
	end

	print(inspect(ans))
	print(reducer.sum(ans))
end

if part == "2" then
	local histories = {}
	for _, line in pairs(cio.lines()) do
		table.insert(histories, parse_history(line))
	end

	local ans = {}
	for _, history in pairs(histories) do
		table.insert(ans, find_first_history(history))
	end

	print(inspect(ans))
	print(reducer.sum(ans))
end
