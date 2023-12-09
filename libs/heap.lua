-- Refer from: https://github.com/Roblox/Wiki-Lua-Libraries/blob/master/StandardLibraries/Heap.lua
Heap = {}
Heap.__index = Heap
local Floor = math.floor

-- NOTE: min heap (b as new item)
local function default_compare(a, b)
	if a > b then
		return true
	else
		return false
	end
end

function Heap.new(comparator)
	local newHeap = {}
	setmetatable(newHeap, Heap)
	if comparator then
		newHeap.Compare = comparator
	else
		newHeap.Compare = default_compare
	end

	return newHeap
end

local function sift_up(heap, index)
	local parentIndex
	if index ~= 1 then
		parentIndex = Floor(index / 2)
		if heap.Compare(heap[parentIndex], heap[index]) then
			heap[parentIndex], heap[index] = heap[index], heap[parentIndex]
			sift_up(heap, parentIndex)
		end
	end
end

local function sift_down(heap, index)
	local leftChildIndex, rightChildIndex, minIndex
	leftChildIndex = index * 2
	rightChildIndex = index * 2 + 1
	if rightChildIndex > #heap then
		if leftChildIndex > #heap then
			return
		else
			minIndex = leftChildIndex
		end
	else
		if not heap.Compare(heap[leftChildIndex], heap[rightChildIndex]) then
			minIndex = leftChildIndex
		else
			minIndex = rightChildIndex
		end
	end

	if heap.Compare(heap[index], heap[minIndex]) then
		heap[minIndex], heap[index] = heap[index], heap[minIndex]
		sift_down(heap, minIndex)
	end
end
function Heap.insert(heap, newValue)
	table.insert(heap, newValue)

	if #heap <= 1 then
		return
	end

	sift_up(heap, #heap)
end

function Heap.pop(heap)
	if #heap > 0 then
		local toReturn = heap[1]
		heap[1] = heap[#heap]
		table.remove(heap, #heap)
		if #heap > 0 then
			sift_down(heap, 1)
		end
		return toReturn
	else
		return nil
	end
end

function Heap.peek(heap)
	if #heap > 0 then
		return heap[1]
	else
		return nil
	end
end

function Heap.size(heap)
	return #heap
end

return Heap
