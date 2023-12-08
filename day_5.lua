local status_ok, inspect = pcall(require, "inspect")
if not status_ok then
	print("cannot import inspect library")
end

local status_ok, cio = pcall(require, "libs.cio")
if not status_ok then
	print("cannot import libs.io library")
end

local status_ok, cpart = pcall(require, "libs.part")
if not status_ok then
	print("cannot import libs.part library")
end

local status_ok, reducer = pcall(require, "libs.reducer")
if not status_ok then
	print("cannot import libs.reducer library")
end

local status_ok, cstrings = pcall(require, "libs.strings")
if not status_ok then
	print("cannot import libs.strings library")
end

-- Logic:
-- 79 14 55 13
--
-- seed to soil: 79 => 81
-- soil to fertilizer: 81 => 81
-- fertilizer to water : 81 => 81
-- water to light: 81 => 74
-- light to temperature: 74 => 78
-- termerature to humidity: 78 => 78
-- humidity to location: 78 => 82
--
-- Very simple:
-- 1. Build the mapper graph
-- 2. The mapper structure is:
--      [start, end, diff] => source, source+range, source - destination
-- 3. For each seed in each phase:
--      loop through the mapper => if anything in the start end range => then
--      apply the changes
--      if didn't return early on loop => return exact value
-- 4. Return the min

function parse_to_chunks(lines)
	local chunks = {}
	local chunk = {}
	for _, line in pairs(lines) do
		if line == "" then
			table.insert(chunks, chunk)
			chunk = {}
		else
			table.insert(chunk, line)
		end
	end
	table.insert(chunks, chunk)
	return chunks
end

function parse_seeds(line)
	local seeds = cstrings.trim(line[1]:match("seeds%s*: (.+)"))
	return map(cstrings.split(seeds, " "), tonumber)
end

function map(tbl, fn)
	local t = {}
	for k, v in pairs(tbl) do
		t[k] = fn(v)
	end
	return t
end

function parse_mapper(lines)
	local mapper = {}
	for i, line in ipairs(lines) do
		if i == 1 then
			goto continue
		end
		local parsed_range = map(cstrings.split(line, " "), tonumber)
		local destination, source, range = parsed_range[1], parsed_range[2], parsed_range[3]

		table.insert(mapper, { source, source + range - 1, destination - source })

		::continue::
	end
	return mapper
end

function map_result(mapper, value)
	for _, items in ipairs(mapper) do
		local range_start, range_end, effect = items[1], items[2], items[3]
		if value >= range_start and value <= range_end then
			return value + effect
		end
	end
	return value
end

local input_chunks = parse_to_chunks(cio.lines())
local seeds = parse_seeds(input_chunks[1])
local mappers = {}
for i = 2, #input_chunks, 1 do
	table.insert(mappers, parse_mapper(input_chunks[i]))
end

local locations = {}
for i, seed in pairs(seeds) do
	local location = seed
	for _, mapper in ipairs(mappers) do
		location = map_result(mapper, location)
	end
	table.insert(locations, location)
end

print(reducer.min(locations))
