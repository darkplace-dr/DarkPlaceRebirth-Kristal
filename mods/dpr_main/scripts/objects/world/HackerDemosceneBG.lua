local Matrix4x4 = modRequire('libraries.lz3d.src.Matrix4x4')
local OBJLoader = modRequire("libraries.lz3d.src.OBJLoader")
local Transform3D = modRequire("libraries.lz3d.src.Transform3D")
local Graphics = modRequire("libraries.lz3d.src.Graphics")

local HackerDemosceneBG, super = Class(Object)

HackerDemosceneBG.VertexFormat = {
    {"VertexPosition", "float", 3},
    {"VertexTexCoord", "float", 2},
    {"VertexNormal", "float", 3},
    {"VertexColor", "byte", 4},
}

function HackerDemosceneBG:init()
    super.init(self, 0, 0)
	self.demo_active = false
	self.demo_alpha = 0
	self.bg_mode = 0
	self.bg_timer = 0
	self.siner = 0
	self.rainbow_color = COLORS.white
	self.font = Assets.getFont("main")
    self.logo_letter_meshes = {}
	for i = 1, 9 do
		self.logo_letter_meshes[i] = OBJLoader.meshFromFilePath(Mod.info.path .. "/assets/models/demo_letter_"..i..".obj", false, false)
	end
end

function HackerDemosceneBG:update()
	super.update(self)
	if self.demo_active then
		self.siner = self.siner + DTMULT
        self.rainbow_color = {ColorUtils.HSVToRGB((self.siner / 255) % 1, 0.3, 1)}
		self.demo_alpha = MathUtils.approach(self.demo_alpha, 1, 0.1 * DTMULT)
		self.bg_timer = self.bg_timer + DTMULT
		if self.bg_timer >= 300 then
			self:randomizeBackground()
			self.bg_timer = 0
		end
	end
end

function HackerDemosceneBG:randomizeBackground()

end

function HackerDemosceneBG:drawBackground()
	local bg = self.bg_mode or 0
end

function HackerDemosceneBG:draw()
    super.draw(self)
	
	if self.demo_active then
		local bg_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
		self:drawBackground()
		Draw.popCanvas(true)
		
		local logo_canvas = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT, { depthstencil = Graphics.depth_buffer })
		love.graphics.clear(0, 0, 0, 0, true)
		love.graphics.push("all")
		love.graphics.setMeshCullMode("back")
		love.graphics.setFrontFaceWinding("cw")

		local letter_transforms = {}
		for i = 1, 9 do
			letter_transforms[i] = Transform3D(0, 0, 0)
			letter_transforms[i]:setRotationX(45 - 5 + math.sin((self.siner + (i * 4)) / 8) * 5)
			letter_transforms[i]:setX(SCREEN_WIDTH/2)
			letter_transforms[i]:setY(80 + math.sin((self.siner + (i * 4)) / 8) * 4)
			letter_transforms[i]:setScaleX(40)
			letter_transforms[i]:setScaleY(40)
			letter_transforms[i]:setScaleZ(-40)
		end

		local viewtransform = Transform3D(Game.world.camera.x,Game.world.camera.y,0)

		local projection_matrix = (Matrix4x4():buildOrthographicProjection(
			SCREEN_WIDTH, -SCREEN_HEIGHT,
			-50,
			50,
			nil ---@diagnostic disable-line: redundant-parameter
		))
		projection_matrix:set(3, 2, projection_matrix:get(3, 2) + 0.005)


		Graphics.setProjectionMatrix(projection_matrix)

		Graphics.setViewMatrix(viewtransform:getMatrix():inverse())

		love.graphics.setDepthMode("less", true)

		love.graphics.setWireframe(true)
		Draw.setColor(COLORS.lime)
		for i = 1, 9 do
			Graphics.setObjectMatrix(letter_transforms[i]:getMatrix())
			Draw.draw(self.logo_letter_meshes[i])
		end
		Draw.popShader()

		love.graphics.setDepthMode()
		love.graphics.setWireframe(false)
		love.graphics.pop()
		if love.getVersion() >= 12 then
			love.graphics.resetProjection()
		end
		Draw.popCanvas(true)
		Draw.setColor(COLORS.white, self.demo_alpha)
		Draw.drawCanvas(bg_canvas, 0, 0)
		Draw.drawCanvas(logo_canvas, 0, 0)
		love.graphics.setFont(self.font)
		Draw.setColor(self.rainbow_color, self.demo_alpha)
		local text = "[From The Classics You've Come To Expect]!!"
		local xoff = (SCREEN_WIDTH / 2) - (self.font:getWidth(text) / 4)
		for i = 1, StringUtils.len(text) do
			local ch = StringUtils.sub(text, i, i)
			love.graphics.print(ch, xoff, 140 + (math.sin((self.siner + (i - 1)) / 8) * 16), 0, 0.5, 0.5)
			xoff = xoff + self.font:getWidth(ch) / 2
		end
	end
end

return HackerDemosceneBG