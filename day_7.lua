local status_ok, inspect = pcall(require, "inspect")
if not status_ok then
	print("cannot import inspect library")
end

local status_ok, cio = pcall(require, "libs.cio")
if not status_ok then
	print("cannot import libs.io library")
end

local status_ok, cstrings = pcall(require, "libs.strings")
if not status_ok then
	print("cannot import libs.cstring library")
end

local status_ok, heap = pcall(require, "libs.heap")
if not status_ok then
	print("cannot import libs.heap library")
end

local status_ok, cpart = pcall(require, "libs.part")
if not status_ok then
	print("cannot import libs.part library")
end

local status_ok, reducer = pcall(require, "libs.reducer")
if not status_ok then
	print("cannot import libs.reducer library")
end

-- Logic:
-- - Parse => (card, bid) => DONE
-- - How to score card value? -> we need to ensure that when each limit is fulfilled => then after that what is the scoring for each limit… (each limit also had hierarchy)
-- - First Order: => we can use hash map, this Is simple => DONE
--     - Check Five of a kind = 6
--     - Check four of a kind = 5
--     - Check full house = 4
--     - Check three of a kind = 3
--     - Check two pair = 2
--     - Check one pair = 1
--     - Check high card = 0
-- - Second Order: => IN progress
--     - It’s a little bit harder yea?
--     - We could rank all card into give it a value…
--     - A: 14, K: 13, Q: 12, J: 11, T: 10, 9, 8, 7, 6, 5, 4, 3, 2…
-- - Then we use heap to compare all of it… => create a custom comparator…
-- - Pop each heap (using min heap) -> then count how many pop (as rank)
-- - Use the rank / count & bid value to calculate total winnings…

--  2nd part => Joker Logic...
-- Problem is easy => add to most max one => since it will automatically upgrade the value?
-- The difficulity is from three of a kind => full house
-- But, if there are three of a kind => automatically be four of a kind
-- If there are full house with 2 J => automatically be five of a kind
-- if there are 4 of a kind with J => automatically be five of a kind
-- Is there possibility from 2 pair => full house (yes, but no need different approach)
-- 1 + 2 + 2J => 1 + 4 pair, yea let's go i guess

local part = cpart.get_part()
print(string.format("Part: %d", part))

function parse_camel_cards(lines)
	local datas = {}
	for _, line in pairs(lines) do
		local res = cstrings.split(line, " ")
		local cards = res[1]
		local bid = res[2]
		table.insert(datas, { cards, bid })
	end
	return datas
end

function no_joker_callback(mem)
	return mem
end

function with_joker_callback(mem)
	local count_joker = mem["J"]
	if not count_joker then
		return mem
	end

	if count_joker == 5 then
		return mem
	end

	local label = ""
	local curr = 0
	for k, v in pairs(mem) do
		if k ~= "J" then
			if v > curr then
				label = k
				curr = v
			end
		end
	end

	mem["J"] = nil
	mem[label] = mem[label] + count_joker
	return mem
end

function determine_cards_type(cards, post_count_callback)
	mem = {}
	for i = 1, #cards, 1 do
		local curr = string.sub(cards, i, i)
		if not mem[curr] then
			mem[curr] = 0
		end
		mem[curr] = mem[curr] + 1
	end

	mem = post_count_callback(mem)

	if is_five_of_a_kind(mem) then
		return 6
	end

	if is_four_of_a_kind(mem) then
		return 5
	end

	if is_full_house(mem) then
		return 4
	end

	if is_three_of_a_kind(mem) then
		return 3
	end

	if is_two_pair(mem) then
		return 2
	end

	if is_one_pair(mem) then
		return 1
	end

	return 0
end

-- Type determiner...
function is_five_of_a_kind(mem)
	return calculate_occurrence(mem, 5) == 1
end

function is_four_of_a_kind(mem)
	return calculate_occurrence(mem, 4) == 1
end

function is_full_house(mem)
	return calculate_occurrence(mem, 3) == 1 and calculate_occurrence(mem, 2) == 1
end

function is_three_of_a_kind(mem)
	return calculate_occurrence(mem, 3) == 1
end

function is_two_pair(mem)
	return calculate_occurrence(mem, 2) == 2
end

function is_one_pair(mem)
	return calculate_occurrence(mem, 2) == 1
end

function calculate_occurrence(mem, occur_num)
	local count = 0
	for _, v in pairs(mem) do
		if v == occur_num then
			count = count + 1
		end
	end
	return count
end

local card_values = {
	["A"] = 14,
	["K"] = 13,
	["Q"] = 12,
	["J"] = 11,
	["T"] = 10,
	["9"] = 9,
	["8"] = 8,
	["7"] = 7,
	["6"] = 6,
	["5"] = 5,
	["4"] = 4,
	["3"] = 3,
	["2"] = 2,
}

local card_values_v2 = {
	["A"] = 14,
	["K"] = 13,
	["Q"] = 12,
	["T"] = 10,
	["9"] = 9,
	["8"] = 8,
	["7"] = 7,
	["6"] = 6,
	["5"] = 5,
	["4"] = 4,
	["3"] = 3,
	["2"] = 2,
	["J"] = -1,
}

function determine_card_values(cards, card_valuer)
	local values = {}
	for i = 1, #cards, 1 do
		local curr = string.sub(cards, i, i)
		table.insert(values, card_valuer[curr])
	end
	return values
end

function camel_card_comparer(a, b)
	if a[1] == b[1] then
		local cards_a = a[2]
		local cards_b = b[2]
		assert(#cards_a, #cards_b)

		for i = 1, #cards_a, 1 do
			if cards_a[i] ~= cards_b[i] then
				return cards_a[i] > cards_b[i]
			end
		end
	end

	return a[1] > b[1]
end

if part == "1" then
	local datas = parse_camel_cards(cio.lines())
	local h = heap.new(camel_card_comparer)
	for _, game_data in pairs(datas) do
		local hand = determine_cards_type(game_data[1], no_joker_callback)
		local hand_values = determine_card_values(game_data[1], card_values)

		heap.insert(h, { hand, hand_values, game_data[2] })
	end

	local winnings = {}
	local rank = 1
	while heap.size(h) > 0 do
		local game = heap.pop(h)
		assert(game)
		table.insert(winnings, game[3] * rank)
		rank = rank + 1
	end

	print(inspect(winnings))
	print(reducer.sum(winnings))
end

if part == "2" then
	local datas = parse_camel_cards(cio.lines())
	local h = heap.new(camel_card_comparer)
	for _, game_data in pairs(datas) do
		local hand = determine_cards_type(game_data[1], with_joker_callback)
		local hand_values = determine_card_values(game_data[1], card_values_v2)

		heap.insert(h, { hand, hand_values, game_data[2] })
	end

	local winnings = {}
	local rank = 1
	while heap.size(h) > 0 do
		local game = heap.pop(h)
		assert(game)
		table.insert(winnings, game[3] * rank)
		rank = rank + 1
	end

	print(inspect(winnings))
	print(reducer.sum(winnings))
end
