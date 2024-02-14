local deque = {}
function deque.new()
	return { first = 0, last = -1 }
end

function deque.pushleft(list, value)
	local first = list.first - 1
	list.first = first
	list[first] = value
end

function deque.pushright(list, value)
	local last = list.last + 1
	list.last = last
	list[last] = value
end

function deque.popleft(list)
	local first = list.first
	if first > list.last then
		error("list is empty")
	end
	local value = list[first]
	list[first] = nil -- to allow garbage collection
	list.first = first + 1
	return value
end

function deque.popright(list)
	local last = list.last
	if list.first > last then
		error("list is empty")
	end
	local value = list[last]
	list[last] = nil -- to allow garbage collection
	list.last = last - 1
	return value
end

function deque.isempty(list)
	return list.first > list.last
end

function deque.length(list)
	return list.last - list.first + 1
end

return deque
