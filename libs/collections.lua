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

function collections.all(tbl, fn)
	for _, v in pairs(tbl) do
		if not fn(v) then
			return false
		end
	end
	return true
end

return collections
