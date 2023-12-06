local status_ok, cio = pcall(require, "libs.cio")
if not status_ok then
	print("cannot import libs.io library")
end

local status_ok, inspect = pcall(require, "inspect")
if not status_ok then
	print("cannot import inspect library")
end

print(inspect(cio.lines()))
print(inspect(cio.lines()))
