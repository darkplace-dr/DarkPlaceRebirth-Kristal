---@class World : World
local World, super = HookSystem.hookScript(World)

-- The MB easter egg won't happen when entering any DLCs or maps in this list
-- The list only needs to find the given string in the id so you don't have to add every single map to the list
-- Especially if they're all in a folder, as the folder name appears in the id
-- 
-- But hey, I'd be cool if this list could stay as short as possible, especially the DLC one :D
World.mb_blacklist = {
    dlcs = {},
    maps = {
        "conversion_rooms",
        "nothing",
        "grey_cliffside/dead_room1_start",
        "fwood"
    },
}

function World:canMb(map)
    if (Kristal.DebugSystem:isMenuOpen() or Game:getFlag("s", false) or (self:hasCutscene() or Game.battle)) then
        return false
    end
    -- Something important might be loading if Mod or Game.world.map is nil, let's not interrupt it
    if not Mod or not self.map then
        return false
    end
    for obj,list in pairs(self.mb_blacklist) do
        for _,id in ipairs(list) do
            if obj == "dlcs" and (Mod and Mod.info and Mod.info.id) then
                if Mod.info.id == id then
                    return false
                end
            elseif obj == "maps" then
                if isClass(map) and map:includes(Map) then
                    if map.id:find(id) then
                        return false
                    end
                elseif type(map) == "string" then
                    if map:find(id) then
                        return false
                    end
                end
            end
        end
    end
    return true
end

function World:shouldMb(map)
    if not self:canMb(map) then return false end
    local chance
    if DP:shouldWeIncreaseTheRateAtWhichYouGainNightmaresOrNot() then
        chance = love.math.random(1, 10) == 6
    else
        chance = love.math.random(1, 1000) == 666
    end
    return chance
end

function World:loadMap(...)
    if self.map and self.map.id then
        Game:setFlag("PREVMAP", self.map.id)
    end
    super.loadMap(self, ...)
end

function World:transitionMusic(next, fade_out)
    local music = ""
    local volume = 1
    local pitch = 1
    if type(next) == "table" then
        music = next[1]
        volume = next[2]
        pitch = next[3]
    else
        music = next
    end
    --
    if music and music ~= "" then
        if self.music.current ~= music then
            if self.music:isPlaying() and fade_out then
                self.music:fade(0, 10 / 30, function() self.music:stop() end)
            elseif not fade_out then
				if not Assets.getMusicPath(music) then
					if not music then
						Kristal.Console:warn("Music not found: \"" .. music .. "\"")
						return
					end
					self.music:playFile(music, volume, pitch)
				else
					self.music:play(music, volume, pitch)
				end
            end
        else
            if not self.music:isPlaying() then
                if not fade_out then
					if not Assets.getMusicPath(music) then
						if not music then
							Kristal.Console:warn("Music not found: \"" .. music .. "\"")
							return
						end
						self.music:playFile(music, volume, pitch)
					else
						self.music:play(music, volume, pitch)
					end
                end
            else
                self.music:fade(volume)
            end
        end
    else
        if self.music:isPlaying() then
            if fade_out then
                self.music:fade(0, 10 / 30, function() self.music:stop() end)
            else
                self.music:stop()
            end
        end
    end
end

function World:breakSoulShield()
    Assets.playSound("mirrorbreak")
    local expand_effect = Sprite(self.soul.sprite:getTexture(), 0, 0)
    expand_effect:setOrigin(self.soul.sprite.origin_x, self.soul.sprite.origin_y)
    expand_effect.graphics.grow = 0.1
    expand_effect.graphics.fade = 0.05
    expand_effect.graphics.fade_callback = function() expand_effect:remove() end
    self.soul:addChild(expand_effect)
    for i = 1, 5 do
        local shard = HeartEffectShard(self.soul.x, self.soul.y)
        shard.layer = self.soul.layer - 1
        self:addChild(shard)
    end
end

return World
