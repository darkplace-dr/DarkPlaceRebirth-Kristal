local Jam26DDelta_KikkyScreen, super = Class(Event)

function Jam26DDelta_KikkyScreen:init(data)
	super.init(self, data)
	self.kikky_world = Jam26DDelta_KikkyWorld("floor2/jam/ddelta/main/kikky_world", 0, 0, 0, 0, 0, 544, 224, 544, 224)
    --Game.world.player.active = false
    Game.world:addChild(self.kikky_world)
	self.cool_blue = ColorUtils.mergeColor(COLORS.blue, COLORS.aqua, 0.5)
	self.font = Assets.getFont("8bit")
	self.text_scroll_x = 0
end

function Jam26DDelta_KikkyScreen:draw()
	super.draw(self)
	if not Game.world.kikky_world then return end
	local crt_canvas = Draw.pushCanvas(Game.world.kikky_world.screen_width, Game.world.kikky_world.screen_height+32)
	love.graphics.clear(COLORS.black)
	Draw.setColor(self.cool_blue)
	love.graphics.setFont(self.font)
	self.text_scroll_x = self.text_scroll_x - 2 * DTMULT
	local text = "NAGASAKY KIKKY'S WORLD: JAMMIN' EDITION    "
	if self.text_scroll_x <= -self.font:getWidth(text) then
		self.text_scroll_x = self.text_scroll_x + self.font:getWidth(text)
	end
	love.graphics.print(text .. text, self.text_scroll_x, 8)
	Draw.setColor(COLORS.white)
    Draw.drawCanvas(Game.world.kikky_world.main_canvas, 0, 32)
    Draw.popCanvas(true)
	Game.world.kikky_world.crttimer = (Game.world.kikky_world.crttimer + 0.5 * DTMULT) % 3
	local vig = Game.world.kikky_world.crt_glitch > 0 and (0.2 + MathUtils.random(MathUtils.clamp(Game.world.kikky_world.crt_glitch / 200, 0, 0.1))) or 0.2
	local vigint = math.pow(1.5, 1.5 - vig) * 18
	local chrom_scale = Game.world.kikky_world.crt_glitch > 0 and (MathUtils.randomInt(-4, 4) * MathUtils.clamp(Game.world.kikky_world.crt_glitch / 5, 1, 5)) or Game.world.kikky_world.chromstrength
	if chrom_scale == 0 then
		chrom_scale = 1
	end
	local filteramount = 0.1 + math.min(Game.world.kikky_world.crt_glitch / 100, 0.1)
	Game.world.kikky_world.crtshader:send("vignette_scale", vig)
	Game.world.kikky_world.crtshader:send("vignette_intensity", vigint)
	Game.world.kikky_world.crtshader:send("chromatic_scale", chrom_scale)
	Game.world.kikky_world.crtshader:send("filter_amount", filteramount)
	Game.world.kikky_world.crtshader:send("time", Game.world.kikky_world.crttimer)
	Game.world.kikky_world.crtshader:send("texsize", {1/Game.world.kikky_world.screen_width, 1/Game.world.kikky_world.screen_height})
	local last_shader = love.graphics.getShader()
	love.graphics.setShader(Game.world.kikky_world.crtshader) 
	local dx = Game.world.kikky_world.crt_glitch > 0 and (MathUtils.random(-1, 1) * MathUtils.clamp(Game.world.kikky_world.crt_glitch / Game.world.kikky_world.crt_glitchstrength, 0, 3)) or 0
	local dy = Game.world.kikky_world.crt_glitch > 0 and (MathUtils.random(-1, 1) * MathUtils.clamp(Game.world.kikky_world.crt_glitch / Game.world.kikky_world.crt_glitchstrength, 0, 3)) or 0
    Draw.drawCanvas(crt_canvas, math.min(dx, 0), 1 + math.min(dy, 0), 0, 1 + (math.abs(dx)/Game.world.kikky_world.screen_width), 1 + (math.abs(dy)/Game.world.kikky_world.screen_height))
	love.graphics.setShader(last_shader)
	love.graphics.setLineWidth(2)
	Draw.setColor(1,1,1,1)
	love.graphics.rectangle("line", -1, -1, 546, 258)
	if Game.world.kikky_world.crt_glitch > 0 then
		Game.world.kikky_world.crt_glitch = Game.world.kikky_world.crt_glitch - DTMULT
	end
end

return Jam26DDelta_KikkyScreen