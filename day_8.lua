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

local part = cpart.get_part()
print(string.format("Part: %d", part))

-- Logic:
-- 1. parse (2 parts)
--  - steps => done
--  - skip
--  - iteratively till it ends (.+)%s+=%s+\((.+),%s+(.+)\))
-- 2. get items into map => [source] = [destination1, destination2]
-- 3. simulate it based on the move, repeat until found
-- => 4 print out what count we need
-- 2nd part...
-- => need to kind of track multiple part...
-- => on parsing, need to also take into account number

function parse_jumper(line)
	local source, jump_range = line:match("(%w+)%s*=%s*%(([%w,%s]*)%)")
	local jump_ranges = cstrings.split(jump_range, ", ")
	return source, collections.map(jump_ranges, cstrings.trim)
end

function find_initial_node(nodes_map)
	return find_node(nodes_map, function(node)
		return string.sub(node, 3, 3) == "A"
	end)
end

function find_termination_node(nodes_map)
	return find_node(nodes_map, function(node)
		return string.sub(node, 3, 3) == "Z"
	end)
end

function find_node(nodes_map, condition)
	local mem = {}
	for node, _ in pairs(nodes_map) do
		if condition(node) then
			table.insert(mem, node)
		end
	end
	return mem
end

function check_all_finish(curr_node, terminate_node)
	for _, node in pairs(curr_node) do
		if not collections.contains(terminate_node, node) then
			return false
		end
	end
	return true
end

if part == "1" then
	local jumper = {}
	local lines = cio.lines()
	local steps = lines[1]

	for i = 3, #lines, 1 do
		local source, destination = parse_jumper(lines[i])
		jumper[source] = destination
	end

	-- instead of hardcoded initial => AAA, and termination => ZZZ, now we need to find
	-- 1. all initial node
	-- 2. all termination node
	-- 3. => simulate the process until the initial => in the termination node
	local curr = "AAA"
	local ans = 0
	while curr ~= "ZZZ" do
		local curr_step_direction_idx = (ans % #steps) + 1
		local curr_step = string.sub(steps, curr_step_direction_idx, curr_step_direction_idx)
		if jumper[curr] == nil then
			break
		end
		if curr_step == "L" then
			curr = jumper[curr][1]
		else
			curr = jumper[curr][2]
		end

		ans = ans + 1
	end

	print(ans)
end

if part == "2" then
	local jumper = {}
	local lines = cio.lines()
	local steps = lines[1]

	for i = 3, #lines, 1 do
		local source, destination = parse_jumper(lines[i])
		jumper[source] = destination
	end

	local curr_nodes = find_initial_node(jumper)
	local termination_nodes = find_termination_node(jumper)
	local ans = 0
	while not check_all_finish(curr_nodes, termination_nodes) do
		local curr_step_direction_idx = (ans % #steps) + 1
		local curr_step = string.sub(steps, curr_step_direction_idx, curr_step_direction_idx)
		if curr_step == "L" then
			for i = 1, #curr_nodes, 1 do
				curr_nodes[i] = jumper[curr_nodes[i]][1]
			end
		else
			for i = 1, #curr_nodes, 1 do
				curr_nodes[i] = jumper[curr_nodes[i]][2]
			end
		end

		ans = ans + 1
	end

	print(ans)
end
