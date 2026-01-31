local BG, super = Class(Object)

function BG:init(color, fill)
    super.init(self)
	self.dojo_siner = 0
    self.layer = BATTLE_LAYERS["bottom"]
	if not Game.world.discoball then
		self.discoball = Discoball()
		self.discoball.y = -200
		self:addChild(self.discoball)
	else
		Game.battle.timer:after(1/30, function()
			if Game.world and Game.world.discoball and Game.world.discoball.parent and Game.world.discoball.parent:includes(World) then
				local x, y = Game.world.discoball:getScreenPos()
				Game.world.discoball.discoball_original_x = x
				Game.world.discoball.discoball_original_y = y
				Game.world.discoball:setParent(Game.battle)
				Game.world.discoball:setScreenPos(x, y)
				Game.battle.discoball = Game.world.discoball
			end
		end)
	end
    self.draw_party_lights = Game.battle.encounter.draw_party_lights or true
    self.draw_enemy_lights = Game.battle.encounter.draw_enemy_lights or true
    self.grad_tex = Assets.getTexture("effects/whitegradientdown_40")
    self.vertices = {
        {0,0,0,0},
        {1,0,1,0},
        {1,1,1,1},
        {0,1,0,1},
    }
    self.mesh = love.graphics.newMesh(self.vertices, "fan")
end

function BG:drawTexturePos(tex, x1, y1, x2, y2, x3, y3, x4, y4, alpha)
    self.mesh:setVertices({
        {x1,y1,0,0},
        {x2,y2,1,0},
        {x3,y3,1,1},
        {x4,y4,0,1},
    })
    self.mesh:setTexture(tex)
    Draw.draw(self.mesh)

    if DEBUG_RENDER then
        love.graphics.polygon("line", x1,y1,x2,y2,x3,y3,x4,y4)
    end
end

function BG:update()
    super.update(self)
    self.dojo_siner = self.dojo_siner + (0.5 * DTMULT)
    if self.dojo_siner >= 100 then
        self.dojo_siner = self.dojo_siner - 100
    end
    if self.discoball then
        if Game.battle.state == "TRANSITION" or Game.battle.state == "ENEMYDIALOGUE" or Game.battle.state == "DEFENDING" or Game.battle.state == "DEFENDINGBEGIN" or Game.battle.state == "TRANSITIONOUT" then
            if self.discoball.y >= -200 then
                self.discoball.physics.speed_y = self.discoball.physics.speed_y - (1 * DTMULT)
            else
                self.discoball.physics.speed_y = 0
            end
        elseif self.discoball.y < -10 then
            self.discoball.y = MathUtils.lerp(self.discoball.y, 0, 0.5)
        end
    elseif Game.battle.discoball then
		if Game.battle.state == "TRANSITIONOUT" and Game.battle.transition_timer < 10 then
			Game.battle.discoball.x = MathUtils.lerp(Game.battle.discoball.discoball_original_x, SCREEN_WIDTH/2, (Game.battle.transition_timer - 1) / 10)
			Game.battle.discoball.y = MathUtils.lerp(Game.battle.discoball.discoball_original_y, 0, (Game.battle.transition_timer - 1) / 10)
		elseif Game.battle.state == "TRANSITION" then
			Game.battle.discoball.x = MathUtils.lerp(Game.battle.discoball.discoball_original_x, SCREEN_WIDTH/2, Game.battle.transition_timer / 10)
			Game.battle.discoball.y = MathUtils.lerp(Game.battle.discoball.discoball_original_y, 0, Game.battle.transition_timer / 10)
		else
			if Game.battle.state == "ENEMYDIALOGUE" or Game.battle.state == "DEFENDING" or Game.battle.state == "DEFENDINGBEGIN" then
				if Game.battle.discoball.y >= -200 then
					Game.battle.discoball.physics.speed_y = Game.battle.discoball.physics.speed_y - (1 * DTMULT)
				else
					Game.battle.discoball.physics.speed_y = 0
				end
			elseif Game.battle.discoball.y < -10 then
				Game.battle.discoball.y = MathUtils.lerp(Game.battle.discoball.y, 0, 0.5*DTMULT)
			end
		end
	end
end

function BG:draw()
    love.graphics.setColor(0, 0, 0, Game.battle.transition_timer / 10)
    love.graphics.rectangle("fill", -10, -10, SCREEN_WIDTH+10, SCREEN_HEIGHT+10)

    love.graphics.setColor(1, 1, 1, Game.battle.transition_timer / 10)
    for x = 0, 1, 50 do
        for y = 0, 1, 50 do
            local dojo = Assets.getTexture("battle/dojo_battlebg")
			Draw.draw(dojo, SCREEN_WIDTH/2, 340, 0, 2 + (math.sin(self.dojo_siner / 2) * 0.008), 2 + (math.cos(self.dojo_siner / 2) * 0.008), 160, 169)
        end
    end
    if Game.battle.state ~= "TRANSITION" and Game.battle.state ~= "INTRO" and Game.battle.state ~= "TRANSITIONOUT" then
		local light_height = 280
		if self.draw_party_lights then
			for _, battler in ipairs(Game.battle.party) do
				local xx, yy = battler:getRelativePos(battler.width/2, battler.height)
				if battler.chara.id == "kris" then
					xx, yy = battler:getRelativePos(20/2, battler.height)
				elseif battler.chara.id == "susie" or battler.chara.id == "ralsei" then
					xx, yy = battler:getRelativePos((20 + 15)/2, battler.height)
				elseif battler.chara.id == "hero" then
					xx, yy = battler:getRelativePos(10/2, battler.height - 3)
				end
				local width = 80
				Draw.setColor(1, 1, 1, 0.25)
				self:drawTexturePos(self.grad_tex, xx, yy - light_height, xx, yy - light_height, xx - (width / 2) + 2, yy - 2, xx + (width / 2) - 2, yy - 2, 0.25)
				Draw.setColor(0.5, 0.5, 0.5, 1)
				love.graphics.ellipse("fill", xx, yy + 4 - (((yy + 4) - (yy - 10))/4), width / 2, ((yy + 4) - (yy - 10))/2)
				Draw.setColor(1, 1, 1, 1)
		   end
		end
		if self.draw_enemy_lights then
			for _, battler in ipairs(Game.battle.enemies) do
				local xx, yy = battler:getRelativePos(battler.width/2, battler.height)
				local width = battler.width*2
				Draw.setColor(1, 1, 1, 0.25)
				self:drawTexturePos(self.grad_tex, xx, yy - light_height, xx, yy - light_height, xx - (width / 2) + 2, yy - 2, xx + (width / 2) - 2, yy - 2, 0.25)
				Draw.setColor(0.5, 0.5, 0.5, 1)
				love.graphics.ellipse("fill", xx, yy + 4 - (((yy + 4) - (yy - 10))/4), width / 2, ((yy + 4) - (yy - 10))/2)
				Draw.setColor(1, 1, 1, 1)
			end
		end
	end
    super.draw(self)
end

return BG