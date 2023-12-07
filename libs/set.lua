local set = {}
function set.new()
	return {}
end

function set.add(set, value)
	set[value] = true
end

function set.exist(set, value)
	return set[value]
end

function set.remove(set, value)
	set[value] = false
end

return set
