local TeevieInterstitialDoors, super = Class(Event, "teevie_interstitial_doors")

function TeevieInterstitialDoors:init(data)
    super.init(self, data)

	self:setSprite("world/events/teevie_interstitial_doors/inactive")
	self.sign_bg_tex = Assets.getTexture("world/events/teevie_interstitial_doors/sign_bg")
	self.sign_tex = Assets.getTexture("world/events/teevie_interstitial_doors/sign")
	self.sign_outline_tex = Assets.getTexture("world/events/teevie_interstitial_doors/sign_outline")
	self.rainbow_shader = Assets.getShader("rainbow")
	self.time = 0.025
	self.speed = 0.75
	self.bonus_color_speed = 0.025
	self.siner = 0
	self.custom_text_timer = 0
	self.is_active = false
    self.rect_mesh = love.graphics.newMesh(
        {
            {"VertexPosition", "float", 2},
            {"VertexColor", "float", 3}
        },
        {
            {0,0,1,1,1},
            {1,0,1,1,1},
            {1,1,1,1,1},
            {0,1,1,1,1},
        },
        "fan"
    )
end

function TeevieInterstitialDoors:turnOn()
	self:setSprite("world/events/teevie_interstitial_doors/active")
	self.is_active = true
end

function TeevieInterstitialDoors:onInteract()
	Game.world:startCutscene("one_offs.mantle_dlc")
	return true
end

function TeevieInterstitialDoors:draw()
    super.draw(self)
	if not self.is_active then return end
    love.graphics.stencil(function ()
		local last_shader = love.graphics.getShader()
        love.graphics.setShader(Kristal.Shaders["Mask"])
        Draw.draw(self.sign_bg_tex, 20, 28, 0, 2, 2)
        love.graphics.setShader(last_shader)
    end, "replace", 1)
    love.graphics.setStencilTest("greater", 0)
	self.custom_text_timer = self.custom_text_timer + DTMULT
	local coltime = 15
	local col = ColorUtils.mergeColor(COLORS.white, COLORS.yellow, math.abs(math.sin(self.custom_text_timer / coltime)))
	local col2 = ColorUtils.mergeColor(COLORS.yellow, COLORS.white, math.abs(math.sin((self.custom_text_timer + (coltime / 2)) / coltime)))
    self.rect_mesh:setVertices(
        {
            { 0, 0, unpack(col2, 1, 3) },
            { 1, 0, unpack(col2, 1, 3) },
            { 1, 1, unpack(col, 1, 3) },
            { 0, 1, unpack(col, 1, 3) },
        }
    )
    love.graphics.draw(self.rect_mesh, 0, 20, 0, 170, 40)	
	love.graphics.setStencilTest()
    Draw.draw(self.sign_outline_tex, 32, 22, 0, 2, 2)
	love.graphics.setShader(self.rainbow_shader)
	self.time = self.time - self.bonus_color_speed * DTMULT
	self.rainbow_shader:send("u_uv", {0, 1})
	self.rainbow_shader:send("u_speed", self.speed)
	self.rainbow_shader:send("u_time", self.time)
    Draw.draw(self.sign_tex, 34, 24, 0, 2, 2)
    love.graphics.setShader()
end

return TeevieInterstitialDoors