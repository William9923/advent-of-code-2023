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

function find_missing_gear(matrix)
	local m, n = #matrix, #matrix[1]
	local need_to_visit = {}
	for i = 1, m, 1 do
		local row = {}
		local curr = matrix[i]
		for j = 1, n, 1 do
			row[j] = false
			if curr[j] == "*" then
				table.insert(need_to_visit, { i, j })
			end
		end
	end

	local directions = { { 0, 1 }, { 0, -1 }, { 1, 0 }, { -1, 0 }, { 1, 1 }, { 1, -1 }, { -1, 1 }, { -1, -1 } }

	local ans = {}
	for _, loc in ipairs(need_to_visit) do
		local key = generate_key(loc[1], loc[2])
		for _, dir in ipairs(directions) do
			new_r, new_c = dir[1] + loc[1], dir[2] + loc[2]
			if new_r < 1 or new_r > m or new_c < 1 or new_c > n then
				goto continue
			end
			if not tonumber(matrix[new_r][new_c]) then
				goto continue
			end

			if not ans[key] then
				ans[key] = {}
			end
			table.insert(ans[key], { new_r, new_c })
			::continue::
		end
	end

	return ans
end

function extract_missing_gears(missing_gears_loc, matrix)
	for key, locs in pairs(missing_gears_loc) do
		local unique = Set.new()
		local uniqueLoc = {}
		for _, loc in ipairs(locs) do
			local starting_point = find_starting_point(loc, matrix)
			local key = generate_key(starting_point[1], starting_point[2])
			if not Set.exist(unique, key) then
				table.insert(uniqueLoc, starting_point)
				Set.add(unique, key)
			end
		end
		missing_gears_loc[key] = uniqueLoc
	end

	local filtered_out_gears_loc = {}
	for key, locs in pairs(missing_gears_loc) do
		if #locs == 2 then
			filtered_out_gears_loc[key] = locs
		end
	end
	return filtered_out_gears_loc
end

function calculate_missing_gear_calibration(filtered_out_gears, matrix)
	local calibrations = {}
	for key, locs in pairs(filtered_out_gears) do
		local calibration = {}
		for _, loc in pairs(locs) do
			table.insert(calibration, get_gear_config(loc, matrix))
		end
		calibrations[key] = calibration
	end
	return calibrations
end

function find_starting_point(loc, matrix)
	while loc[2] > 1 and tonumber(matrix[loc[1]][loc[2] - 1]) do
		loc[2] = loc[2] - 1
	end
	return loc
end

function get_gear_config(loc, matrix)
	local n = #matrix[1]
	local ans = 0
	while loc[2] <= n and tonumber(matrix[loc[1]][loc[2]]) do
		ans = ans * 10 + tonumber(matrix[loc[1]][loc[2]])
		loc[2] = loc[2] + 1
	end
	return ans
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
local missing_gear = find_missing_gear(matrix)
local filtered_out_missing_gears = extract_missing_gears(missing_gear, matrix)
local calibrations = calculate_missing_gear_calibration(filtered_out_missing_gears, matrix)
local ans = 0
for _, vals in pairs(calibrations) do
	ans = ans + (vals[1] * vals[2])
end
print(ans)
-- local eligible_part = extract_eligible_engine(matrix, eligible_matrix)
-- print(inspect(eligible_part))
-- print(sum(eligible_part))
