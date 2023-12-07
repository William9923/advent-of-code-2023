local part = {}

function part.get_part()
	local part = arg[1]

	if part == nil then
		return error("No part selected... (supported part: [1,2])")
	end
	return part
end

return part
