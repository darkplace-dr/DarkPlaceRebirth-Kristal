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
Kristal.warp_bin_codes = {
    ["TESTROOM"] = { result = "room1", mod = "dpr_main" },
    ["00000000"] = { result = "warp_hub/hub", mod = "dpr_main" },
    ["DESSHERE"] = { result = "dessstuff/dessstart", mod = "dpr_main" },
    ["RDMCODE"] = {
        result = function(cutscene)
            cutscene:text("* test uwu.")
        end,
    },
    ["FLOORONE"] = { result = "floor1/main", mod = "dpr_main" },
    ["GIMMICK"] = { result = "gimmick_test/gimmick_test1", mod = "dpr_main" },
    ["SLIDER"] = { result = "slider_start", mod = "dpr_main" },
    ["WIFIDOWN"] = { result = "googlefield", mod = "dpr_main" },
    ["THETOWER"] = { result = "main_outdoors/tower_outside", mod = "dpr_main" },
    ["DEVDINER"] = {
        result = function(cutscene)
            cutscene:text("* This isn't legacy you [shake:5]idiot[shake:1].")
        end,
    },
}
-- i refuse to lower my softcoding standarts
package.loaded["src/engine/warps"] = nil
local warps = require("src/engine/warps")
if warps then
    local loadedWarps = warps:loadWarps()
    for warpName,warpValue in pairs(loadedWarps) do
        Kristal.warp_bin_codes[warpName] = warpValue
        -- a b c d e f g h i j
    end
end
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
Kristal.warp_bin_codes["GRAYAREA"] = gray_area_info
Kristal.warp_bin_codes["GREYAREA"] = gray_area_info

--Sonic CD-inspired secret screens
local song = Music()
local message
local function createSonicCDMessage(sprite_id, music_id, scale)
    message = Sprite(sprite_id)
    message.x, message.y = 0, 0
	if scale ~= nil then
        message:setScale(scale)
	else
	    message:setScale(2)
	end
    message:setLayer(WORLD_LAYERS["above_ui"] - 1)
    message:setParallax(0, 0)
    Game.world:addChild(message)
	
	if music_id ~= nil then
	    song:play(music_id)
    end 
end 
local sonic_cd_message = {
    result = function(cutscene)
        Assets.playSound("special_warp")
        cutscene:fadeOut(0.5, { color = { 1, 1, 1}, music = true })
        cutscene:wait(1)
		if Kristal.warp_bin_codes["461225"] then
		    createSonicCDMessage("misc/fun_is_infinite", "sonic_cd_boss")
		end
        cutscene:fadeIn(0.5, { music = false, wait = true })
		cutscene:wait(function () return Input.pressed("confirm") end)
        cutscene:fadeOut(0.5, { wait = true })
        cutscene:wait(1)
		song:stop()
		song:remove()
		message:remove()
        cutscene:fadeIn(0.5, { music = true, wait = true })
    end,
    instant = true
}
Kristal.warp_bin_codes["461225"] = sonic_cd_message

-- heres some new totally cool helper functions wowee

--- get a Bin Code's info
---@param code WarpBinCode
---@return WarpBinCodeInfo info
function Kristal:getBinCode(code)
    code = code:upper()
    for id, mod in  pairs(Kristal.Mods.data) do
        if mod.dlc and mod.dlc.extraBinCodes and mod.dlc.extraBinCodes[code] then
            local info = mod.dlc.extraBinCodes[code]
            if info == true then
                return {
                    result = mod.map,
                    mod = id,
                }
            else
                if type(info) == "string" then
                    info = {result = info}
                end
                info.mod = info.mod or id
            end
            return info
        end
    end

    return Kristal.warp_bin_codes[code]
end

-- if you were looking for addBinCode... just tamper with the table on your own

-- the actual logic is implemented in scripts/world/cutscenes/warp_bin.lua
