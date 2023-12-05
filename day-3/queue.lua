Deque = {}
function Deque.new()
	return { first = 0, last = -1 }
end

function Deque.pushleft(list, value)
	local first = list.first - 1
	list.first = first
	list[first] = value
end

function Deque.pushright(list, value)
	local last = list.last + 1
	list.last = last
	list[last] = value
end

function Deque.popleft(list)
	local first = list.first
	if first > list.last then
		error("list is empty")
	end
	local value = list[first]
	list[first] = nil -- to allow garbage collection
	list.first = first + 1
	return value
end

function Deque.popright(list)
	local last = list.last
	if list.first > last then
		error("list is empty")
	end
	local value = list[last]
	list[last] = nil -- to allow garbage collection
	list.last = last - 1
	return value
end

function Deque.isempty(list)
	return list.first > list.last
end

-- local queue = Deque.new()
-- Deque.pushleft(queue, { 1, 2 })
-- Deque.pushleft(queue, { 2, 3 })
-- Deque.pushleft(queue, { 3, 2 })
-- Deque.pushleft(queue, { 4, 2 })
-- local value1 = Deque.popleft(queue)
-- local value2 = Deque.popright(queue)
-- print(value1[1])
-- print(value2[2])
--
-- print(Deque.isempty(queue))
-- local value1 = Deque.popleft(queue)
-- local value2 = Deque.popright(queue)
-- print(Deque.isempty(queue))

return Deque
