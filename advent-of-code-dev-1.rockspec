package = "advent-of-code"
version = "dev-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {
      ["day-1..luarocks.config-5.4"] = "day-1/.luarocks/config-5.4.lua",
      ["day-1..luarocks.default-lua-version"] = "day-1/.luarocks/default-lua-version.lua",
      ["day-1.lua_modules.share.lua.5.4.inspect"] = "day-1/lua_modules/share/lua/5.4/inspect.lua",
      ["day-1.main"] = "day-1/main.lua",
      ["day-1.testing"] = "day-1/testing.lua"
   }
}
