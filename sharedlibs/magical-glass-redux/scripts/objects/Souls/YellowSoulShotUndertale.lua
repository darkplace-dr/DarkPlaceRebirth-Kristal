local UndertaleShot, super = Class(Object)

function UndertaleShot:init(x, y, angle)
    super.init(self, x, y)
    
    if Game.battle.light then
        self.layer = LIGHT_BATTLE_LAYERS["below_soul"]
    else
        self.layer = BATTLE_LAYERS["below_soul"]
    end
    self.rotation = angle
    self:setOrigin(0.5, 0.5)
    self:setSprite("effects/yellowsoul/ut_shot")
    self:setHitbox(1, 1, 10, 9)

    self.physics = {
        speed = 16,
        direction = angle,
    }
    
    self.damage = 1
    self.hit_bullets = {}
end

function UndertaleShot:update()
    super.update(self)
    
    -- Speed and scale increases overtime
    self.physics.speed = self.physics.speed + DTMULT * 0.2
    self.scale_x = self.scale_x + DTMULT * 0.2
    
    local sx, sy = self:localToScreenPos()
    if (sx >  SCREEN_WIDTH)
    or (sx <             0)
    or (sy > SCREEN_HEIGHT)
    or (sy <             0)
    then
        self:remove()
    end

    local bullets = TableUtils.filter(Game.stage:getObjects(Bullet), function(v)
        if self.hit_bullets[v] then return false end
        return true
    end)
    
    Object.startCache()
    for _, bullet in ipairs(bullets) do
        if self:collidesWith(bullet) then
            self.hit_bullets[bullet] = true
            local result, result_big = bullet:onYellowShot(self, self.damage)
            local real_result
            if self.big then
                real_result = result_big
            else
                real_result = result
            end
            if real_result then
                if type(real_result) == "string" then
                    self:destroy(real_result)
                else
                    self:remove()
                end
                break
            end
        end
    end
    Object.endCache()
end

function UndertaleShot:draw()
    super.draw(self)
    
    if DEBUG_RENDER then
        self.collider:draw(1 ,0 ,0)
    end
end

function UndertaleShot:setSprite(sprite)
    if self.sprite then
        self.sprite:remove()
    end
    self.sprite = Sprite(sprite, 0, 0)
    self:addChild(self.sprite)
    self:setSize(self.sprite:getSize())
end

function UndertaleShot:destroy(anim)
    anim = anim or nil
    if anim ~= nil then
        if string.len(anim) == 1 then
            anim = "player/shot/hit/"..anim
        end
        local sprite = Sprite(anim, self.x + self.width, self.y)
        sprite:setOrigin(0.5, 0.5)
        if Game.battle.light then
            sprite.layer = LIGHT_BATTLE_LAYERS["above_bullets"]
        else
            sprite.layer = BATTLE_LAYERS["above_bullets"]
        end
        sprite:play(0.1, false, function()
            sprite:remove()
        end)
        Game.battle:addChild(sprite)
    end
    self:remove()
end

return UndertaleShot