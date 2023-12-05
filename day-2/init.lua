local status_ok, inspect = pcall(require, "inspect")
if not status_ok then
    print("Failed to load inspect library")
    return
end

function file_exists(file)
	local f = io.open(file, "rb")
	if f then
		f:close()
	end
	return f ~= nil
end

function lines_from(file)
	if not file_exists(file) then
		return {}
	end
	local lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
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

local file = "input.txt"
local lines = lines_from(file)

-- print all line numbers and their contents
local ans = 0
for _, line in pairs(lines) do
    local game_number, game_detail = line:match("Game (%d+): (.+)")
    if determine_possible_game(game_detail) then
        ans = ans + game_number
    end
end

print(ans)
