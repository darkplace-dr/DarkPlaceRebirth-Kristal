local BG, super = Class(Object)

function BG:init(color, fill)
    super.init(self)
    self.color = color or COLORS.white
    self.fill = fill or COLORS.black
	self.offset = 0
    self.speed = 0.5
    self.size = 50
    self.layer = BATTLE_LAYERS["bottom"]
    self.discoball = Discoball()
    self:addChild(self.discoball)
end

function BG:update()
    super.update(self)
    self.fade = Game.battle.transition_timer / 10
    self.offset = self.offset + self.speed*DTMULT
	self.discoball.y = MathUtils.lerp(-160, 0, self.fade)
    if self.offset >= 100 then
        self.offset = self.offset - 100
    end
end

function BG:draw()

    local r,g,b,a = unpack(self.fill)
    love.graphics.setColor(r,g,b, a or self.fade)
    love.graphics.rectangle("fill", -10, -10, SCREEN_WIDTH+10, SCREEN_HEIGHT+10)

    local r,g,b,a = unpack(self.color)
    love.graphics.setColor(r,g,b, a or self.fade)
    for x = 0, 1, 50 do
        for y = 0, 1, 50 do
            local dojo = Assets.getTexture("battle/dojo_battlebg")
            love.graphics.draw(dojo, SCREEN_WIDTH/2, (SCREEN_HEIGHT/2)-75, 0, (2 + math.sin(self.offset/2) * 0.008), (2 + math.cos(self.offset/2) * 0.008), dojo:getWidth()/2, dojo:getHeight()/2)
        end
    end
    super.draw(self)
end

return BG