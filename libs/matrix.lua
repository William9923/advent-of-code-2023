local matrix = {}

function matrix.build_from_inputs(lines)
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

function matrix.create_empty(m, n)
	local matrix = {}
	for r = 1, m, 1 do
		local row = {}
		for c = 1, n, 1 do
			table.insert(row, -1)
		end
		table.insert(matrix, row)
	end
	return matrix
end

function matrix.is_out_of_bound(matrix, r, c)
	local m, n = #matrix, #matrix[1]
	return r < 1 or r > m or c < 1 or c > n
end

function matrix.flatten(matrix)
	local flattened_matrix = {}
	for _, row in ipairs(matrix) do
		for _, val in ipairs(row) do
			table.insert(flattened_matrix, val)
		end
	end
	return flattened_matrix
end

return matrix
