local actor, super = Class(Actor, "cat_cafe")

function actor:init()
    super.init(self)

    self.name = "cat_cafe"

    self.width = 60
    self.height = 80

    -- Hitbox for this actor in the overworld (optional, uses width and height by default)
    self.hitbox = {0, 0, 0, 0}

    -- Color for this actor used in outline areas (optional, defaults to red)
    self.color = {1, 0, 0}

    -- Whether this actor flips horizontally (optional, values are "right" or "left", indicating the flip direction)
    self.flip = nil

    -- Path to this actor's sprites (defaults to "")
    self.path = "world/maps/floor2/darkjam_26"
    -- This actor's default sprite or animation, relative to the path (defaults to "")
    self.default = "cat_cafe"

    -- Sound to play when this actor speaks (optional)
    self.voice = nil
    -- Path to this actor's portrait for dialogue (optional)
    self.portrait_path = nil
    -- Offset position for this actor's portrait (optional)
    self.portrait_offset = {0, 0}

    -- Whether this actor as a follower will blush when close to the player
    self.can_blush = false

    -- Table of talk sprites and their talk speeds (default 0.25)
    self.talk_sprites = {
    }

    -- Table of sprite animations
    self.animations = {
        ["cat_cafe"] = {"cat_cafe", 1, true},
    }

    -- Table of sprite offsets (indexed by sprite name)
    self.offsets = {
        ["takolyshit"] = {-5, -60}
    }

function self:onWorldDraw(chara)

    local r, g, b = Utils.hslToRgb(Kristal.getTime() / 4 % 1, 1, 0.5)

    Draw.setColor(r, g, b, 0.2)
    love.graphics.rectangle("fill", 14, 79, 32, 12)

    love.graphics.rectangle("fill", 14, 79, 32, 10)
    love.graphics.rectangle("fill", 14, 79, 32, 8)
    love.graphics.rectangle("fill", 14, 79, 32, 6)
    love.graphics.rectangle("fill", 14, 79, 32, 4)
    love.graphics.rectangle("fill", 14, 79, 32, 2)

end

end

function actor:onSpriteInit(sprite)

local map = Game.world.map

function map:onEnter()
    super.onEnter(self)
    if not self.ina then

        Game.world.map.ina = Music("caramelldansen", 0)
        if Game.world.caramell_constant then
            Game.world.map.ina:seek(Game.world.caramell_constant)
        end
        Game.world.map.ina.source:setFilter({type = "lowpass", volume = 1.0, highgain = 0.2})
    end
end

function map:onExit()
    super.onExit(self)
	map.ina:remove()
end
end


function actor:onWorldUpdate(chara)
    if chara.sprite.sprite ~= "takolyshit" and not (PauseLib and PauseLib.paused) then
        if Game.world.map.ina:isPlaying() then
            Game.world.caramell_constant = Game.world.map.ina:tell()
        end
        local dist = Utils.dist(chara.x+chara.width/2, chara.y+chara.height/2, Game.world.player.x+Game.world.player.width, Game.world.player.y+Game.world.player.height)
        local vol = Utils.clamp(Utils.clampMap(dist, 50, 150, 1, 0), 0, 1)
        Game.world.map.ina:setVolume(vol)
        if Game.world.map.ina.volume > 0 then
            Game.world.music:setVolume(1 - vol)
        else
            if Game.world.music:getVolume() < 1 then
                Game.world.music:setVolume(1)
            end
        end
    else
        if Game.world.map.ina:isPlaying() then
            Game.world.map.ina:pause()
        end
    end
end

return actor