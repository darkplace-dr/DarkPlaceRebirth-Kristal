local SunShadows, super = Class(Object)

function SunShadows:init()
    super.init(self, 0, 0)

	self.sunlight_alpha = 1
	self.highlight_mode = 0
	self.marker_mode = false
	self.darkzone_multiplier = 2
	self.resize_mode = true
	self.evening_mode = false
	self.canv_static_shadows = nil
	self.canv_static_cutout = nil
	self.canv_static_hcutout = nil
	self.canv_resize = nil
	self.obj_list = {}
	self.selfshadow_objects = {}
	self.dropshadow_objects = {}
	self.movingshadow_objects = {}
	self.highlight_objects = {}
	self.cuthighlight_objects = {}
	self.shadow_spritecache = {}
	self.shadow_assetcache = {}
	self.colour_shadowblend = ColorUtils.hexToRGB("#0D0538")
	self.alpha_shadowblend = 0.3
	self.skew_amt = 45
	self.highlight_mode = 0
	self.subtract_highlights = true
	self.tile_layer_names = {}
	self.asset_layer_names = {}
	self.cutout_tile_layer_names = {}
	self.cutout_asset_layer_names = {}
	self.hcutout_tile_layer_names = {}
	self.hcutout_asset_layer_names = {}
	self.objects_shadows = {}
	self.objects_cutout = {}
	self.objects_hcutout = {}
	self.shadowblend_shader = Assets.getShader("shadowblend")
	self.shadowblend_evening_shader = Assets.getShader("shadowblend_evening")
	self.highlight_shader = Assets.getShader("forcecolour")
	self.forcealpha_shader = Assets.getShader("forcefullalpha")
	self.can_do_gm_blending = (Ch4Lib and Ch4Lib.accurate_blending or false)
    self.shadow_mesh = love.graphics.newMesh({
        {0, 0,
        0, 0,
        1, 1, 1},
        {1, 0,
        1, 0,
        1, 1, 1},
        {1, 1,
        1, 1,
        1, 1, 1},
        {0, 1,
        0, 1,
        1, 1, 1}
    }, "fan")
end

function SunShadows:generateShadowCanvas(tiles, assets, objects)
	local last_shader = love.graphics.getShader()
	local resizemultiplier = self.resize_mode and 2 or 1
	local canvas = love.graphics.newCanvas((Game.world.map.width * Game.world.map.tile_width)/resizemultiplier, (Game.world.map.height * Game.world.map.tile_height)/resizemultiplier)
	Draw.pushCanvas(canvas)
	love.graphics.clear()
	love.graphics.push()
	love.graphics.origin()
	love.graphics.scale(self.resize_mode and 0.5 or 1, self.resize_mode and 0.5 or 1)
    love.graphics.setShader(shader)
	for _, asset in ipairs(assets) do
		local layer = Game.world.map.layers[asset]
		for _, obj in ipairs(Game.stage:getObjects(TileObject)) do
			if obj.layer == layer then
				obj.visible = true
				obj:fullDraw()
				obj.visible = false
			end
		end
	end
	for _, tiles in ipairs(tiles) do
		local tile_layer = Game.world.map:getTileLayer(tiles)
		if tile_layer then
			tile_layer.visible = true
			tile_layer:draw()
			tile_layer.visible = false
		end
	end
	for _, object in ipairs(objects) do
		local layer = Game.world.map.layers[object]
		for _, obj in ipairs(Game.world.children) do
			if obj.layer == layer and obj and not obj:isRemoved() then
				if not obj.sunshadows_exclude then
					obj.visible = true
					if obj.shadowdraw_func then
						obj.shadowdraw_func()
					else
						obj:preDraw()
						obj:draw()
						obj:postDraw()
					end
					obj.visible = false
				end
			end
		end
	end
	love.graphics.pop()
	love.graphics.setShader(last_shader)
	Draw.popCanvas(true)
	return canvas
end

function SunShadows:drawShadowCast(obj, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
	if arg0 == 0 or obj.scale_y == 0 then return end
	if not obj.sprite.texture then return end
	local sx = obj.x - Game.world.camera.x - SCREEN_WIDTH/2
	local sy = obj.y - Game.world.camera.y - SCREEN_HEIGHT/2
	local spritedata = obj.sprite
	local width = spritedata.texture:getWidth() * obj.scale_x * arg5
	local height = spritedata.texture:getHeight() / math.abs(arg0)
	local yy = (((arg4 and sy or obj.y)) - (obj.origin_y_exact or (height * obj.origin_y))) * arg5
	local bottom = height + arg2
	local top = bottom - (height * arg0)
	local xx = (((arg4 and sx or obj.x)) - (obj.origin_x_exact or (width * obj.origin_x))) * arg5
	local top = math.floor(top) - arg8
	local bottom = math.floor(bottom) - arg8
	if arg6 then
		arg1 = math.floor(MathUtils.lengthDirX(math.floor(height / math.sin(math.rad(arg1))), -math.rad(arg1)))
	end
	self.shadow_mesh:setVertices({
        {arg1, top,
        0, 0,
        1, 1, 1},
        {arg1 + width, top,
        1, 0,
        1, 1, 1},
        {width, bottom,
        1, 1,
        1, 1, 1},
        {0, bottom,
        0, 1,
        1, 1, 1}
    })
    self.shadow_mesh:setTexture(spritedata.texture)
    love.graphics.draw(self.shadow_mesh, xx, yy)
end

function SunShadows:castShadow(obj, arg1)
	local cx = (Game.world.camera.x - SCREEN_WIDTH/2)/2
	local cy = (Game.world.camera.y - SCREEN_HEIGHT/2)/2
	local resizemultiplier = self.resize_mode and 0.5 or 1
	love.graphics.push()
	if self.evening_mode then
		if arg1 == false or obj.visible then
			local sprname = obj.sprite.texture
			local cache = self.shadow_assetcache
			local finalsprite = sprname
			if finalsprite then
				Draw.draw(finalsprite, obj.x - cx, obj.y - cy, obj.rotation, obj.scale_x, obj.scale_y)
			end
		end
	elseif self.highlight_mode == 0 then
		if arg1 == false or obj.visible then
			local adj_x = 0
			local adj_y = 0
			if obj:includes(Character) then
				if (obj.actor.id == "kris" or obj.actor.id == "hero") and obj:includes(Player) and Game:isLight() then
					adj_y = 1
				elseif obj.actor.id == "susie" and not Game:isLight() then
					adj_y = 0
				elseif obj.actor.id == "ralsei" then
					adj_y = 0
				elseif obj.actor.id == "noelle" then
					adj_y = 1
				elseif obj.actor.id == "kris" then
					adj_y = 0
				end
			end
			local dw_amp = 1
			obj.x = obj.x - cx
			obj.y = obj.y - cy
			local objsx, objsy = obj.scale_x, obj.scale_y
			obj:setScale(1, 1)
			local use_special_shadowcast = true
			local xxx = (obj.x + (self.skew_amt * dw_amp)) * resizemultiplier
			local yyy = (obj.y + (obj.height * 2) + adj_y + (obj.height * (1 - self.sunlight_alpha))) * resizemultiplier
			xxx = obj.x * resizemultiplier
			yyy = (obj.y - adj_y) * resizemultiplier
			local spr = obj.sprite.texture
			if (obj:includes(Player) or obj:includes(Follower)) and obj.state == "DASH" then
				use_special_shadowcast = true
			end
			if obj:includes(Character) and obj.jumping then
				--yyy = yyy + 60
				--xxx = xxx - 10
				use_special_shadowcast = false
			end
			if obj.sunshadow_y_offset then
				adj_y = obj.sunshadow_y_offset
			end
			love.graphics.translate(-cx/2, -cy/2)
			--local offset = obj.sprite:getOffset() or {0, 0}
			--love.graphics.translate(offset[1]/objsx, offset[2]/objsy)
			if use_special_shadowcast then
				love.graphics.translate(-obj.x/2, -obj.y/2)
				self:drawShadowCast(obj, -1, self.skew_amt, -dw_amp, obj.alpha, false, 1 / dw_amp, true, self.shadow_spritecache, adj_y)
			else
				Draw.draw(spr, xxx, yyy, obj.rotation, obj.scale_x, obj.scale_y * -1 * (2 - self.sunlight_alpha), obj.origin_x_exact or (obj.origin_x * spr:getWidth()), obj.origin_y_exact or (obj.origin_y * spr:getHeight()), -math.rad(self.skew_amt), 0)
			end
			obj.x = obj.x + cx
			obj.y = obj.y + cy
			obj:setScale(objsx, objsy)
		end
	end
	love.graphics.pop()
end

function SunShadows:castShadowSelf(obj, arg1)
	love.graphics.push()
	local last_shader_3 = love.graphics.getShader()
	love.graphics.setShader(Kristal.Shaders["Mask"])
	local cx = Game.world.camera.x - SCREEN_WIDTH/2
	local cy = Game.world.camera.y - SCREEN_HEIGHT/2

	if arg1 == false or obj.visible then
		local vis = obj.visible
		obj.visible = true
		obj.x = obj.x - cx
		obj.y = obj.y - cy
		if obj.shadowdraw_func then
			obj.shadowdraw_func()
		else
			obj:preDraw()
			--[[if obj:includes(Player) and obj:isClimbing() then
				obj.climb_state._draw_reticle = false
			end]]
			obj:draw()
			obj:postDraw()
		end
		obj.x = obj.x + cx
		obj.y = obj.y + cy
		obj.visible = vis
	end
	love.graphics.setShader(last_shader_3)
	love.graphics.pop()
end

function SunShadows:castHighlight(obj, arg1)
	love.graphics.push()
	local yoffset = 0
	local xoffset = 0
	local cx = Game.world.camera.x - SCREEN_WIDTH/2
	local cy = Game.world.camera.y - SCREEN_HEIGHT/2
	
	if self.highlight_mode == 0 then
		yoffset = self.darkzone_multiplier
	end
	if self.highlight_mode == 1 then
		xoffset = -self.darkzone_multiplier
	end	
	if arg1 == false or obj.visible then
		local vis = obj.visible
		obj.visible = true
		obj.x = obj.x - cx
		obj.y = obj.y - cy
		if obj.shadowdraw_func then
			obj.shadowdraw_func()
		else
			obj:preDraw()
			--[[if obj:includes(Player) and obj:isClimbing() then
				obj.climb_state._draw_reticle = false
			end]]
			obj:draw()
			obj:postDraw()
		end
		obj.x = obj.x + cx
		obj.y = obj.y + cy
		obj.visible = vis
	end
	love.graphics.pop()
end

function SunShadows:castHighlightCutout(obj)
	love.graphics.push()
	local yoffset = 0
	local xoffset = 0
	local cx = Game.world.camera.x - SCREEN_WIDTH/2
	local cy = Game.world.camera.y - SCREEN_HEIGHT/2
	
	if self.highlight_mode == 0 then
		yoffset = self.darkzone_multiplier
	end
	if self.highlight_mode == 1 then
		xoffset = -self.darkzone_multiplier
	end	
	if arg1 == false or obj.visible then
		obj.x = obj.x - cx
		obj.y = obj.y - cy
		obj.y = obj.y + yoffset
		obj.x = obj.x + xoffset
		if obj.shadowdraw_func then
			obj.shadowdraw_func()
		else
			obj:preDraw()
			--[[if obj:includes(Player) and obj:isClimbing() then
				obj.climb_state._draw_reticle = false
			end]]
			obj:draw()
			obj:postDraw()
		end
		obj.y = obj.y - yoffset
		obj.x = obj.x - xoffset
		obj.x = obj.x + cx
		obj.y = obj.y + cy
	end
	love.graphics.pop()
end

function SunShadows:onRemove(parent)
	super.onRemove(self, parent)
	if self.canv_static_shadows then
		self.canv_static_shadows:release()
		self.canv_static_shadows = nil
	end
	if self.canv_static_cutout then
		self.canv_static_cutout:release()
		self.canv_static_cutout = nil
	end
	if self.canv_static_hcutout then
		self.canv_static_hcutout:release()
		self.canv_static_hcutout = nil
	end
end

function SunShadows:refreshCanvases()
	if self.canv_static_shadows then
		self.canv_static_shadows:release()
		self.canv_static_shadows = nil
	end
	if self.canv_static_cutout then
		self.canv_static_cutout:release()
		self.canv_static_cutout = nil
	end
	if self.canv_static_hcutout then
		self.canv_static_hcutout:release()
		self.canv_static_hcutout = nil
	end
	if not self.canv_static_shadows then
		self.canv_static_shadows = self:generateShadowCanvas(self.tile_layer_names, self.asset_layer_names, self.objects_shadows)
	end
	if not self.canv_static_cutout then
		self.canv_static_cutout = self:generateShadowCanvas(self.cutout_tile_layer_names, self.cutout_asset_layer_names, self.objects_cutout)
	end
	if not self.canv_static_hcutout then
		self.canv_static_hcutout = self:generateShadowCanvas(self.hcutout_tile_layer_names, self.hcutout_asset_layer_names, self.objects_hcutout)
	end
end

function SunShadows:postLoad()
	super.postLoad(self)
	if not self.canv_static_shadows then
		self.canv_static_shadows = self:generateShadowCanvas(self.tile_layer_names, self.asset_layer_names, self.objects_shadows)
	end
	if not self.canv_static_cutout then
		self.canv_static_cutout = self:generateShadowCanvas(self.cutout_tile_layer_names, self.cutout_asset_layer_names, self.objects_cutout)
	end
	if not self.canv_static_hcutout then
		self.canv_static_hcutout = self:generateShadowCanvas(self.hcutout_tile_layer_names, self.hcutout_asset_layer_names, self.objects_hcutout)
	end
end

function SunShadows:setGMBlendMode(blend_mode)
	if not self.can_do_gm_blending then return end
	if blend_mode == "bm_subtract" then
		Ch4Lib.setBlendState("add", "zero", "oneminussrccolor")
	elseif blend_mode == "bm_add" then
		Ch4Lib.setBlendState("add", "srcalpha", "one")
	elseif blend_mode == "bm_normal" then
		Ch4Lib.setBlendState("add", "srcalpha", "oneminussrcalpha")
	end
end

function SunShadows:update()
	super.update(self)
end

function SunShadows:draw()
	super.draw(self)
	local hide_follower_shadows = false --(Game.world.player:isClimbing() or Game.world.player.state == "CLIMB_MOUNT"
	-- or Game.world.player.state == "CLIMB_DISMOUNT" or Game.world.player:isPlatforming()) and true or false
	if not self.canv_static_shadows or not self.canv_static_cutout or not self.canv_static_hcutout then return end
	love.graphics.push()
	local last_shader = love.graphics.getShader()
	local shadow_alpha = 1
	local cx = Game.world.camera.x - SCREEN_WIDTH/2
	local cy = Game.world.camera.y - SCREEN_HEIGHT/2
	local skip_main_characters = false
	local canv_resize = nil
	local canv_dyna_shadows = nil
	local canv_highlights = nil
	if self.resize_mode then
		canv_resize = Draw.pushCanvas(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
		love.graphics.clear()
		love.graphics.push()
		love.graphics.origin()
		if not skip_main_characters then
			if Game.world.player.visible and Game.world.player.alpha > 0 and not hide_follower_shadows then
				self:castShadow(Game.world.player, true)
			end
			for _, follower in ipairs(Game.world.followers) do
				if follower.visible and follower.alpha > 0 and not hide_follower_shadows then
					self:castShadow(follower, true)
				end
			end
		end
		if #self.dropshadow_objects > 0 then
			for _, obj in ipairs(self.dropshadow_objects) do
				if obj and not obj:isRemoved() then
					self:castShadow(obj, true)
				end
			end
		end
		if #self.obj_list > 0 then
			for _, obj in ipairs(self.obj_list) do
				if obj and not obj:isRemoved() then
					self:castShadow(obj, Game:isLight() and true or false)
				end
			end
		end
		love.graphics.pop()
		Draw.popCanvas(true)
	end
	canv_dyna_shadows = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
	love.graphics.clear()
	love.graphics.push()
	love.graphics.origin()
	if not self.can_do_gm_blending then
		love.graphics.stencil(function()
			love.graphics.clear(COLORS.black, 0)
			love.graphics.push()
			local last_shader_2 = love.graphics.getShader()
			love.graphics.setShader(Kristal.Shaders["Mask"])
			for _, cut in ipairs(Game.world:getEvents("dropshadowcut")) do
				if cut then
					Draw.draw(cut.sprite.tex, cut.x - cx, cut.y - cy, cut.rotation, cut.scale_x, cut.scale_y)
				end
			end
			Draw.drawCanvas(self.canv_static_cutout, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
			if not skip_main_characters then
				if Game.world.player.visible and Game.world.player.alpha > 0 and not hide_follower_shadows then
					self:castShadowSelf(Game.world.player, true)
				end
				for _, follower in ipairs(Game.world.followers) do
					if follower.visible and follower.alpha > 0 and not hide_follower_shadows then
						self:castShadowSelf(follower, true)
					end
				end
			end
			if #self.selfshadow_objects > 0 then
				for _, obj in ipairs(self.selfshadow_objects) do
					if obj and not obj:isRemoved() then
						self:castShadowSelf(obj, true)
					end
				end
			end
			love.graphics.setShader(last_shader_2)
			love.graphics.pop()
		end, "replace", 1)
		love.graphics.setStencilTest("less", 1)
	end
	Draw.draw(self.canv_static_shadows, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
	if #self.movingshadow_objects > 0 then -- Needed for the Noelle gate
		for _, obj in ipairs(self.movingshadow_objects) do
			if obj and not obj:isRemoved() then
				self:castShadowSelf(obj, false)
			end
		end
	end
	if self.resize_mode then
		Draw.draw(canv_resize, 0, 0, 0, 2, 2)
	else
		if not skip_main_characters then
			if Game.world.player.visible and Game.world.player.alpha > 0 and not hide_follower_shadows then
				self:castShadow(Game.world.player, true)
			end
			for _, follower in ipairs(Game.world.followers) do
				if follower.visible and follower.alpha > 0 and not hide_follower_shadows then
					self:castShadow(follower, true)
				end
			end
		end
		if #self.dropshadow_objects > 0 then
			for _, obj in ipairs(self.dropshadow_objects) do
				if obj and not obj:isRemoved() then
					self:castShadow(obj, true)
				end
			end
		end
		if #self.obj_list > 0 then
			for _, obj in ipairs(self.obj_list) do
				if obj and not obj:isRemoved() then
					self:castShadow(obj, true)
				end
			end
		end
	end	
	if self.can_do_gm_blending then
		self:setGMBlendMode("bm_subtract")
		for _, cut in ipairs(Game.world:getEvents("dropshadowcut")) do
			if cut then
				Draw.draw(cut.sprite.tex, cut.x - cx, cut.y - cy, cut.rotation, cut.scale_x, cut.scale_y)
			end
		end
		Draw.draw(self.canv_static_cutout, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
		if not skip_main_characters then
			if Game.world.player.visible and Game.world.player.alpha > 0 then
				self:castShadowSelf(Game.world.player, true)
			end
			for _, follower in ipairs(Game.world.followers) do
				if follower.visible and follower.alpha > 0 and not hide_follower_shadows then
					self:castShadowSelf(follower, true)
				end
			end
		end
		if #self.selfshadow_objects > 0 then
			for _, obj in ipairs(self.selfshadow_objects) do
				if obj and not obj:isRemoved() then
					self:castShadowSelf(obj, true)
				end
			end
		end
		love.graphics.setBlendMode("alpha")
	end
	for _, mask in ipairs(Game.world:getEvents("dynamicshadowmask")) do
		if mask then
			mask.alpha = 1 - self.sunlight_alpha
			self:castShadowSelf(mask)
		end
	end
	for _, mask in ipairs(Game.world:getEvents("dynamicshadowmask_slope")) do
		mask.alpha = 1 - self.sunlight_alpha
		self:castShadowSelf(mask)
	end
	if self.can_do_gm_blending then
		self:setGMBlendMode("bm_subtract")
		Draw.draw(self.canv_static_cutout, -cx, -cy, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
		if not skip_main_characters then
			self:castShadowSelf(Game.world.player, true)
			for _, follower in ipairs(Game.world.followers) do
				self:castShadowSelf(follower, true)
			end
		end
		if #self.selfshadow_objects > 0 then
			for _, obj in ipairs(self.selfshadow_objects) do
				if obj and not obj:isRemoved() then
					self:castShadowSelf(obj, true)
				end
			end
		end
		love.graphics.setBlendMode("alpha")
	else
		love.graphics.setStencilTest()
	end
	love.graphics.pop()
	Draw.popCanvas(true)
	if not Game:isLight() then
		canv_highlights = Draw.pushCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)
		love.graphics.clear()
		love.graphics.push()
		love.graphics.origin()
		if not self.can_do_gm_blending then	
			love.graphics.stencil(function()
				love.graphics.clear(COLORS.black, 0)
				love.graphics.push()
				local last_shader_2 = love.graphics.getShader()
				love.graphics.setShader(Kristal.Shaders["Mask"])
				if not skip_main_characters then
					self:castHighlightCutout(Game.world.player, true)
					for _, follower in ipairs(Game.world.followers) do
						self:castHighlightCutout(follower, true)
					end
				end
				if self.marker_mode then
					for _, spr in ipairs(Game.stage:getObjects(Sprite)) do
						if spr and not spr:isRemoved() then
							self:castHighlightCutout(spr, true)
						end
					end
				end
				if #self.highlight_objects > 0 then
					for _, obj in ipairs(self.highlight_objects) do
						if obj and not obj:isRemoved() then
							self:castHighlightCutout(obj, true)
						end
					end
				end
				if self.subtract_highlights then
					Draw.drawCanvas(self.canv_static_cutout, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
					Draw.drawCanvas(self.canv_static_hcutout, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
				end
				love.graphics.setShader(last_shader_2)
				love.graphics.pop()
			end, "replace", 1)
			love.graphics.setStencilTest("less", 1)
		end
		if not skip_main_characters then
			if Game.world.player.visible and Game.world.player.alpha > 0 then
				self:castHighlight(Game.world.player, true)
			end
			for _, follower in ipairs(Game.world.followers) do
				if follower.visible and follower.alpha > 0 and not hide_follower_shadows then
					self:castHighlight(follower, true)
				end
			end
		end
		if self.marker_mode then
			for _, spr in ipairs(Game.stage:getObjects(Sprite)) do
				if spr and not spr:isRemoved() then
					self:castHighlight(spr, true)
				end
			end
		end
		if #self.highlight_objects > 0 then
			for _, obj in ipairs(self.highlight_objects) do
				if obj and not obj:isRemoved() then
					self:castHighlight(obj, true)
				end
			end
		end
		if self.can_do_gm_blending then
			self:setGMBlendMode("bm_subtract")
			if not skip_main_characters then
				if Game.world.player.visible and Game.world.player.alpha > 0 then
					self:castHighlightCutout(Game.world.player, true)
				end
				for _, follower in ipairs(Game.world.followers) do
					if follower.visible and follower.alpha > 0 and not hide_follower_shadows then
						self:castHighlightCutout(follower, true)
					end
				end
			end
			if self.marker_mode then
				for _, spr in ipairs(Game.stage:getObjects(Sprite)) do
					if spr and not spr:isRemoved() then
						self:castHighlightCutout(spr, true)
					end
				end
			end
			if #self.highlight_objects > 0 then
				for _, obj in ipairs(self.highlight_objects) do
					if obj and not obj:isRemoved() then
						self:castHighlightCutout(obj, true)
					end
				end
			end
			if self.subtract_highlights then
				Draw.draw(self.canv_static_cutout, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
				Draw.draw(self.canv_static_hcutout, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
			end
			love.graphics.setBlendMode("alpha")
		else
			love.graphics.setStencilTest()
		end
		love.graphics.pop()
		Draw.popCanvas(true)
	end
	Draw.pushCanvas(canv_dyna_shadows)
	love.graphics.push()
	love.graphics.origin()
	--[[if Game.world.player:isClimbing() then
		self:castShadowSelf(Game.world.player, true)
	end]]
	if self.marker_mode then
		for _, spr in ipairs(Game.stage:getObjects(Sprite)) do
			if spr and not spr:isRemoved() then
				self:castShadowSelf(spr, true)
			end
		end
	end
	if #self.obj_list > 0 then
		for _, obj in ipairs(self.obj_list) do
			if obj and not obj:isRemoved() then
				self:castShadowSelf(obj, true)
			end
		end
	end
	love.graphics.pop()
	Draw.popCanvas(true)
	love.graphics.setShader(self.shadowblend_shader)
	local shadow_col = self.colour_shadowblend
	shadow_col[4] = self.alpha_shadowblend
	self.shadowblend_shader:sendColor("shadowCol", shadow_col)
	Draw.setColor(1,1,1,1 * shadow_alpha)
	Draw.draw(canv_dyna_shadows, cx, cy, 0, 1, 1)
	local shader = Kristal.Shaders["AddColor"]
    love.graphics.setShader(shader)
	local color = {1, 1, 1}
	if self.highlight_mode == 0 then
		if #Game.world:getEvents("parallax_cliffs") > 0 then
			local parallax = Game.world:getEvent("parallax_cliffs")
			if parallax.sun_colour == 0 then
				color = {1, 0.83, 0.36}
			elseif parallax.sun_colour == 2 then
				color = {0.43, 1, 0}
			elseif parallax.sun_colour == 3 then
				color = {0.349, 0.392, 1}
			elseif parallax.sun_colour == 4 then
				color = {1, 0.46, 0.32}
			elseif parallax.sun_colour == 5 then
				color = {0.09, 1, 1}
			elseif parallax.sun_colour == 6 then
				color = {1, 0.88, 0.125}
			elseif parallax.sun_colour == 7 then
				color = {1, 0.325, 0.678}
			end
		elseif not Game:isLight() then
			color = {1, 0.847, 0.435}
		end
	else
		color = {1, 0.4, 0}
	end
    shader:send("inputcolor", color)
    shader:send("amount", 1)
	if not Game:isLight() then
		Draw.setColor(1,1,1,self.sunlight_alpha * 2)
		Draw.draw(canv_highlights, cx, cy, self.rotation, 1, 1)
		Draw.setColor(1,1,1,1)
	end
	love.graphics.setShader(last_shader)
	love.graphics.setStencilTest()
	love.graphics.pop()
end

return SunShadows
