---@class Firework : Object
---@overload fun(...) : Firework
local Firework, super = Class(Sprite, "Firework")

function Firework:init(x, y, exp_tex, coltype)
    local texture = Assets.getTexture("world/firework/ptc_1")
    super.init(self, texture, x, y)
    self:setScale(2)

    if type(exp_tex) == "string" then
        exp_tex = Assets.getTexture(exp_tex) or (Assets.getFrames(exp_tex)[1])
    end
    self.firework_texture = exp_tex
	self.color_type = coltype or Utils.pick({0, 2, 1})
    self.width, self.height = self.firework_texture:getWidth(), self.firework_texture:getHeight()

    -- New canvas
    self.canvas = love.graphics.newCanvas(self.width, self.height)
    self.canvas:setFilter("nearest", "nearest")

    love.graphics.reset()
    love.graphics.setCanvas(self.canvas)
    love.graphics.draw(self.firework_texture)
    love.graphics.setCanvas()

    local data = self.canvas:newImageData()

	self.firework_data = {}
	local count = 0
    for y = 1, self.height do
        for x = 1, self.width do
            local r, g, b, a = data:getPixel(x-1, y-1)
            if a > 0 then
                table.insert(self.firework_data, {count = count, col = {r, g, b}, x = x - 1, y = y - 1})
            end
			count = count + 1
        end
    end
	
	self.physics.speed_y = Utils.random(-10, -8)
	self.physics.gravity = 0.25
	
	self.hue = love.math.random(255)
	self.blend = COLORS.white
	if self.color_type == 1 then
		local blend = Utils.hsvToRgb((self.hue / 255) % 1, 100/255, 1)
		self:setColor(blend)
	end
	Assets.playSound("firework_send")
end

function Firework:update()
    super.update(self)
	if self.color_type == 2 then
		self.hue = self.hue + 3 * DTMULT
		self:setColor(Utils.hsvToRgb((self.hue / 255) % 1, 1, 1))
	end
	if self.physics.speed_y >= 0 then
		local explosion = FireworkExplosion(self.x, self.y, self.width, self.height, self.firework_data, self.color_type, (self.hue / 255) % 1)
		explosion.layer = self.layer
		Game.world:addChild(explosion)
		Assets.playSound("explosion_firework", 1, 0.8+Utils.random(0.1))
		self:remove()
		if not Game.world.map.has_firework_shadows then return end
		Game.world.map.fw_shadows_active = true
	end
end

function Firework:draw()
    super.draw(self)
end

return Firework