local status_ok, cio = pcall(require, "libs.cio")
if not status_ok then
	print("cannot import libs.io library")
end

local status_ok, cpart = pcall(require, "libs.part")
if not status_ok then
	print("cannot import libs.part library")
end

-- AOC Main code
local configuration = {
	["blue"] = 14,
	["red"] = 12,
	["green"] = 13,
}

function extract_values(round)
	local values = {}
	for count, color in round:gmatch("(%d+) ([a-zA-Z]+)") do
		values[color] = tonumber(count)
	end
	return values
end

function determine_possible_game(game_detail)
	for round in game_detail:gmatch("[^;]+") do
		local values = extract_values(round)
		for color, value in pairs(values) do
			if configuration[color] < value then
				return false
			end
		end
	end

	return true
end

function determine_fewest_cube(game_detail)
	local fewest_cube_needed = {
		["red"] = 0,
		["green"] = 0,
		["blue"] = 0,
	}
	for round in game_detail:gmatch("[^;]+") do
		local values = extract_values(round)
		for color, value in pairs(values) do
			if fewest_cube_needed[color] < value then
				fewest_cube_needed[color] = value
			end
		end
	end

	local total = 1
	for _, value in pairs(fewest_cube_needed) do
		total = total * value
	end

	return total
end

local part = cpart.get_part()
print(string.format("Part: %d", part))

if part == "1" then
	local ans = 0
	for _, line in pairs(cio.lines()) do
		local game_number, game_detail = line:match("Game (%d+): (.+)")
		if determine_possible_game(game_detail) then
			ans = ans + game_number
		end
	end

	print(ans)
end

if part == "2" then
	local ans = 0
	for _, line in pairs(cio.lines()) do
		local game_number, game_detail = line:match("Game (%d+): (.+)")
		ans = ans + determine_fewest_cube(game_detail)
	end

	print(ans)
end
