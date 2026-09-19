local Character, super = HookSystem.hookScript(Character)

function Character:init(actor, x, y)
    super.init(self, actor, x, y)
	
	self.drawing_resized_shadow = false
	self.self_shadow = false
	self.skip_selfshadowing = false
	self.selfshadow_override = false
	self.reset_selfshadow_override = false
	self.shadow_fix_hack = true
	self.true_x = self.x
	self.true_y = self.y
end

function Character:preDraw()
	self.true_x = self.x
	self.true_y = self.y
	if self.drawing_resized_shadow then
		self.x = MathUtils.round(self.x / 2)
		self.y = MathUtils.round(self.y / 2)
	end
	if self.shadow_fix_hack then
        local transform = love.graphics.getTransformRef()
        self:applyTransformTo(transform)
        love.graphics.replaceTransform(transform)
		Draw.setColor(self:getDrawColor())
		Draw.pushScissor()
		self:applyScissor()
	else
		super.preDraw(self)
	end
end

function Character:postDraw()
	if self.self_shadow and not self.skip_selfshadowing then
		local sunshadows = Game.stage:getObjects(SunShadows)[1]
		if sunshadows then
			local shadow_alpha = 1
			local overcast_alpha = 0
			if Game.stage.weather then
				for i, w in ipairs(Game.stage.weather) do
					if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
						shadow_alpha = 1 - (w.weathertimer / 120)
						if Game:getFlag("hometown_time", "day") == "evening" and Game.world.map.id == "light/hometown/town_beach" then
							overcast_alpha = (w.weathertimer / 120) * 0.7
						else
							overcast_alpha = (w.weathertimer / 120) * 0.5
						end
					end
				end
			end
			Draw.pushShader(sunshadows.shadowblend_shader)
			local shadow_col = sunshadows.colour_shadowblend
			shadow_col[4] = sunshadows.alpha_shadowblend
			if shadow_alpha > 0 then
				local last_alpha = self.alpha
				self.alpha = shadow_alpha
				sunshadows.shadowblend_shader:sendColor("shadowCol", shadow_col)
				local has_shadow_sprite, old_tex_obj = false, nil
				if sunshadows.evening_mode and not self.selfshadow_override then
					has_shadow_sprite, old_tex_obj = sunshadows:setupEveningShadow(self)
					if not has_shadow_sprite then
						Draw.pushScissor()
						local actor_offset = self.sprite:includes(ActorSprite) and self.sprite:getOffset() or {0, 0}
						Draw.scissor(self.sprite.x + actor_offset[1], self.sprite.y + actor_offset[2], -actor_offset[1] + math.floor((self.sprite.width or self.width) / 2), -actor_offset[2] + (self.sprite.height or self.height))
					end
				end
				self:draw()
				if sunshadows.evening_mode and not self.selfshadow_override then
					if old_tex_obj then
						self.sprite:setTextureExact(old_tex_obj)
					else
						Draw.popScissor()
					end
				end
				self.alpha = last_alpha
			end
			if overcast_alpha > 0 then
				local last_alpha = self.alpha
				self.alpha = overcast_alpha
				self:draw()
				self.alpha = last_alpha
			end
			Draw.popShader()
		end
	end
	if self.reset_selfshadow_override then
		self.selfshadow_override = false
		self.reset_selfshadow_override = false
	end
	if self.shadow_fix_hack then
		Draw.popScissor()
	else
		super.postDraw(self)
	end
	self.x = self.true_x
	self.y = self.true_y
end

return Character