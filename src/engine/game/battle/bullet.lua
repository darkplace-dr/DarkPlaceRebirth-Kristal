--- The class that all Battle bullets in Kristal originate from. \
--- Generic bullets can be spawned into a wave with `Wave:spawnBullet(texture, x, y)` \
--- Files in `scripts/battle/bullets` will also be loaded as bullets and should Extend this class. 
--- Extension bullets can be spawned into a wave with `Wave:spawnBullet(id, ...)` - their `id` defaults to their filepath, starting from `scripts/battle/bullets`. Additional arguments `...` are passed into the bullet type's init function.
---
---@class Bullet : Object
---@overload fun(...) : Bullet
---
---@field attacker          EnemyBattler    The attacker that owns the wave which created this bullet. Not defined until after `Bullet:init()`.
---@field wave              Wave            The wave that this bullet was created by. Not defined until after `Bullet:init()`.
---
---@field collider          Collider|nil
---
---@field tp                number
---@field time_bonus        number
---
---@field damage            number
---@field inv_timer         number
---@field destroy_on_hit    boolean
---
---@field grazed            boolean
---
---@field remove_offscreen  boolean
---
local Bullet, super = Class(Object)

---@param x         number
---@param y         number
---@param texture?  string|love.Image
function Bullet:init(x, y, texture)
    super.init(self, x, y)

    self.layer = BATTLE_LAYERS["bullets"]

    -- Set scale and origin
    self:setOrigin(0.5, 0.5)
    self:setScale(2, 2)

    -- Add a sprite, if we provide one
    if texture then
        self:setSprite(texture, 0.25, true)
    end

    -- Default collider to half this object's size
    self.collider = Hitbox(self, self.width/4, self.height/4, self.width/2, self.height/2)

    -- TP added when you graze this bullet (Also given each frame after the first graze, 30x less at 30FPS)
    self.tp = 1.6 -- (1/10 of a defend, or cheap spell)
    -- Turn time reduced when you graze this bullet (Also applied each frame after the first graze, 30x less at 30FPS)
    self.time_bonus = 1

    -- Damage given to the player when hit by this bullet (Defaults to 5x the attacker's attack stat)
    self.damage = nil
    -- Invulnerability timer to apply to the player when hit by this bullet (Defaults to 4/3 seconds)
    self.inv_timer = (4/3)
    -- Whether this bullet gets removed on collision with the player (Defaults to `true`)
    self.destroy_on_hit = true

    -- Whether this bullet has already been grazed (reduces graze rewards)
    self.grazed = false

    -- Whether to remove this bullet when it goes offscreen (Defaults to `true`)
    self.remove_offscreen = true

    self.pierce = false
    
    -- Max HP damage given to the player when hit by this bullet (Defaults to 0, meaning it won't deal any MHP damage.)
    self.mhp_damage = 0
    -- If this bullet deals MHP damage, should it have a glowing red appearance? (Defaults to `true`)
    self.mhp_glow_red = true
  
    self.mhp_red_siner = 0
end

---@return string
function Bullet:getTarget()
    return self.attacker and self.attacker.current_target or "ANY"
end

---@return number
function Bullet:getDamage()
    return self.damage or (self.attacker and self.attacker.attack * 5) or 0
end

---@return number
function Bullet:getMHPDamage()
    return self.mhp_damage or 0
end

--- *(Override)* Called when the bullet hits the player's soul without invulnerability frames. \
--- Not calling `super:onDamage()` here will stop the normal damage logic from occurring.
---@param soul Soul
---@return table<PartyBattler> battlers_hit
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
        if Game:getSoulPartyMember().pp > 0 then
            Game:getSoulPartyMember().pp = Game:getSoulPartyMember().pp - 1
            self:breakSoulShield()
        else
			if not self.pierce then
				local battlers = Game.battle:hurt(damage, false, self:getTarget())
				soul.inv_timer = self.inv_timer
				soul:onDamage(self, damage, false)
				return battlers
			end
			Game.battle:pierce(damage, false, self:getTarget())
        end
		soul.inv_timer = self.inv_timer
		soul:onDamage(self, damage, false)
    end
    return {}
end

function Bullet:breakSoulShield()
	Assets.playSound("mirrorbreak")
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

--- *(Override)* Called when the bullet collides with the player's soul, before invulnerability checks.
---@param soul Soul
function Bullet:onCollide(soul)
	if not Game.battle.superpower then
		if soul.inv_timer == 0 then
			self:onDamage(soul)
		end

		if self.destroy_on_hit then
			self:remove()
		end
	end
end

---@param wave Wave
function Bullet:onWaveSpawn(wave) end

---@param texture?      string|love.Image   The new texture or path to the texture to set on the sprite (Removes the bullet's sprite if undefined) 
---@param speed?        number              The time between frames of the sprite, in seconds (Defaults to 1/30th second)
---@param loop?         boolean             Whether the sprite should continuously loop. (Defaults to `true`)
---@param on_finished?  fun(Sprite)         A function that is called when the animation finishes.
---@return Sprite?
function Bullet:setSprite(texture, speed, loop, on_finished)
    if self.sprite then
        self:removeChild(self.sprite)
    end
    if texture then
        self.sprite = Sprite(texture)
        self.sprite.inherit_color = true
        self:addChild(self.sprite)

        if speed then
            self.sprite:play(speed, loop, on_finished)
        end

        self.width = self.sprite.width
        self.height = self.sprite.height

        return self.sprite
    end
end

--- Checks whether this bullet is an instance or extension of a specific bullet type, specified by `id`.
---@param id string
---@return boolean
function Bullet:isBullet(id)
    return self:includes(Registry.getBullet(id))
end

function Bullet:update()
    super.update(self)
	
    if self.mhp_glow_red == true and self.mhp_damage > 0 then
        self.mhp_red_siner = self.mhp_red_siner + DTMULT
        self:setColor(Utils.mergeColor({232/255, 45/255, 0/255}, COLORS.red, (0.25 + math.sin(self.mhp_red_siner / 3)) * 0.25))
    end

    if self.remove_offscreen then
        local size = self.width + self.height
        if self.x < -size or self.y < -size or self.x > SCREEN_WIDTH + size or self.y > SCREEN_HEIGHT + size then
            self:remove()
        end
    end
end

function Bullet:draw()
    super.draw(self)

    if DEBUG_RENDER and self.collider then
        self.collider:drawFor(self, 1, 0, 0)
    end
end

return Bullet