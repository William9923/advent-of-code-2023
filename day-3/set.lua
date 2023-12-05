Set = {}
function Set.new()
	return {}
end

function Set.add(set, value)
	set[value] = true
end

function Set.exist(set, value)
	return set[value]
end

function Set.remove(set, value)
	set[value] = false
end

-- local set = Set.new()
-- Set.add(set, "1|2")
-- Set.add(set, "2|3")
-- Set.add(set, "3|4")
--
-- print(Set.exist(set, "1|2"))
-- print(Set.exist(set, "3|4"))
--
-- Set.remove(set, "2|3")
-- print(Set.exist(set, "2|3"))
--
return Set
