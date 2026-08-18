---@class OverworldSoul : OverworldSoul
local OverworldSoul, super = HookSystem.hookScript(OverworldSoul)

function OverworldSoul:init(x, y)
    super.init(self, x, y)

    self.sprite:setSprite("player/" .. Game:getSoulPartyMember():getSoulFacing() .. "/heart_dodge")

    self.graze_tp_factor   = 1
    self.graze_size_factor = 1
    for _, party in ipairs(Game.party) do
        self.graze_tp_factor   = math.min(3, self.graze_tp_factor + party:getStat("graze_tp"))
        self.graze_size_factor = math.min(3, self.graze_size_factor + party:getStat("graze_size"))
    end

    self.graze_sprite = GrazeSprite()
    self.graze_sprite:setOrigin(0.5, 0.5)
    self.graze_sprite.inherit_color = true
    self.graze_sprite.graze_scale = self.graze_size_factor
    self:addChild(self.graze_sprite)

    self.graze_collider = CircleCollider(self, 0, 0, 25 * self.graze_size_factor)

    -- Diamond shield variables start here
    self.glow_alpha = 0
    self.glow_alpha_increase = 0.1
    -- Diamond shield variables end here
end

function OverworldSoul:onGraze(bullet, old_graze) end

function OverworldSoul:updateGrazeFactors()
    self.graze_tp_factor   = 1
    self.graze_size_factor = 1
    for _, party in ipairs(Game.party) do
        self.graze_tp_factor   = math.min(3, self.graze_tp_factor + party:getStat("graze_tp"))
        self.graze_size_factor = math.min(3, self.graze_size_factor + party:getStat("graze_size"))
    end

    self.graze_sprite.graze_scale = self.graze_size_factor

    self.graze_collider = CircleCollider(self, 0, 0, 25 * self.graze_size_factor)
end

function OverworldSoul:update()
    self.sprite.alpha = 1 -- ??????

    -- Bullet collision !!! Yay
    if not Game.world.player or Game.world.player.state ~= "CLIMB" then
        local collided_bullets = {}
        Object.startCache()
        for _, bullet in ipairs(Game.stage:getObjects(WorldBullet)) do
            if bullet:meetsCollider(self.collider) then
                table.insert(collided_bullets, bullet)
            end
            if not Game:hasInvulnerability() and Game:getFlag("overworld_grazing", false) and Game.world:inBattle() then
                if bullet:canGraze() and bullet:meetsCollider(self.graze_collider) then
                    local old_graze = bullet.grazed
                    if bullet.grazed then
                        if Game:getFlag("tension_storage", false) then
                            Game:giveTension(bullet:getGrazeTension() * DT * self.graze_tp_factor)
                        end
                        if self.graze_sprite.timer < 0.1 then
                            self.graze_sprite.timer = 0.1
                        end
                        bullet:onGraze(false)
                    else
                        Assets.playSound("graze")
                        if Game:getFlag("tension_storage", false) then
                            Game:giveTension(bullet:getGrazeTension() * self.graze_tp_factor)
                        end
                        self.graze_sprite.timer = 1 / 3
                        bullet.grazed = true
                        bullet:onGraze(true)
                    end
                    self:onGraze(bullet, old_graze)
                end
            end
        end
        Object.endCache()
        for _, bullet in ipairs(collided_bullets) do
            self:onCollide(bullet)
        end
    end

    if Game.inv_frames > 0 then
        self.inv_flash_timer = self.inv_flash_timer + DT
        local amt = math.floor(self.inv_flash_timer / (4 / 30))
        if (amt % 2) == 1 then
            self.sprite:setColor(0.5, 0.5, 0.5)
        else
            self.sprite:setColor(1, 1, 1)
        end
    else
        self.inv_flash_timer = 0
        self.sprite:setColor(1, 1, 1)
    end

    local progress = 0

    if Game.world.player then
        self.x, self.y = Game.world.player:getRelativePos(Game.world.player:getSoulOffset())
        if Game.world.player.battle_alpha > 0 then
            progress = Game.world.player.battle_alpha * 2
        end
    end

    self.alpha = MathUtils.clamp(progress, 0, 1)

    -- Diamond shield code starts here
    if not Game:hasInvulnerability() and Game.pp > 0 and Game.world.battle_alpha > 0 then
        self.glow_alpha = self.glow_alpha + self.glow_alpha_increase * DTMULT
        if self.glow_alpha >= 1 then
            self.glow_alpha = 1
            self.glow_alpha_increase = -self.glow_alpha_increase
        end
        if self.glow_alpha <= 0 then
            self.glow_alpha = 0
            self.glow_alpha_increase = -self.glow_alpha_increase
        end
    else
        self.glow_alpha = 0
        self.glow_alpha_increase = math.abs(self.glow_alpha_increase)
    end
    -- Diamond shield code ends here

    super.super.update(self)
end

function OverworldSoul:draw()
    super.draw(self)

    local glow_w, glow_h = self.sprite:getTexture():getWidth(), self.sprite:getTexture():getHeight()
    local scale_x, scale_y = self.sprite.scale_x, self.sprite.scale_y
    love.graphics.setColor(1, 1, 1, self.glow_alpha * Game.world.battle_alpha)
    love.graphics.draw(self.sprite:getTexture(), -glow_w / 2 * scale_x, -glow_h / 2 * scale_y, 0, scale_x, scale_y)
    love.graphics.setColor(1, 1, 1, 1)
end

return OverworldSoul