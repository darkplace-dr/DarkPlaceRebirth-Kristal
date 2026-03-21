local RemotePianoMoveUI, super = Class(Object)

function RemotePianoMoveUI:init(piano)
	super.init(self)
	self.piano = piano or nil
	self.arrowspr = "ui/arrow_9x9"
	self.circlespr = "ui/circle_7x7"
end

function RemotePianoMoveUI:draw()
	super.draw(self)
	
	local piano = self.piano
	if self.piano then
		local yy = piano.yoffset
		local litblue = ColorUtils.hexToRGB("#698DE6FF")
		piano.siner = piano.siner + DTMULT
		local alphatarg = 0
		if piano.engaged then
			alphatarg = 1
		end
		piano.drawalpha = MathUtils.lerp(piano.drawalpha, alphatarg, 0.1*DTMULT)
		piano.drawspace = 18
		piano.drawx = MathUtils.lerp(piano.drawx, piano.x + 40, 0.6*DTMULT)
		piano.drawy = MathUtils.lerp(piano.drawy, piano.y - 70, 0.6*DTMULT)
		love.graphics.setColor(0,0,0,piano.drawalpha*0.5)
		love.graphics.circle("fill", piano.drawx, yy + piano.drawy, 44 + math.sin(piano.siner / 64) * 2)
		local sprangle = 0
		local scale = 2
		local _space = 28
		local sinstrength = 3
		local sintimevar = 15
		local sintimevariance = 3
		local basealpha = 0.35
		piano.soundtoplay = 0
		if piano.movedir == 0 then
			piano.soundtoplay = 3
		end
		if piano.movedir == 1 then
			piano.soundtoplay = 5
		end
		if piano.movedir == 2 then
			piano.soundtoplay = 7
		end
		if piano.movedir == 3 then
			piano.soundtoplay = 1
		end
		local bonusalpha = 0
		local xloc = piano.drawx + _space
		local sinmod = (1/3) * sintimevar
		local yloc = ((piano.drawy + 2) - 8) + (math.sin((piano.siner + sinmod) / sintimevar) * sinstrength)
		local angle = -math.rad(90)
		local xscale = 2
		local yscale = 2
		if piano.soundtoplay == 5 then
			bonusalpha = 0.5
			if Input.pressed("confirm") and piano.makenote then
				piano.makenote = false
				local note = Sprite(self.arrowspr, xloc, yy + yloc)
				note.layer = piano.layer + 1
				note:setColor(litblue)
				note:setScale(xscale,yscale)
				note:setOriginExact(4, 4)
				note.rotation = angle
				note.physics.speed = 5
				note.physics.friction = 0.35
				note.physics.direction = angle + math.rad(90)
				Game.world.timer:lerpVar(note, "alpha", 1, 0, 20, 2, "out")
				Game.world.timer:after(20/30, function()
					note:remove()
				end)
				Game.world:addChild(note)
				
				local note2 = Sprite(self.arrowspr, xloc, yy + yloc)
				note2.layer = piano.layer + 2
				note2:setColor(COLORS.white)
				note2:setScale(xscale,yscale)
				note2:setOriginExact(4, 4)
				note2.rotation = angle
				Game.world.timer:lerpVar(note2, "alpha", 2, 0, 10, 2, "out")
				Game.world.timer:after(10/30, function()
					note2:remove()
				end)
				Game.world:addChild(note2)
			end
		end
		love.graphics.setColor(litblue[1], litblue[2], litblue[3], (basealpha + bonusalpha) * piano.drawalpha)
		Draw.draw(Assets.getTexture(self.arrowspr), xloc, yy + yloc, angle, xscale, yscale, 4, 4)
		bonusalpha = 0
		xloc = piano.drawx - _space
		sinmod = (2/3) * sintimevar
		yloc = ((piano.drawy + 2) + 8) + (math.sin((piano.siner + sinmod) / sintimevar) * sinstrength)
		angle = -math.rad(270)
		xscale = -2
		yscale = 2
		if piano.soundtoplay == 1 then
			bonusalpha = 0.5
			if Input.pressed("confirm") and piano.makenote then
				piano.makenote = false
				local note = Sprite(self.arrowspr, xloc, yy + yloc)
				note.layer = piano.layer + 1
				note:setColor(litblue)
				note:setScale(xscale,yscale)
				note:setOriginExact(4, 4)
				note.rotation = angle
				note.physics.speed = 5
				note.physics.friction = 0.35
				note.physics.direction = angle + math.rad(90)
				Game.world.timer:lerpVar(note, "alpha", 1, 0, 20, 2, "out")
				Game.world.timer:after(20/30, function()
					note:remove()
				end)
				Game.world:addChild(note)
				
				local note2 = Sprite(self.arrowspr, xloc, yy + yloc)
				note2.layer = piano.layer + 2
				note2:setColor(COLORS.white)
				note2:setScale(xscale,yscale)
				note2:setOriginExact(4, 4)
				note2.rotation = angle
				Game.world.timer:lerpVar(note2, "alpha", 2, 0, 10, 2, "out")
				Game.world.timer:after(10/30, function()
					note2:remove()
				end)
				Game.world:addChild(note2)
			end
		end
		love.graphics.setColor(litblue[1], litblue[2], litblue[3], (basealpha + bonusalpha) * piano.drawalpha)
		Draw.draw(Assets.getTexture(self.arrowspr), xloc, yy + yloc, angle, xscale, yscale, 4, 4)
		bonusalpha = 0
		xloc = piano.drawx + 2
		sinmod = 1 * sintimevar
		yloc = (piano.drawy - _space) + (math.sin((piano.siner + sinmod) / sintimevar) * sinstrength)
		angle = -math.rad(180)
		xscale = 2
		yscale = 2
		if piano.soundtoplay == 7 then
			bonusalpha = 0.5
			if Input.pressed("confirm") and piano.makenote then
				piano.makenote = false
				local note = Sprite(self.arrowspr, xloc, yy + yloc)
				note.layer = piano.layer + 1
				note:setColor(litblue)
				note:setScale(xscale,yscale)
				note:setOriginExact(4, 4)
				note.rotation = angle
				note.physics.speed = 5
				note.physics.friction = 0.35
				note.physics.direction = angle + math.rad(90)
				Game.world.timer:lerpVar(note, "alpha", 1, 0, 20, 2, "out")
				Game.world.timer:after(20/30, function()
					note:remove()
				end)
				Game.world:addChild(note)
				
				local note2 = Sprite(self.arrowspr, xloc, yy + yloc)
				note2.layer = piano.layer + 2
				note2:setColor(COLORS.white)
				note2:setScale(xscale,yscale)
				note2:setOriginExact(4, 4)
				note2.rotation = angle
				Game.world.timer:lerpVar(note2, "alpha", 2, 0, 10, 2, "out")
				Game.world.timer:after(10/30, function()
					note2:remove()
				end)
				Game.world:addChild(note2)
			end
		end
		love.graphics.setColor(litblue[1], litblue[2], litblue[3], (basealpha + bonusalpha) * piano.drawalpha)
		Draw.draw(Assets.getTexture(self.arrowspr), xloc, yy + yloc, angle, xscale, yscale, 4, 4)
		bonusalpha = 0
		xloc = piano.drawx
		sinmod = (4/3) * sintimevar
		yloc = (piano.drawy + _space) + (math.sin((piano.siner + sinmod) / sintimevar) * sinstrength)
		angle = -math.rad(0)
		xscale = 2
		yscale = 2
		if piano.soundtoplay == 3 then
			bonusalpha = 0.5
			if Input.pressed("confirm") and piano.makenote then
				piano.makenote = false
				local note = Sprite(self.arrowspr, xloc, yy + yloc)
				note.layer = piano.layer + 1
				note:setColor(litblue)
				note:setScale(xscale,yscale)
				note:setOriginExact(4, 4)
				note.rotation = angle
				note.physics.speed = 5
				note.physics.friction = 0.35
				note.physics.direction = angle + math.rad(90)
				Game.world.timer:lerpVar(note, "alpha", 1, 0, 20, 2, "out")
				Game.world.timer:after(20/30, function()
					note:remove()
				end)
				Game.world:addChild(note)
				
				local note2 = Sprite(self.arrowspr, xloc, yy + yloc)
				note2.layer = piano.layer + 2
				note2:setColor(COLORS.white)
				note2:setScale(xscale,yscale)
				note2:setOriginExact(4, 4)
				note2.rotation = angle
				Game.world.timer:lerpVar(note2, "alpha", 2, 0, 10, 2, "out")
				Game.world.timer:after(10/30, function()
					note2:remove()
				end)
				Game.world:addChild(note2)
			end
		end
		love.graphics.setColor(litblue[1], litblue[2], litblue[3], (basealpha + bonusalpha) * piano.drawalpha)
		Draw.draw(Assets.getTexture(self.arrowspr), xloc, yy + yloc, angle, xscale, yscale, 4, 4)
		bonusalpha = 0
		xloc = piano.drawx
		sinmod = 1.6666666666666667 * sintimevar
		yloc = piano.drawy + (math.sin((piano.siner + sinmod) / sintimevar) * sinstrength)
		angle = math.rad(0)
		xscale = 2
		yscale = 2
		if piano.soundtoplay == 0 then
			bonusalpha = 0.5
			if Input.pressed("confirm") and piano.makenote then
				piano.makenote = false
				local note = Sprite(self.circlespr, xloc, yy + yloc)
				note.layer = piano.layer + 2
				note:setColor(COLORS.white)
				note:setScale(yscale,yscale)
				note:setOriginExact(4, 4)
				note.rotation = angle
				Game.world.timer:lerpVar(note, "alpha", 2, 0, 10, 2, "out")
				Game.world.timer:after(10/30, function()
					note:remove()
				end)
				Game.world:addChild(note)
			end
		end
		love.graphics.setColor(litblue[1], litblue[2], litblue[3], (basealpha + bonusalpha) * piano.drawalpha)
		Draw.draw(Assets.getTexture(self.circlespr), xloc, yy + yloc, maangle, xscale, yscale, 4, 4)
		love.graphics.setColor(1,1,1,1)
	end
end

return RemotePianoMoveUI
