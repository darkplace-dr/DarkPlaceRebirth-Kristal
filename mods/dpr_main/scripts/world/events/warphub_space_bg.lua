local WarpHubSpaceBG, super = Class(Event, "warphub_space_bg")

function WarpHubSpaceBG:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.surf_textured = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.space_layers = Assets.getFrames("world/events/warphub_space_bg/space_layer")
	self.siner = 0
end

function WarpHubSpaceBG:draw()
	if Kristal.Config["simplifyVFX"] then return end
	self.siner = self.siner + 0.2 * DTMULT
    Draw.pushCanvas(self.surf_textured, {keep_transform = true})
    love.graphics.clear(0, 0, 0, 0)
    love.graphics.setColorMask(true, true, true, false)
	for i, layer in ipairs(self.space_layers) do
		Draw.drawWrapped(layer, true, true, math.floor(self.siner / (9 - i)), math.floor(self.siner / (9 - i)), 0, 2, 2)
	end
	Draw.setColor(1,1,1,1)
    love.graphics.setColorMask(false, false, false, true)
    for index, value in ipairs(self.stage:getObjects(Registry.getLegacyEvent("tile_oscillate"))) do
        love.graphics.push()
        love.graphics.replaceTransform(value:getFullTransform())
        love.graphics.rectangle("fill", 0, 0, value.width, value.height)
        love.graphics.pop()
    end
    love.graphics.setColorMask(true, true, true, true)
    Draw.popCanvas()
    love.graphics.origin()
    Draw.draw(self.surf_textured, 0, 0)
end

return WarpHubSpaceBG