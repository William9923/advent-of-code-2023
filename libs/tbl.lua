local tbl = {}

function tbl.sort_keys(data)
	local keys = {}
	for key, _ in pairs(data) do
		table.insert(keys, key)
	end
	table.sort(keys)
	return keys
end

return tbl
