---@class Bullet : Bullet
local Bullet, super = Utils.hookScript(Bullet)

function Bullet:init(x,y,texture)
    super.init(self, x, y, texture)

    self.pierce = false
    
    -- Max HP damage given to the player when hit by this bullet (Defaults to 0, meaning it won't deal any MHP damage.)
    self.mhp_damage = 0
    -- If this bullet deals MHP damage, should it have a glowing red appearance? (Defaults to `true`)
    self.mhp_glow_red = true

    self.mhp_red_siner = 0
end

function Bullet:breakSoulShield()
    Assets.playSound("mirrorbreak")
    local souleffect = Sprite("player/heart_dodge")
    souleffect:setOrigin(0.5, 0.5)
    souleffect.layer = Game.battle.soul.layer + 1
    souleffect:setParent(Game.battle.soul)
    souleffect.graphics.grow = 0.1
    souleffect.alpha = 0.5
    souleffect:fadeOutAndRemove(0.5)
    local shard_x_table = {-2, 0, 2, 8, 10, 12}
    local shard_y_table = {0, 3, 6}
    Game.battle.soul.shards = {}
    for i = 1, 6 do
        local x_pos = shard_x_table[((i - 1) % #shard_x_table) + 1]
        local y_pos = shard_y_table[((i - 1) % #shard_y_table) + 1]
        local shard = Sprite("player/heart_shard", Game.battle.soul.x + x_pos, Game.battle.soul.y + y_pos)
        shard.physics.direction = math.rad(Utils.random(360))
        shard.physics.speed = 7
        shard.physics.gravity = 0.2
        shard.layer = Game.battle.soul.layer
        shard:play(5/30)
        table.insert(Game.battle.soul.shards, shard)
        Game.battle.soul.stage:addChild(shard)
    end
end

function Bullet:onDamage(soul)
    local damage = self:getDamage()
    local mhp_dmg = self:getMHPDamage()
    if mhp_dmg > 0 then
        if Game:getSoulPartyMember().pp > 0 then
            Game:getSoulPartyMember().pp = Game:getSoulPartyMember().pp - 1
            self:breakSoulShield()
        else
            if not self.pierce then
                local battlers = Game.battle:mhp_hurt(mhp_dmg, false, self:getTarget())
                soul.inv_timer = self.inv_timer
                soul:onDamage(self, mhp_dmg, true)
                return battlers
            end
            Game.battle:mhp_pierce(mhp_dmg, false, self:getTarget())
        end
        soul.inv_timer = self.inv_timer
        soul:onDamage(self, mhp_dmg, true)
    end
    if damage > 0 then
        super.onDamage(self, soul)
    end
    return {}
end

function Bullet:breakSoulShield()
    Assets.playSound("mirrorbreak")
    local souleffect = Sprite("player/heart_dodge")
    souleffect:setOrigin(0.5, 0.5)
    souleffect.layer = Game.battle.soul.layer + 1
    souleffect:setParent(Game.battle.soul)
    souleffect.graphics.grow = 0.1
    souleffect.alpha = 0.5
    souleffect:fadeOutAndRemove(0.5)
    local shard_x_table = {-2, 0, 2, 8, 10, 12}
    local shard_y_table = {0, 3, 6}
    Game.battle.soul.shards = {}
    for i = 1, 6 do
        local x_pos = shard_x_table[((i - 1) % #shard_x_table) + 1]
        local y_pos = shard_y_table[((i - 1) % #shard_y_table) + 1]
        local shard = Sprite("player/heart_shard", Game.battle.soul.x + x_pos, Game.battle.soul.y + y_pos)
        shard.physics.direction = math.rad(Utils.random(360))
        shard.physics.speed = 7
        shard.physics.gravity = 0.2
        shard.layer = Game.battle.soul.layer
        shard:play(5/30)
        table.insert(Game.battle.soul.shards, shard)
        Game.battle.soul.stage:addChild(shard)
    end
end

function Bullet:onCollide(soul)
    if Game.battle.superpower then return end
    return super.onCollide(self, soul)
end
---@return number
function Bullet:getMHPDamage()
    return self.mhp_damage or 0
end


function Bullet:update()
    super.update(self)
    if self.mhp_glow_red == true and self.mhp_damage > 0 then
        self.mhp_red_siner = self.mhp_red_siner + DTMULT
        self:setColor(Utils.mergeColor({232/255, 45/255, 0/255}, COLORS.red, (0.25 + math.sin(self.mhp_red_siner / 3)) * 0.25))
    end
end

return Bullet