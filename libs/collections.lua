local collections = {}

function collections.contains(tbl, value)
	for _, v in pairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

function collections.map(tbl, fn)
	local t = {}
	for k, v in pairs(tbl) do
		t[k] = fn(v)
	end
	return t
end

return collections
