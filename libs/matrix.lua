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

return matrix
