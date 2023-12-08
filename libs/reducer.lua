local reducer = {}

function reducer.reduce(list, initial, fn)
	local res = initial
	for _, v in ipairs(list) do
		res = fn(res, v)
	end
	return res
end

function reducer.sum(list)
	return reducer.reduce(list, 0, function(total, v)
		return total + v
	end)
end

function reducer.dot(list)
	return reducer.reduce(list, 1, function(total, v)
		return total * v
	end)
end

function reducer.min(list)
	return reducer.reduce(list, list[1], function(curr, v)
		if curr < v then
			return curr
		end
		return v
	end)
end

function reducer.max(list)
	return reducer.reduce(list, list[1], function(curr, v)
		if curr > v then
			return curr
		end
		return v
	end)
end

function reducer.count(list)
	return reducer.reduce(list, 0, function(curr, _)
		return curr + 1
	end)
end

return reducer
