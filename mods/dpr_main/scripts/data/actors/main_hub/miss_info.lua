local actor, super = Class(Actor, "miss_info")

function actor:onSpriteDraw(sprite)

    if not sprite.arm then

        sprite.arm = Sprite("world/npcs/miss_info/arm_1")
        sprite:addChild(sprite.arm)
        sprite.arm:setOrigin(0.8, 0.5)

        sprite.arm.x, sprite.arm.y = 14, 32

        sprite.info = Sprite("world/npcs/miss_info/miss_info")
        sprite:addChild(sprite.info)

--Game.world:spawnNPC("miss_info", 500, 350)
        --sprite:addFX(OutlineFX({1, 1, 1}))
    else
        local spx = math.sin(love.timer.getTime() * 2) * 1.5
        if spx < 0 then spx = spx*-1 end
        sprite.arm.rotation = spx
        
        sprite.info.x, sprite.info.y = math.random(-1, 1)/2, math.random(-1, 1)/2
        if spx > 1.1 and not sprite.swapped then
            local bex = math.random(1, 9)
            --sprite.arm:setSprite("world/npcs/miss_info/arm_"..bex)
            if bex == 2 then
                sprite.arm:setScale(0.5) 
            else
                sprite.arm:setScale(1) 
                bex = 1
            end
            sprite.arm:setSprite("world/npcs/miss_info/arm_"..bex)
            sprite.swapped = true
        elseif spx < 1.1 then
           sprite.swapped = nil
        end
    end

end

function actor:onTextSound(node)
    --[[if self.snd then
        self.snd:stop()
        self.snd = nil
    end]]
    local ply = 1
    if self.last_spoke and self.last_spoke + 0.5 < Game.playtime then
        ply = 2
    elseif not self.last_spoke then
        ply = 2
    end
    self.last_spoke = Game.playtime

    Assets.playSound("voice/miss_info/miss_info_".. ply, 0.4, 1)
    --self.snd = 
    return true
end

function actor:init()
    super.init(self)
    self.name = "Miss Info"

    self.width = 19
    self.height = 37

    self.hitbox = {0, 25, 19, 14}

    self.soul_offset = {10, 24}

    self.path = "world/npcs/miss_info"

    self.default = "miss_info"

    self.voice = "miss_info"
    self.portrait_path = nil
    self.portrait_offset = nil
    self.can_blush = false

    self.animations = {
    }
    self.mirror_sprites = {
    }

    self.offsets = {
    }
end

return actor