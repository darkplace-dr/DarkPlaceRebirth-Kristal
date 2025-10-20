-- Warp Bin
-- god I am so sorry for how shitty this code is

--- The thing you put in the Warp Bin to warp to places \
--- must be 8 characters long and be in upper case
---@alias WarpBinCode string

--- defines the behavior of a Warp Bin code
---@class WarpBinCodeInfo
--- what to do after the code is entered \
--- if a string, treated as a map's id and the player is teleported there \
--- if the last argument is a function, the function is run
---@field result string|(fun(cutscene: WorldCutscene):string|WarpBinCodeInfoMini|nil) map id or cutscene
---@field marker? string in case result is a string, the name of the marker you want to teleport the player to
---@field cond? fun():boolean|nil if defined, this must return true for the player to be allowed to warp
---@field flagcheck? string the name of a flag that must be true or be equal to flagvalue for the player to be allowed to warp. If this is prefixed with an !, then the condition is inverted
---@field flagvalue? any the value that the flag in flagcheck should be equal to
---@field on_fail? fun(cutscene: WorldCutscene) called when the condition is not satifised
---@field silence_system_messages? boolean
---@field mod? string the mod ID of a mod to swap into.
---@field instant? boolean whether to automatically confirm the selection as soon as the code is typed

---@class WarpBinCodeInfoMini
---@field result string map id
---@field marker? string in case result is a string, the name of the marker you want to teleport the player to

-- I'm going to cause pain and suffering with one weird trick:
-- here's the table containing any and all warp codes for the 
-- warp bin.
-- have fun :]   -Char                 (well its NOT that bad) \
-- to add new codes you'd add new entries of "type" WarpBinCodeInfo to the table below.
-- If you have sumneko's Lua LS you should be able to get nice annonations
---@type table<WarpBinCode, WarpBinCodeInfo>
Mod.warp_bin_codes = {
    ["TESTROOM"] = { result = "room1" },
    ["00000000"] = { result = "warp_hub/hub" },
    ["DESSHERE"] = { result = "dessstuff/dessstart" },
    ["RDMCODE"] = {
        result = function(cutscene)
            cutscene:text("* test uwu.")
        end,
    },
    ["FLOORONE"] = { result = "main_hub" },
}
local gray_area_info = {
    result = function(cutscene)
        Game:setFlag("greyarea_exit_to", {Game.world.map.id, Game.world.player.x, Game.world.player.y})
        cutscene:text("[voice:none][instant]* OPEN[stopinstant] [wait:10]\n[instant]YOUR[stopinstant] [wait:30]\n[instant]EYES[stopinstant] [wait:30]\n", nil, nil, {auto = true, skip = false})
        cutscene:after(function()
            Game.world:loadMap("greyarea", "entry")
        end)
    end,
    instant = true
}
Mod.warp_bin_codes["GRAYAREA"] = gray_area_info
Mod.warp_bin_codes["GREYAREA"] = gray_area_info

-- heres some new totally cool helper functions wowee

--- get a Bin Code's info
---@param code WarpBinCode
---@return WarpBinCodeInfo info
function Mod:getBinCode(code)
    code = code:upper()
    for id, mod in  pairs(Kristal.Mods.data) do
        if mod.dlc and mod.dlc.extraBinCodes and mod.dlc.extraBinCodes[code] then
            local info = mod.dlc.extraBinCodes[code]
            if info == true then
                return {
                    result = mod.map,
                    mod = id,
                }
            end
            return info
        end
    end

    return Mod.warp_bin_codes[code]
end

-- if you were looking for addBinCode... just tamper with the table on your own

-- the actual logic is implemented in scripts/world/cutscenes/warp_bin.lua
