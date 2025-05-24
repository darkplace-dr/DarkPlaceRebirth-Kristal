local actor, super = Class(Actor, "omegaspamton")

function actor:init()
    super.init(self)

    self.name = "Omega Spamton"

    self.width  = 612
    self.height = 590

    self.hitbox = {0, 612, 0, 612}

    self.color = {1, 0, 0}

    self.flip = nil
	
    self.path    = "battle/enemies/omegaspamton"
    self.default = "static"

    self.voice           = "spam_omega"
    self.portrait_path   = nil
    self.portrait_offset = nil

    self.can_blush = false

    self.talk_sprites = {}

    self.animations = {
        ["idle"] = {"idle", 0.25, true},
        ["hurt"] = {"hurt", 0.25, true},
        ["static"] = {"static", 0.25, true},
        ["laughing"] = {"laughing", 0.25, true},
    }

    self.offsets = {}
	
    self.disallow_replacement_texture = true
end

function actor:onSpriteInit(sprite)
    super.onSpriteInit(sprite)
	
    sprite:setScale(1)
	
    sprite.part        = {}
    sprite.partx       = {}
	sprite.party       = {}
	sprite.partrot     = {}
    sprite.partorigins = {}
    sprite.partxoff    = {}
    sprite.partyoff    = {}
    sprite.partsiner   = {}
    sprite.partspeed   = {}
    sprite.partblend = {}
    sprite.partvisible = {}
    sprite.partshadow = true
    sprite.shadowtimer = 0
	
    sprite.resetsiner = false
    sprite.laughtimer = 0

	--sprites	
    sprite.part[1] = "battle/enemies/omegaspamton/wing_l"
    sprite.part[2] = "battle/enemies/omegaspamton/torso"
    sprite.part[3] = "battle/enemies/omegaspamton/jaw"
    sprite.part[4] = "battle/enemies/omegaspamton/head"
    sprite.part[5] = "battle/enemies/omegaspamton/arm"
    sprite.part[6] = "battle/enemies/omegaspamton/wing_r"
	
	--origins
    sprite.partorigins[1] = {180,260}
    sprite.partorigins[2] = {150,370}
    sprite.partorigins[3] = {150,205}
    sprite.partorigins[4] = {150,205}
    sprite.partorigins[5] = {235,280}
    sprite.partorigins[6] = {195,260}
	
	--misc. variables
    for i = 1, 6 do
        sprite.partsiner[i]   = 0
        sprite.partspeed[i]   = 0
        sprite.partx[i]       = 0
        sprite.party[i]       = 0
        sprite.partxoff[i]    = sprite.partorigins[i][1] * sprite.scale_x
        sprite.partyoff[i]    = sprite.partorigins[i][2] * sprite.scale_y
        sprite.partrot[i]     = 0
        sprite.partblend[i]   = COLORS.white
        sprite.partvisible[i] = true
    end
end

function actor:onSpriteDraw(sprite)
    super.onSpriteDraw(sprite)
	
    for i = 1, 6 do
        if sprite.resetsiner then
            sprite.partsiner[i] = 0
        end
	
        if sprite.anim == "idle" then   -- idle animation
            sprite.resetsiner = true
			
            if i == 2 or i == 3 or i == 4 then
                sprite.partrot[i] = Utils.lerp(math.rad(0), 0, (0.25 * 2))
                sprite.partx[i]   = Utils.lerp(sprite.partx[i], 0, (0.25 * 2))
                if i == 3 then
                    sprite.partsiner[i] = sprite.partsiner[i] + DTMULT
                    sprite.party[i]     = sprite.party[i] + (math.sin((sprite.partsiner[i] / 15)) * 1.5) * DTMULT
                elseif i == 4 then
                    sprite.partsiner[i] = sprite.partsiner[i] + DTMULT
                    sprite.party[i]     = sprite.party[i] + (math.sin((sprite.partsiner[i] / 15))) * DTMULT
                elseif i == 2 then
                    sprite.partsiner[i] = sprite.partsiner[i] + ((1 + (i / 5)) * 2) * DTMULT
                    sprite.party[i]     = sprite.party[i] + (math.sin((sprite.partsiner[i] / 15))) * DTMULT
                end
            else
                sprite.partsiner[i] = sprite.partsiner[i] + ((1 + (i / 5)) * 2) * DTMULT
                sprite.partrot[i]   = math.rad(math.sin((sprite.partsiner[i] / 120)) * 15)
                sprite.partx[i]     = Utils.lerp(sprite.partx[i], 0, (0.25 * 2))
                sprite.party[i]     = Utils.lerp(sprite.party[i], 0, (0.25 * 2))
            end
        else
            sprite.resetsiner = false
        end

        if sprite.anim == "static" then -- static animation (parts snap to default rotation)
            sprite.resetsiner = true
			
            if sprite.partshadow then
                sprite.shadowtimer  = 0
                sprite.partblend[i] = COLORS.black
            else
                sprite.shadowtimer  = sprite.shadowtimer + 0.1 * DTMULT
                sprite.partblend[i] = Utils.mergeColor(COLORS.black, COLORS.white, sprite.shadowtimer/30)
            end

            sprite.partsiner[i] = 0
            sprite.partrot[i]   = Utils.lerp(sprite.partrot[i], 0, (0.25 * 2))
            sprite.partx[i]     = Utils.lerp(sprite.partx[i], 0, (0.25 * 2))
            sprite.party[i]     = Utils.lerp(sprite.party[i], 0, (0.25 * 2))
        else
            sprite.resetsiner = false
        end
		
        if sprite.anim == "hurt" then   -- hurt animation
            sprite.resetsiner = true
			
            if i == 4 then
                sprite.partsiner[i] = sprite.partsiner[i] + DTMULT
                sprite.partrot[i]   = Utils.lerp(math.rad(60 - Utils.random(6)), 0, (0.25 * 2))
                sprite.partx[i]     = math.sin(((sprite.partsiner[i] / 2) * 2))
                sprite.party[i]     = math.cos(((sprite.partsiner[i] / 2) * 2))
            elseif i == 3 then
                sprite.partsiner[i] = sprite.partsiner[i] + DTMULT
                sprite.partrot[i]   = Utils.lerp(math.rad(-10 - Utils.random(6)), 0, (0.25 * 2))
                sprite.partx[i]     = math.sin(((sprite.partsiner[i] / 2) * 2))
                sprite.party[i]     = math.cos(((sprite.partsiner[i] / 2) * 2))
            elseif i == 2 then
                sprite.partsiner[i] = sprite.partsiner[i] + ((1 + (i / 5)) * 2) * DTMULT
                sprite.partrot[i]   = math.rad(sprite.partrot[i] - Utils.random(6))
                sprite.partx[i]     = math.sin(((sprite.partsiner[i] / 2) * 2))
                sprite.party[i]     = math.cos(((sprite.partsiner[i] / 2) * 2))
            else
                sprite.partsiner[i] = sprite.partsiner[i] + ((1 + (i / 5)) * 2) * DTMULT
                sprite.partrot[i]   = math.rad(sprite.partrot[i] - Utils.random(6))
                sprite.partx[i]     = math.sin(((sprite.partsiner[i] / 2) * 2))
                sprite.party[i]     = math.cos(((sprite.partsiner[i] / 2) * 2))
            end
        else
            sprite.resetsiner = false
        end
		
        if sprite.anim == "laugh" then  -- laughing animation	
            sprite.resetsiner = true
			
            sprite.laughtimer = sprite.laughtimer + DTMULT
			
            if sprite.laughtimer == 1 then
                Assets.playSound("sneo_laugh_long", 1, 0.7)
                Assets.playSound("sneo_laugh_long", 1, 0.65)
                Assets.playSound("sneo_laugh_long", 1, 0.5)
            end
			
            if i == 4 then
                sprite.partsiner[i] = sprite.partsiner[i] + DTMULT
                sprite.partrot[i]   = Utils.lerp(sprite.partrot[i] + (math.rad(25 - Utils.random(6))), 0, (0.25 * 2))
                sprite.partx[i]     = Utils.lerp(sprite.partx[i] + (math.sin(((sprite.partsiner[i] / 2) * 2))), 0, (0.25 * 2))
                sprite.party[i]     = Utils.lerp(sprite.party[i] + (math.cos(((sprite.partsiner[i] / 2) * 2))), 0, (0.25 * 2))
            elseif i == 3 then
                sprite.partsiner[i] = sprite.partsiner[i] + DTMULT
                sprite.partrot[i]   = Utils.lerp(sprite.partrot[i] + (math.rad(-10 - Utils.random(6))), 0, (0.25 * 2))
                sprite.partx[i]     = Utils.lerp(sprite.partx[i] + (math.sin(((sprite.partsiner[i] / 2) * 2))), 0, (0.25 * 2))
                sprite.party[i]     = Utils.lerp(sprite.party[i] + (math.cos(((sprite.partsiner[i] / 2) * 2)) + 28), 0, (0.25 * 2))
            elseif i == 2 then
                sprite.partsiner[i] = sprite.partsiner[i] + ((1 + (i / 5)) * 2) * DTMULT
                sprite.partrot[i]   = math.rad(sprite.partrot[i] - Utils.random(6))
                sprite.partx[i]     = Utils.lerp(sprite.partx[i] + (math.sin(((sprite.partsiner[i] / 2) * 2))), 0, (0.25 * 2))
                sprite.party[i]     = Utils.lerp(sprite.party[i] + (math.cos(((sprite.partsiner[i] / 2) * 2))), 0, (0.25 * 2))
            else
                sprite.partsiner[i] = sprite.partsiner[i] + ((1 + (i / 5)) * 2) * DTMULT
                sprite.partrot[i]   = math.rad(sprite.partrot[i] - Utils.random(6))
                sprite.partx[i]     = Utils.lerp(sprite.partx[i] + (math.sin(((sprite.partsiner[i] / 2) * 2))), 0, (0.25 * 2))
                sprite.party[i]     = Utils.lerp(sprite.party[i] + (math.cos(((sprite.partsiner[i] / 2) * 2))), 0, (0.25 * 2))
            end
        else
            sprite.resetsiner = false
            sprite.laughtimer = 0
        end

        local scalebonus = 0
        local expand     = 0
        local shakevar   = 0
	
        local part_x = ((((sprite.x + (sprite.partx[i])) + (sprite.partxoff[i]))) + shakevar)
        local part_y

        if i == 3 or i == 4 then
            part_y = (((sprite.y + sprite.party[i]) + sprite.partorigins[i][2]) - shakevar) 
        else
            part_y = (((sprite.y + sprite.party[i]) + sprite.partyoff[i]) - shakevar) 
        end

        local part_scalex = ((sprite.scale_x + scalebonus) + expand)
        local part_scaley = ((sprite.scale_y + scalebonus) + expand)

        love.graphics.setColor(sprite.partblend[i])
        Draw.draw(Assets.getTexture(sprite.part[i]), 
          part_x, 
          part_y, 
          sprite.partrot[i], 
          part_scalex,
          part_scaley,
          sprite.partorigins[i][1], 
          sprite.partorigins[i][2]
        )
    end
end

return actor