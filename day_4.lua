local status_ok, inspect = pcall(require, "inspect")
if not status_ok then
	print("cannot import inspect library")
end

local status_ok, cio = pcall(require, "libs.cio")
if not status_ok then
	print("cannot import libs.io library")
end

local status_ok, collections = pcall(require, "libs.collections")
if not status_ok then
	print("cannot import libs.collections library")
end

local status_ok, cpart = pcall(require, "libs.part")
if not status_ok then
	print("cannot import libs.part library")
end

local part = cpart.get_part()
print(string.format("Part: %d", part))

function extract(line)
	local winning_number_raw, game_number_raw = line:match("Card%s*%d+:%s*(%d+[%s%d]+)%s*%|%s*([%s%d]+)")
	return winning_number_raw:match("^%s*(.-)%s*$"), game_number_raw:match("^%s*(.-)%s*$")
end

function split(s, sep)
	local fields = {}

	local sep = sep or " "
	local pattern = string.format("([^%s]+)", sep)
	_ = string.gsub(s, pattern, function(c)
		fields[#fields + 1] = c
	end)

	return fields
end

function collect_winning_number(line)
	local winning_number_raw, game_number_raw = extract(line)
	local winning_numbers = split(winning_number_raw, " ")
	local game_numbers = split(game_number_raw, " ")

	local collected_numbers = {}

	for _, v in ipairs(game_numbers) do
		if collections.contains(winning_numbers, v) then
			table.insert(collected_numbers, v)
		end
	end

	return collected_numbers
end

if part == "1" then
  local ans = 0
  for _, line in pairs(cio.lines()) do
    local count = #collect_winning_number(line) 
    if count == 0 then
      goto continue
    end
    ans = ans + 2 ^ (count - 1)
    ::continue::
  end

  print(ans)
end

