local inspect = require("inspect")
local Deque = require("queue")
local Set = require("set")

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

function convert_to_matrix(lines)
	local matrix = {}
	for _, line in pairs(lines) do
		local row = {}
		for i = 1, #line do
			row[i] = line:sub(i, i)
		end
		table.insert(matrix, row)
	end
	return matrix
end

function generate_eligible_matrix(matrix)
	local m, n = #matrix, #matrix[1]
	local queue = Deque.new()
	local visited = Set.new()

	local eligible_matrix = {}
	for i = 1, m, 1 do
		local row = {}
		local curr = matrix[i]
		for j = 1, n, 1 do
			row[j] = false
			if curr[j] ~= "." and not tonumber(curr[j]) then
				Deque.pushright(queue, { i, j })
			end
		end
		table.insert(eligible_matrix, row)
	end

	local directions = { { 0, 1 }, { 0, -1 }, { 1, 0 }, { -1, 0 }, { 1, 1 }, { 1, -1 }, { -1, 1 }, { -1, -1 } }

	while not Deque.isempty(queue) do
		local loc = Deque.popleft(queue)
		local key = generate_key(loc[1], loc[2])
		if Set.exist(visited, key) then
			goto continue -- skip
		end
		Set.add(visited, key)
		eligible_matrix[loc[1]][loc[2]] = true

		for _, dir in ipairs(directions) do
			new_r, new_c = dir[1] + loc[1], dir[2] + loc[2]
			if new_r < 1 or new_r > m or new_c < 1 or new_c > n then
				goto next_direction
			end
			if Set.exist(visited, generate_key(new_r, new_c)) then
				goto next_direction
			end
			if matrix[new_r][new_c] == "." then
				goto next_direction
			end
			Deque.pushright(queue, { new_r, new_c })
			::next_direction::
		end

		::continue::
	end

	return eligible_matrix
end

function generate_key(locX, locY)
	return tostring(locX) .. "|" .. tostring(locY)
end

function extract_eligible_engine(matrix, eligibility)
	local ans = {}
	local m, n = #matrix, #matrix[1]
	for i = 1, m, 1 do
		local curr = 0
		for j = 1, n, 1 do
			if not eligibility[i][j] then
				if curr ~= 0 then
					table.insert(ans, curr)
					curr = 0
				end
				goto continue
			end

			local val = tonumber(matrix[i][j])
			if val then
				if curr ~= 0 then
					curr = curr * 10 + val
				else
					curr = val
				end
			else
				table.insert(ans, curr)
				curr = 0
			end
			::continue::
		end
		if curr ~= 0 then
			table.insert(ans, curr)
			curr = 0
		end
	end
	return ans
end

function sum(list)
	local total = 0
	for _, v in ipairs(list) do
		total = total + v
	end
	return total
end

-- tests the functions above
local file = "input.txt"
local lines = lines_from(file)

local matrix = convert_to_matrix(lines)
local eligible_matrix = generate_eligible_matrix(matrix)
local eligible_part = extract_eligible_engine(matrix, eligible_matrix)
print(inspect(eligible_part))
print(sum(eligible_part))
