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

local status_ok, cmatrix = pcall(require, "libs.matrix")
if not status_ok then
	print("cannot import libs.matrix library")
end

local status_ok, deque = pcall(require, "libs.deque")
if not status_ok then
	print("cannot import libs.deque library")
end

local status_ok, collections = pcall(require, "libs.collections")
if not status_ok then
	print("cannot import libs.collections library")
end

local status_ok, reducer = pcall(require, "libs.reducer")
if not status_ok then
	print("cannot import libs.reducer library")
end

-- Logic:
-- | => {(1,0), (-1,0)}
-- - => {(0,1), (0,-1)}
-- L => {(0,1), (-1,0)}
-- J => {(-1,0), (0,-1)}
-- 7 => {(1,0), (0,-1)}
-- F => {(1,0), (0,1)}
--
-- 1. Find starting point => simple search...
-- 2. BFS ? => but the path is based on the directions...
-- 3. only track when it is -1 => non traversed ?
-- 4. then, we can just track all the distance matrix

-- ps: missing the loop -> what does it mean -> loop => need in & out => so the symbol for the pipe need 2 connected parts
-- Part II:
-- => after calculating the distance matrix => now we would need to do a pacific atlantic water flow => like get all the border that is not filled from the main loop ?
-- => Problem ? how do we differentiate between normal pipe & enclosed pipe
-- => let say we kind of reduce all into only main loop => then what?
-- calculate distance
-- 1. remove all junk pipes => ground (.)
-- 2. flood fill from the outside (non pipe ofcourse) => 3 state to save (loc_r, loc_c, in/out) => use dfs => apply to all then?
-- 3. reverse it when meet pipe... => in/out
-- 4. once we fill all of it (-minus pipe)...
-- 5. flatten => calculate the count of I

local puzzle_directions = {
	["|"] = { { 1, 0 }, { -1, 0 } },
	["-"] = { { 0, 1 }, { 0, -1 } },
	["L"] = { { -1, 0 }, { 0, 1 } },
	["J"] = { { -1, 0 }, { 0, -1 } },
	["7"] = { { 1, 0 }, { 0, -1 } },
	["F"] = { { 1, 0 }, { 0, 1 } },
}

local function get_connected_pipes(puzzle_matrix, curr_pos)
	local symbol = puzzle_matrix[curr_pos[1]][curr_pos[2]]
	local directions = puzzle_directions[symbol]

	local candidates = {}
	for _, direction in ipairs(directions) do
		local new_r, new_c = curr_pos[1] + direction[1], curr_pos[2] + direction[2]
		if not cmatrix.is_out_of_bound(puzzle_matrix, new_r, new_c) then
			table.insert(candidates, { new_r, new_c })
		end
	end

	return candidates
end

local function find_puzzle_starting_point(puzzle)
	local m, n = #puzzle, #puzzle[1]
	local starting_r, starting_c = -1, -1

	for r = 1, m, 1 do
		for c = 1, n, 1 do
			if puzzle[r][c] == "S" then
				starting_r = r
				starting_c = c
			end
		end
	end

	for _, starting_symbol in ipairs({ "|", "-", "L", "J", "7", "F" }) do
		puzzle[starting_r][starting_c] = starting_symbol
		local connected_pipes = get_connected_pipes(puzzle, { starting_r, starting_c })
		print(starting_symbol, inspect(connected_pipes))

		local both_valid = true
		for _, candidate_loc in ipairs(connected_pipes) do
			local candidate_r, candidate_c = candidate_loc[1], candidate_loc[2]
			local candidate_symbol = puzzle[candidate_r][candidate_c]

			print(candidate_symbol, candidate_r, candidate_c)

			if candidate_symbol == "|" then
				valid = (candidate_r == starting_r - 1 or candidate_r == starting_r + 1) and (candidate_c == starting_c)
			elseif candidate_symbol == "-" then
				valid = (candidate_r == starting_r) and (candidate_c == starting_c - 1 or candidate_c == starting_c + 1)
			elseif candidate_symbol == "L" then
				valid = (candidate_r == starting_r and candidate_c == starting_c - 1)
					or (candidate_r == starting_r + 1 and candidate_c == starting_c)
			elseif candidate_symbol == "J" then
				valid = (candidate_r == starting_r and candidate_c == starting_c + 1)
					or (candidate_r == starting_r + 1 and candidate_c == starting_c)
			elseif candidate_symbol == "7" then
				valid = (candidate_r == starting_r and candidate_c == starting_c + 1)
					or (candidate_r == starting_r - 1 and candidate_c == starting_c)
			elseif candidate_symbol == "F" then
				valid = (candidate_r == starting_r and candidate_c == starting_c - 1)
					or (candidate_r == starting_r - 1 and candidate_c == starting_c)
			elseif candidate_symbol == "." then
				valid = false
			end

			if not valid then
				both_valid = false
			end
		end

		if both_valid then
			return starting_r, starting_c
		end
	end

	assert(false, "should never reach here")
end

local puzzle_matrix = cmatrix.build_from_inputs(cio.lines())
local puzzle_distance_matrix = cmatrix.create_empty(#puzzle_matrix, #puzzle_matrix[1])
local starting_r, starting_c = find_puzzle_starting_point(puzzle_matrix)

local queue = deque.new()
deque.pushright(queue, { starting_r, starting_c })
local distance = 0

while not deque.isempty(queue) do
	local curr_length = deque.length(queue)
	for _ = 1, curr_length, 1 do
		local location = deque.popleft(queue)
		local location_r, location_c = location[1], location[2]
		if puzzle_distance_matrix[location_r][location_c] == -1 then
			puzzle_distance_matrix[location_r][location_c] = distance

			for _, neighbor in ipairs(get_connected_pipes(puzzle_matrix, { location_r, location_c })) do
				deque.pushright(queue, neighbor)
			end
		end
	end
	distance = distance + 1
end

print("Puzzle:")
print(inspect(puzzle_matrix))
print("Distance Matrix:")
print(inspect(puzzle_distance_matrix))
print("Max Distance Matrix:")
print(reducer.max(cmatrix.flatten(puzzle_distance_matrix)))
