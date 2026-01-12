---@class Soul : Soul
local Soul, super = HookSystem.hookScript(Soul)

function Soul:init(x,y,color)

    super.init(self, x, y, color)

    self.outline = Sprite("player/heart_invert") -- Creating this first so sprite_focus will be on top of it
    self.outline:setOrigin(0.5, 0.5)
    self.outline.alpha = 0
    self.outline.color = {0, 1, 1}
    self.outline.debug_select = false
    self:addChild(self.outline)

    self.sprite_focus = Sprite("player/heart_dodge_focus")
    self.sprite_focus:setOrigin(0.5, 0.5)
    self.sprite_focus.inherit_color = false
    self.sprite_focus.alpha = 0
    self.sprite_focus.debug_select = false
    self:addChild(self.sprite_focus)

    -- Taunt/parry variables start here
    self.force_taunt = nil -- Forces taunting in battle on or off, regardless of if the PizzaToque is equipped.

    self.parry_timer = 0
    self.cooldown_timer = 0
    self.parry_inv = 0
    self.taunt_timer = 0

    -- hi -sam
    self.parry_lock_movement = 0

    if Game:isSpecialMode "PEPPINO" then
        self.parry_sfx = Assets.getSound("sugarcoat")
    else
        self.parry_sfx = Assets.getSound("taunt")
    end
    self.parried_sfx = Assets.getSound("parry")
    self.parried_loop_sfx = nil

    -- Making sure it only parries once per Z press.
    self.did_parry = false

    self.taunt_length = 10

    -- Customizable stuff. Timing is in frames at 30 FPS.
    self.can_parry = true       -- Determines if you can parry at all.
    self.parry_window = 5       -- How large of a window you have to parry a bullet.
    self.parry_length = 30      -- Invincibility length after a successful parry.
    self.parry_cap = 60         -- Maximum duration for parry invincibility, in the event that multiple bullets are parried in quick succession.
    self.cooldown = 30          -- Recovery time between one parry and the next, assuming the first one failed.
    self.special_only = false   -- If set to true, only bullets with the variable "self.special_parry" set to true can be parried.

    -- Taunt variables end here
end

function Soul:onAddToStage()
    if Game.pp > 0 then
        self:addChild(SoulGlowEffect())
    end
end

function Soul:onRemove(parent)
    super.onRemove(self, parent)

    -- Taunt
    if self.parried_loop_sfx then
        self.parried_loop_sfx:stop()
        self.parried_loop_sfx = nil
    end
end

function Soul:onCollide(bullet)
    if self:isParrying() and not self.did_parry and ((self.special_only and bullet.special_parry) or (not self.special_only)) then

        local burst = HeartBurst(-9, -9, {Game.battle.encounter:getSoulColor()})
        self:addChild(burst)

        self.physics.direction = (Utils.angle(self.x, self.y, bullet:getRelativePos(bullet.collider.width / 2, bullet.collider.height/2))) - math.pi
        self.physics.speed = 3.3
        self.physics.friction = 0.4

        self.parried_sfx:stop()
        self.parried_sfx:play()
        self.parry_inv = self.parry_inv + self.parry_length
        if self.parry_inv > self.parry_cap then
            self.parry_inv = self.parry_cap
        end
        self.did_parry = true
        self.cooldown_timer = 0             -- You can chain parries as long as you keep timing them.

    end
    if bullet.damage then
        --[[if Game.battle.phasearmor >= 1 then
            local burst = HeartBurst(-9, -9, {Game.battle.encounter:getSoulColor()})
            self:addChild(burst)
            Assets.stopAndPlaySound("celestial_hit")
            -- Also I have no idea how to make the bullet not do any damage
            Game.battle.phasearmor = Game.battle.phasearmor - 1
            if Game.battle.phasearmor <= 0 then
                self:removeFX("phaseoutline")
                self.phaseoutline = false
            end
        elseif bullet.damage ~= 0 then
            bullet.parrydmg_old = bullet.damage
        end]]
        if bullet.damage ~= 0 then bullet.parrydmg_old = bullet.damage end
    end
    if self.parry_inv > 0 then
        bullet.damage = 0
    else
        if bullet.parrydmg_old then
            bullet.damage = bullet.parrydmg_old
        else
            bullet.damage = bullet:getDamage()
        end
    end

    -- Handles damage
    super.onCollide(self, bullet)
end


-- Why is this not a default function?
function Soul:flash(sprite)
    local sprite_to_use = sprite or self.sprite
    local flash = FlashFade(sprite_to_use.texture, -10, -10)
    flash.flash_speed = 1.5
    flash.layer = 100
    self:addChild(flash)
    return flash
end

function Soul:canParry()
    -- Conditions for parrying:
    -- Not already parrying
    -- Cooldown is over
    -- Parrying is enabled
    -- Not in the middle of damage i-frames
    if self.parry_timer == 0 and self.cooldown_timer == 0 and self.can_parry == true and self.inv_timer == 0 then
        return true
    else
        return false
    end
end

function Soul:isParrying()
    if self.can_parry and (self.parry_timer > 0) then
        return true
    else
        return false
    end
end

function Soul:update()
    super.update(self)

    ---@diagnostic disable-next-line: undefined-field
	if Input.down("cancel") and not self.blue then -- Reduced hitbox size can get you stuck in collision with the blue soul, so it can't use this.
		self.collider.radius = 4
		self.sprite_focus.alpha = 1
	else
		self.collider.radius = 8
		self.sprite_focus.alpha = 0
	end
	
    local focus_equipped = false
    for _,party in ipairs(Game.party) do
        if party:checkArmor("focus") then focus_equipped = true end
    end
	
	-- Taunt code starts here
	if self.force_taunt ~= false then
	if Game:isTauntingAvaliable() or self.force_taunt == true then
	if self.transitioning then
        if self.parried_loop_sfx then
            self.parried_loop_sfx:stop()
            self.parried_loop_sfx = nil
        end
        return
    end
    
    self.can_move = true
    if self.parry_lock_movement > 0 then
        self.parry_lock_movement = self.parry_lock_movement - DTMULT
        self.can_move = false
    end

    if self.parry_inv == 0 and self.did_parry then
        self.did_parry = false
    end
    --
    if not self.parried_loop_sfx then
        self.parried_loop_sfx = Assets.getSound("chargeshot_charge")
        self.parried_loop_sfx:setLooping(true)
        self.parried_loop_sfx:setPitch(0.1)
        self.parried_loop_sfx:setVolume(0)
        self.parried_loop_sfx:play()
    end

    self.parried_loop_sfx:setPitch( Utils.clampMap(self.parry_inv, 0, self.parry_length / 2, 0.1, 1))
    self.parried_loop_sfx:setVolume(Utils.clampMap(self.parry_inv, 0, self.parry_length / 4, 0,   0.5))
    --]]

    if Input.pressed("taunt", false) and self:canParry() then
        self.parry_lock_movement = 8

        self:flash()
        self.parry_sfx:stop()
        self.parry_sfx:play()

        for _,chara in pairs(Game.battle.stage:getObjects(PartyBattler)) do
            if not chara.actor or chara.is_down then goto continue end

            -- workaround due of actors being loaded first by registry
            local sprites = chara.actor.getTauntSprites and chara.actor:getTauntSprites() or chara.actor.taunt_sprites
            if not sprites or #sprites <= 0 then goto continue end

            chara:toggleOverlay(true)
            chara.overlay_sprite:setSprite(Utils.pick(sprites))

            -- the shine effect
            local effect = Sprite("effects/taunt", 10, 15)
            effect:setOrigin(0.5)
            effect:setScale(0.5)
            effect.layer = -1
            effect:play(1/30, false, function()
                effect:remove()
                chara:toggleOverlay(false)
            end)
            chara:addChild(effect)

            ::continue::
        end

        self.parry_timer = self.parry_window
        self.cooldown_timer = self.cooldown
        self.did_parry = false
        self.once = false
    end

    if self.parry_timer > 0 then self.parry_timer = Utils.approach(self.parry_timer, 0, DTMULT) end
    if self.cooldown_timer > 0 then self.cooldown_timer = Utils.approach(self.cooldown_timer, 0, DTMULT) end
    if self.parry_inv > 0 then self.parry_inv = Utils.approach(self.parry_inv, 0, DTMULT) end
	end
	end
	-- Taunt code ends here
end

function Soul:setFacing(face)
    if self.sprite then
        if face then
            self.sprite:setSprite("player/"..face.."/heart_dodge")
        else
            self.sprite:setSprite("player/heart_dodge")
        end
    end
    if self.graze_sprite then
        if face then
            self.graze_sprite.texture = Assets.getTexture("player/"..face.."/graze")
        else
            self.graze_sprite.texture = Assets.getTexture("player/graze")
        end
    end
end

-- Why the hell is this not in getDrawColor???????
function Soul:draw()
    local r,g,b,a = self:getDrawColor()
    local heart_texture = Assets.getTexture(self.sprite.texture_path)
    local heart_w, heart_h = heart_texture:getDimensions()

    local charge_timer = self.parry_inv
    if charge_timer > 0 then
        local scale = math.abs(math.sin(charge_timer / 10)) + 1
        love.graphics.setColor(r,g,b,a*0.3)
        love.graphics.draw(heart_texture, -heart_w/2 * scale, -heart_h/2 * scale, 0, scale)

        scale = math.abs(math.sin(charge_timer / 14)) + 1.2
        love.graphics.setColor(r,g,b,a*0.3)
        love.graphics.draw(heart_texture, -heart_w/2 * scale, -heart_h/2 * scale, 0, scale)
    end

    -- Soul brightens when invincible
    if charge_timer > 0 then
        ---@diagnostic disable-next-line: param-type-mismatch
        self.color = Utils.clampMap(self.parry_inv, 0, self.parry_cap / 2, {r,g,b},{1,1,1})
    end

    -- Soul darkens when on cooldown
    if self.cooldown_timer > 0 then
        ---@diagnostic disable-next-line: param-type-mismatch
        self.color = Utils.clampMap(self.cooldown_timer, 0, self.cooldown / 2, {r,g,b},{(r * 0.5),(g * 0.5),(b * 0.5)})
    end

    super.draw(self)
	
    self.color = {r,g,b}

    if DEBUG_RENDER then
        self.collider:draw(0, 1, 0)
        self.graze_collider:draw(1, 1, 1, 0.33)
    end
end

return Soul