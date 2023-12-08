local strings = {}
function strings.trim(text)
	return text:match("^%s*(.-)%s*$")
end

function strings.remove_space(text)
	local res, _ = string.gsub(text, "%s+", "")
	return res
end

function strings.split(s, sep)
	local fields = {}

	local sep = sep or " "
	local pattern = string.format("([^%s]+)", sep)
	_ = string.gsub(s, pattern, function(c)
		fields[#fields + 1] = c
	end)

	return fields
end

return strings
