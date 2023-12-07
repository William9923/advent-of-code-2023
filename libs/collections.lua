local collections = {}

function collections.contains(list, value)
	for _, v in pairs(list) do
		if v == value then
			return true
		end
	end
	return false
end

return collections
