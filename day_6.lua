local status_ok, inspect = pcall(require, "inspect")
if not status_ok then
	print("cannot import inspect library")
end

local status_ok, cio = pcall(require, "libs.cio")
if not status_ok then
	print("cannot import libs.io library")
end

local status_ok, cstrings = pcall(require, "libs.strings")
if not status_ok then
	print("cannot import libs.cstring library")
end

local status_ok, collections = pcall(require, "libs.collections")
if not status_ok then
	print("cannot import libs.collections library")
end

local status_ok, cpart = pcall(require, "libs.part")
if not status_ok then
	print("cannot import libs.part library")
end

local status_ok, reducer = pcall(require, "libs.reducer")
if not status_ok then
	print("cannot import libs.reducer library")
end

-- Logic:
-- Time:      7 15  30
-- Distance:  9 40 200
-- 1. Parse into 2 parts => {time, min_distance}
-- 2. check distance => i = 0..7 => i * (rem_time - curr_time) > min_distance
-- 3. get total number that are true on check distance => mult every parts

function parse_data(lines)
	local times = collections.map(cstrings.split(cstrings.trim(lines[1]:match("Time%s*: (.+)")), " "), tonumber)
	local distances = collections.map(cstrings.split(cstrings.trim(lines[2]:match("Distance%s*: (.+)")), " "), tonumber)

	local data = {}
	for i = 1, #times, 1 do
		table.insert(data, { times[i], distances[i] })
	end

	return data
end

-- Tbh, you can just edit the input file => this is function is created so we can run automation
function parse_data_v2(lines)
	local times = tonumber(cstrings.remove_space(cstrings.trim(lines[1]:match("Time%s*: (.+)"))))
	local distances = tonumber(cstrings.remove_space(cstrings.trim(lines[2]:match("Distance%s*: (.+)"))))

	local data = {}
	table.insert(data, { times, distances })
	return data
end

function count_winning_margin(data)
	local margin = 0
	for i = 0, data[1], 1 do
		if i * (data[1] - i) > data[2] then
			margin = margin + 1
		end
	end
	return margin
end

local part = cpart.get_part()
print(string.format("Part: %d", part))

if part == "1" then
	local datas = parse_data(cio.lines())
	local margins = {}
	for _, data in pairs(datas) do
		table.insert(margins, count_winning_margin(data))
	end
	print(reducer.dot(margins))
end

if part == "2" then
	local datas = parse_data_v2(cio.lines())
	local margins = {}
	for _, data in pairs(datas) do
		table.insert(margins, count_winning_margin(data))
	end
	print(reducer.dot(margins))
end
