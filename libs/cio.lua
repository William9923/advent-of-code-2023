local cio = {}
local cached_lines = {}

function cio.lines()
	if #cached_lines == 0 then
		for line in io.lines() do
			cached_lines[#cached_lines + 1] = line
		end
	end
	return cached_lines
end

return cio
