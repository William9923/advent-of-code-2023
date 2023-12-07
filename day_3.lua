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

local status_ok, set = pcall(require, "libs.set")
if not status_ok then
	print("cannot import libs.set library")
end

local status_ok, reducer = pcall(require, "libs.reducer")
if not status_ok then
	print("cannot import libs.reducer library")
end

function generate_eligible_matrix(matrix)
	local m, n = #matrix, #matrix[1]
	local queue = deque.new()
	local visited = set.new()

	local eligible_matrix = {}
	for i = 1, m, 1 do
		local row = {}
		local curr = matrix[i]
		for j = 1, n, 1 do
			row[j] = false
			if curr[j] ~= "." and not tonumber(curr[j]) then
				deque.pushright(queue, { i, j })
			end
		end
		table.insert(eligible_matrix, row)
	end

	local directions = { { 0, 1 }, { 0, -1 }, { 1, 0 }, { -1, 0 }, { 1, 1 }, { 1, -1 }, { -1, 1 }, { -1, -1 } }

	while not deque.isempty(queue) do
		local loc = deque.popleft(queue)
		local key = generate_key(loc[1], loc[2])
		if set.exist(visited, key) then
			goto continue -- skip
		end
		set.add(visited, key)
		eligible_matrix[loc[1]][loc[2]] = true

		for _, dir in ipairs(directions) do
			new_r, new_c = dir[1] + loc[1], dir[2] + loc[2]
			if new_r < 1 or new_r > m or new_c < 1 or new_c > n then
				goto next_direction
			end
			if set.exist(visited, generate_key(new_r, new_c)) then
				goto next_direction
			end
			if matrix[new_r][new_c] == "." then
				goto next_direction
			end
			deque.pushright(queue, { new_r, new_c })
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

function find_missing_gear(matrix)
	local m, n = #matrix, #matrix[1]
	local need_to_visit = {}
	for i = 1, m, 1 do
		local curr = matrix[i]
		for j = 1, n, 1 do
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
		local unique = set.new()
		local uniqueLoc = {}
		for _, loc in ipairs(locs) do
			local starting_point = find_starting_point(loc, matrix)
			local key = generate_key(starting_point[1], starting_point[2])
			if not set.exist(unique, key) then
				table.insert(uniqueLoc, starting_point)
				set.add(unique, key)
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

local part = cpart.get_part()
print(string.format("Part: %d", part))

if part == "1" then
	local matrix = cmatrix.build_from_inputs(cio.lines())
	local eligible_matrix = generate_eligible_matrix(matrix)
	local eligible_part = extract_eligible_engine(matrix, eligible_matrix)
	print(reducer.sum(eligible_part))
end

if part == "2" then
	local matrix = cmatrix.build_from_inputs(cio.lines())
	local missing_gear = find_missing_gear(matrix)
	local filtered_out_missing_gears = extract_missing_gears(missing_gear, matrix)
	local calibrations = calculate_missing_gear_calibration(filtered_out_missing_gears, matrix)

	local calibrations_only = {}
	for _, vals in pairs(calibrations) do
		table.insert(calibrations_only, vals)
	end
	print(reducer.reduce(calibrations_only, 0, function(total, v)
		return total + (v[1] * v[2])
	end))
end
