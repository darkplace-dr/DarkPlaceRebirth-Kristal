local DessimationBG, super = Class(Object)

function DessimationBG:init(color, back_color, fill)
    super.init(self)

    self.color = color
    self.back_color = back_color or color
    self.fill = fill or {0, 0, 0}
	self.offset = 0
    self.fade = 0
    self.speed = 0.5
    self.size = 50
	self.layer = BATTLE_LAYERS["bottom"]
	self.alpha_fx = self:addFX(AlphaFX())
    self.image = Assets.getTexture("battle/star_background")
    self.max_alpha = 0

    self.desses = false
    self.desses_timer = 0
    self.dess_anims = {"attack", "spell", "spellsuper", "spellsuperend"}
    self.dess_anim_frames = {7, 4, 3, 4}
    self.last_dess_anim = 1
    self.last_dess_anim_frame = 1
end

function DessimationBG:bgDess(x, y, reverse_movement)
    local path = "party/dess/dessimation/"
    local sprite = Sprite(path..self.dess_anims[self.last_dess_anim].."_"..self.last_dess_anim_frame, x, y)
    sprite:setScale(2)
    sprite:setOrigin(0.5)
    sprite.layer = self.layer + 1
    sprite.alpha = 0.5
    self:addChild(sprite)
    sprite:setPhysics({
        speed_x = reverse_movement and -10 or 10
    })
    Game.battle.timer:after(3, function() sprite:remove() end)
    if reverse_movement then
        self.last_dess_anim_frame = self.last_dess_anim_frame + 1
        if self.last_dess_anim_frame > self.dess_anim_frames[self.last_dess_anim] then
            self.last_dess_anim_frame = 1
            if self.last_dess_anim == 4 then
                self.last_dess_anim = 1
            else
                self.last_dess_anim = self.last_dess_anim + 1
            end
        end
    end
end

function DessimationBG:update()
    super.update(self)
    if self.fade < self.max_alpha then
        self.fade = self.fade + 0.01 * DTMULT
    elseif self.max_alpha == 0 and self.fade > 0 then
        self.fade = self.fade - 0.01 * DTMULT
    end
	self.offset = self.offset + self.speed*DTMULT

    if self.offset > self.size*2 then
        self.offset = self.offset - self.size*2
    end

    if self.desses then
        self.desses_timer = self.desses_timer + 1 * DTMULT
        if self.desses_timer >= 8 then
            self:bgDess(-40, SCREEN_HEIGHT/2+SCREEN_HEIGHT/4 - 50, false)
            self:bgDess(SCREEN_WIDTH + 40, SCREEN_HEIGHT/4 - 50, true)
            self.desses_timer = 0
        end
    end

	self.alpha_fx.alpha = Game.battle.transition_timer / 10
end

function DessimationBG:draw()
    super.draw(self)

    self:drawFill()
	self:drawBack()
	self:drawFront()

    Draw.setColor(0, 0, 0, Game.battle.background_fade_alpha)
    love.graphics.rectangle("fill", -20, -20, SCREEN_WIDTH + 40, SCREEN_HEIGHT + 40)
end

function DessimationBG:drawFill()
    local r,g,b,a = unpack(self.fill)
    love.graphics.setColor(r,g,b, a or self.fade)
    love.graphics.rectangle("fill", -8, -8, SCREEN_WIDTH+16, SCREEN_HEIGHT+16)
end

function DessimationBG:drawBack()
    local r,g,b,a = unpack(self.back_color)
    love.graphics.setColor(r,g,b, a or self.fade/2)
	for x = -100, 740, 50 do
		for y = -100, 580, 50 do
			love.graphics.draw(self.image, x + self.offset/2, y + self.offset/2 + 10)
		end
	end
end

function DessimationBG:drawFront()
    local r,g,b,a = unpack(self.color)
    love.graphics.setColor(r,g,b, a or self.fade)
	for x = 0, 740, 50 do
		for y = 0, 580, 50 do
			love.graphics.draw(self.image, x - self.offset, y - self.offset)
		end
	end
end

return DessimationBG