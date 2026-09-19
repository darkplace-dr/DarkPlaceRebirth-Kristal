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
	self.canv_static_topcutout = nil
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
	self.topcutout_tile_layer_names = {}
	self.topcutout_asset_layer_names = {}
	self.objects_shadows = {}
	self.objects_cutout = {}
	self.objects_hcutout = {}
	self.objects_topcutout = {}
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
	self.shadow_generic_tex = Assets.getTexture("world/maps/hometown/shadows/shadow_floor_generic_taller")
	self.shadow_rect_tex = Assets.getTexture("bubbles/fill")
end

function SunShadows:generateShadowCanvas(tiles, assets, objects)
	local resizemultiplier = self.resize_mode and 2 or 1
	local canvas = love.graphics.newCanvas((Game.world.map.width * Game.world.map.tile_width)/resizemultiplier, (Game.world.map.height * Game.world.map.tile_height)/resizemultiplier)
	Draw.pushCanvas(canvas)
	love.graphics.clear()
	love.graphics.push()
	love.graphics.origin()
	love.graphics.scale(self.resize_mode and 0.5 or 1, self.resize_mode and 0.5 or 1)
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
	Draw.popCanvas(true)
	return canvas
end

function SunShadows:drawShadowCast(obj, arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
	if arg0 == 0 or obj.scale_y == 0 then return end
	if not obj.sprite.texture then return end
	local sx = obj.x + obj.sprite.x - Game.world.camera.x - SCREEN_WIDTH/2
	local sy = obj.y + obj.sprite.y - Game.world.camera.y - SCREEN_HEIGHT/2
	local spritedata = obj.sprite
	local width = spritedata.texture:getWidth() * obj.scale_x * arg5
	local height = spritedata.texture:getHeight() / math.abs(arg0)
	local yy = (((arg4 and sy or obj.y + obj.sprite.y)) - (obj.origin_y_exact or (height * obj.origin_y))) * arg5
	local bottom = height + arg2
	local top = bottom - (height * arg0)
	local xx = (((arg4 and sx or obj.x + obj.sprite.x)) - (obj.origin_x_exact or (width * obj.origin_x))) * arg5
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

function SunShadows:setupEveningShadow(obj)
	if not obj.sprite then return false, nil end
    local tex_path = obj.sprite.texture_path
    local tex_name, frame = Assets.getFramesFor(tex_path)
    if not tex_name then tex_name, frame = tex_path, 1 end
    local old_tex_obj ---@type love.Image?

    local actor_spr_path = obj.actor:getSpritePath() or ""
    if actor_spr_path ~= "" then actor_spr_path = actor_spr_path .. "/" end
    local tex_in_actor_spr_path, tex_name_rel = StringUtils.startsWith(tex_name, actor_spr_path)
    if tex_in_actor_spr_path then
        local shadow_sprites = obj.actor:getEveningShadowSprites()
        if shadow_sprites and shadow_sprites[tex_name_rel] then
            local new_frames = Assets.getFramesOrTexture(actor_spr_path .. shadow_sprites[tex_name_rel]) or {}
            if #new_frames > 0 then
                local old_frame_count = #(Assets.getFramesOrTexture(tex_name) or {})
                local progress = old_frame_count <= 1 and 0 or ((frame - 1) / (old_frame_count - 1))
                old_tex_obj = obj.sprite.texture
                obj.sprite:setTextureExact(new_frames[1 + math.floor((#new_frames - 1) * progress)])
				return true, old_tex_obj
            end
        end
    end
	return false, nil
end

function SunShadows:setupEveningFloorShadow(obj)
	if not obj.sprite then return false, nil end
    local tex_path = obj.sprite.texture_path
    local tex_name, frame = Assets.getFramesFor(tex_path)
    if not tex_name then tex_name, frame = tex_path, 1 end
    local old_tex_obj ---@type love.Image?

    local actor_spr_path = obj.actor:getSpritePath() or ""
    if actor_spr_path ~= "" then actor_spr_path = actor_spr_path .. "/" end
    local tex_in_actor_spr_path, tex_name_rel = StringUtils.startsWith(tex_name, actor_spr_path)
    if tex_in_actor_spr_path then
        local floor_shadow_sprites = obj.actor:getEveningFloorShadowSprites()
        if floor_shadow_sprites and floor_shadow_sprites[tex_name_rel] then
            local new_frames = Assets.getFramesOrTexture(actor_spr_path .. floor_shadow_sprites[tex_name_rel]) or {}
            if #new_frames > 0 then
                local old_frame_count = #(Assets.getFramesOrTexture(tex_name) or {})
                local progress = old_frame_count <= 1 and 0 or ((frame - 1) / (old_frame_count - 1))
                old_tex_obj = obj.sprite.texture
                obj.sprite:setTextureExact(new_frames[1 + math.floor((#new_frames - 1) * progress)])
				return true, old_tex_obj
            end
        end
    end
	return false, nil
end

function SunShadows:castShadow(obj, arg1, resize_mode)
	local cx = Game.world.camera.x - SCREEN_WIDTH/2
	local cy = Game.world.camera.y - SCREEN_HEIGHT/2
	local resizemultiplier = resize_mode and 0.5 or 1
	love.graphics.push()
	if self.evening_mode then
		if arg1 == false or obj.visible then
			local has_shadow_sprite, old_tex_obj = self:setupEveningFloorShadow(obj)
			if has_shadow_sprite then
				obj.skip_selfshadowing = true
				if resize_mode then
					obj.drawing_shadow = true
				end
				obj:preDraw()
				local transform = love.graphics.getTransformRef()
				self:applyCameraTransform(transform, resizemultiplier, 1 / CURRENT_SCALE_X, 1 / CURRENT_SCALE_Y)
				love.graphics.replaceTransform(transform)
				if resize_mode then
					love.graphics.translate(obj.sprite.width/2, obj.sprite.height)
				end
				obj:draw()
				obj:postDraw()
				obj.skip_selfshadowing = false
				obj.drawing_shadow = false
				if old_tex_obj then obj.sprite:setTextureExact(old_tex_obj) end
			else
				local ext_width = 0
				if obj.sprite and obj.sprite.walking then
					if obj.sprite.frame % 2 == 0 then
						ext_width = 5
					end
				end
				love.graphics.stencil(function()
					Draw.pushShader("Mask")
					obj.skip_selfshadowing = true
					if resize_mode then
						obj.drawing_shadow = true
					end
					obj:preDraw()
					local transform = love.graphics.getTransformRef()
					self:applyCameraTransform(transform, resizemultiplier, 1 / CURRENT_SCALE_X, 1 / CURRENT_SCALE_Y)
					love.graphics.replaceTransform(transform)
					if resize_mode then
						love.graphics.translate(obj.sprite.width/2, obj.sprite.height)
					end
					obj:draw()
					obj:postDraw()
					obj.skip_selfshadowing = false
					obj.drawing_shadow = false
					-- Need to do this again
					love.graphics.push()
					love.graphics.origin()
					Draw.drawCanvas(self.canv_static_cutout, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
					if #self.selfshadow_objects > 0 then
						for _, obj in ipairs(self.selfshadow_objects) do
							if obj and not obj:isRemoved() then
								self:castShadowSelf(obj, true)
							end
						end
					end
					for _, follower in ipairs(Game.world.followers) do
						if follower.visible and follower.alpha > 0 and not hide_follower_shadows then
							self:castShadowSelf(follower, true)
						end
					end
					if Game.world.player.visible and Game.world.player.alpha > 0 and not hide_follower_shadows then
						self:castShadowSelf(Game.world.player, true)
					end
					love.graphics.pop()
					Draw.popShader()
				end, "replace", 1)
				love.graphics.setStencilTest("less", 1)
				Draw.draw(self.shadow_generic_tex, obj.sprite.x + (obj.width / 2) - (obj.actor and obj.actor.shadow_width or 32), obj.sprite.y + obj.height, 0, 1, 1, 2, 4)
				Draw.draw(self.shadow_rect_tex, obj.sprite.x + (obj.width / 2) - (obj.actor and obj.actor.shadow_width or 32), obj.sprite.y + obj.height - 4, 0, (obj.actor and obj.actor.shadow_width or 32) + ext_width, 4, 0, 0)
				love.graphics.setStencilTest()
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
			obj.x = obj.x - cx/2
			obj.y = obj.y - cy/2
			local objsx, objsy = obj.scale_x, obj.scale_y
			obj:setScale(objsx * resizemultiplier, objsy * resizemultiplier)
			local use_special_shadowcast = true
			local xxx = MathUtils.round(obj.x + (self.skew_amt * dw_amp)) * resizemultiplier
			local yyy = MathUtils.round(obj.y + (obj.height * 2) + adj_y + (obj.height * (1 - self.sunlight_alpha))) * resizemultiplier
			local actor_offset = obj.sprite:includes(ActorSprite) and obj.sprite:getOffset() or {0, 0}
			xxx = MathUtils.round(obj.x + obj.sprite.x) * resizemultiplier
			yyy = MathUtils.round(obj.y - adj_y + obj.sprite.y) * resizemultiplier
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
			love.graphics.translate(-cx/4, -cy/4)
			--local offset = obj.sprite:getOffset() or {0, 0}
			--love.graphics.translate(offset[1]/objsx, offset[2]/objsy)
			if use_special_shadowcast then
				love.graphics.translate(-obj.x/2, -obj.y/2)
				self:drawShadowCast(obj, -1, self.skew_amt, -dw_amp, obj.alpha, false, 1 / dw_amp, true, self.shadow_spritecache, adj_y)
			elseif spr then
				Draw.draw(spr, xxx, yyy, obj.rotation, obj.scale_x, obj.scale_y * -1 * (2 - self.sunlight_alpha), obj.origin_x_exact or (obj.origin_x * obj.sprite.width or spr:getWidth()) - actor_offset[1], obj.origin_y_exact or (obj.origin_y * obj.sprite.height or spr:getHeight()) - actor_offset[2], -math.rad(self.skew_amt), 0)
			end
			obj.x = obj.x + cx/2
			obj.y = obj.y + cy/2
			obj:setScale(objsx, objsy)
		end
	end
	love.graphics.pop()
end

function SunShadows:applyCameraTransform(transform, resize, ceil_x, ceil_y)
    if self.rotation ~= 0 then
        transform:translate(Game.world.camera.width / 2, Game.world.camera.height / 2)
        transform:rotate(Game.world.camera.rotation)
        transform:translate(-Game.world.camera.width / 2, -Game.world.camera.height / 2)
    end

    transform:scale(Game.world.camera.zoom_x * resize, Game.world.camera.zoom_y * resize)

    local shake_x, shake_y = math.ceil(Game.world.camera.shake_x), math.ceil(Game.world.camera.shake_y)
    if Kristal.Config["simplifyVFX"] then
        shake_x, shake_y = 0, 0
    end
    local x, y = Game.world.camera.x + Game.world.camera.ox + shake_x, Game.world.camera.y + Game.world.camera.oy + shake_y
	
    local tw = Game.world.camera.width / Game.world.camera.zoom_x / 2
    local th = Game.world.camera.height / Game.world.camera.zoom_y / 2

    local tx = -x + tw
    local ty = -y + th

    if ceil_x then
        tx = MathUtils.ceilToMultiple(tx, ceil_x / Game.world.camera.zoom_x)
        ty = MathUtils.ceilToMultiple(ty, ceil_y / Game.world.camera.zoom_y)
    end

    transform:translate(tx / 2, ty / 2)
end

function SunShadows:castShadowSelf(obj, arg1)
	love.graphics.push()
	if arg1 == false or obj.visible then
		if obj.shadowdraw_func then
			obj.shadowdraw_func()
		else
			obj.skip_selfshadowing = true
			obj:preDraw()
			love.graphics.replaceTransform(obj:getFullTransform())
			obj:draw()
			obj:postDraw()
			obj.skip_selfshadowing = false
		end
	end
	love.graphics.pop()
end

function SunShadows:castHighlight(obj, arg1)
	love.graphics.push()
	local yoffset = 0
	local xoffset = 0
	if self.highlight_mode == 0 then
		yoffset = self.darkzone_multiplier
	end
	if self.highlight_mode == 1 then
		xoffset = -self.darkzone_multiplier
	end	
	if arg1 == false or obj.visible then
		if obj.highlightdraw_func then
			obj.highlightdraw_func()
		else
			obj.skip_selfshadowing = true
			obj:preDraw()
			love.graphics.replaceTransform(obj:getFullTransform())
			obj:draw()
			obj:postDraw()
			obj.skip_selfshadowing = false
		end
	end
	love.graphics.pop()
end

function SunShadows:castHighlightCutout(obj)
	love.graphics.push()
	local yoffset = 0
	local xoffset = 0
	if self.highlight_mode == 0 then
		yoffset = self.darkzone_multiplier
	end
	if self.highlight_mode == 1 then
		xoffset = -self.darkzone_multiplier
	end
	if arg1 == false or obj.visible then
		local objx, objy = obj.x, obj.y
		obj.x = obj.x + xoffset
		obj.y = obj.y + yoffset
		if obj.highlightcutoutdraw_func then
			obj.highlightcutoutdraw_func()
		else
			obj.skip_selfshadowing = true
			obj:preDraw()
			love.graphics.replaceTransform(obj:getFullTransform())
			obj:draw()
			obj:postDraw()
			obj.skip_selfshadowing = false
		end
		obj.x = objx
		obj.y = objy
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
	if self.canv_static_topcutout then
		self.canv_static_topcutout:release()
		self.canv_static_topcutout = nil
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
	if self.canv_static_topcutout then
		self.canv_static_topcutout:release()
		self.canv_static_topcutout = nil
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
	if not self.canv_static_topcutout then
		self.canv_static_topcutout = self:generateShadowCanvas(self.topcutout_tile_layer_names, self.topcutout_asset_layer_names, self.objects_topcutout)
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
	if not self.canv_static_topcutout then
		self.canv_static_topcutout = self:generateShadowCanvas(self.topcutout_tile_layer_names, self.topcutout_asset_layer_names, self.objects_topcutout)
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
	if not self.canv_static_shadows or not self.canv_static_cutout or not self.canv_static_hcutout or not self.canv_static_topcutout then return end
	love.graphics.push()
	local shadow_alpha = 1
	local overcast_alpha = 0
	if Game.stage.weather then
		for i, w in ipairs(Game.stage.weather) do
			if w.type == "rain" or w.type == "rain_prewarmed" or w.type == "overcast" then
				shadow_alpha = 1 - (w.weathertimer / 120)
				overcast_alpha = (w.weathertimer / 120) * 0.5
			end
		end
	end
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
				self:castShadow(Game.world.player, true, true)
			end
			for _, follower in ipairs(Game.world.followers) do
				if follower.visible and follower.alpha > 0 and not hide_follower_shadows then
					self:castShadow(follower, true, true)
				end
			end
		end
		if #self.dropshadow_objects > 0 then
			for _, obj in ipairs(self.dropshadow_objects) do
				if obj and not obj:isRemoved() then
					self:castShadow(obj, true, true)
				end
			end
		end
		if #self.obj_list > 0 then
			for _, obj in ipairs(self.obj_list) do
				if obj and not obj:isRemoved() then
					self:castShadow(obj, Game:isLight() and true or false, true)
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
	love.graphics.stencil(function()
		love.graphics.clear(COLORS.black, 0)
		Draw.pushShader("Mask")
		--[[for _, cut in ipairs(Game.world:getEvents("dropshadowcut")) do
			if cut then
				Draw.draw(cut.sprite.tex, cut.x - cx, cut.y - cy, cut.rotation, cut.scale_x, cut.scale_y)
			end
		end]]
		Draw.drawCanvas(self.canv_static_cutout, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
		if not skip_main_characters then
			for _, follower in ipairs(Game.world.followers) do
				if follower.visible and follower.alpha > 0 and not hide_follower_shadows then
					self:castShadowSelf(follower, true)
				end
			end
			if Game.world.player.visible and Game.world.player.alpha > 0 and not hide_follower_shadows then
				self:castShadowSelf(Game.world.player, true)
			end
		end
		if #self.selfshadow_objects > 0 then
			for _, obj in ipairs(self.selfshadow_objects) do
				if obj and not obj:isRemoved() then
					self:castShadowSelf(obj, true)
				end
			end
		end
		Draw.popShader()
	end, "replace", 1)
	love.graphics.stencil(function()
		Draw.pushShader("Mask")
		Draw.drawCanvas(self.canv_static_topcutout, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
		Draw.popShader()
	end, "decrement", 1, true)
	love.graphics.setStencilTest("less", 1)
	Draw.drawCanvas(self.canv_static_shadows, -cx, -cy, 0, self.resize_mode and 2 or 1, self.resize_mode and 2 or 1)
	if #self.movingshadow_objects > 0 then -- Needed for the Noelle gate
		for _, obj in ipairs(self.movingshadow_objects) do
			if obj and not obj:isRemoved() then
				self:castShadowSelf(obj, false)
			end
		end
	end
	if self.resize_mode and not self.evening_mode then
		Draw.drawCanvas(canv_resize, 0, 0, 0, 2, 2)
	else
		if not skip_main_characters then
			if Game.world.player.visible and Game.world.player.alpha > 0 and not hide_follower_shadows then
				self:castShadow(Game.world.player, true, false)
			end
			for _, follower in ipairs(Game.world.followers) do
				if follower.visible and follower.alpha > 0 and not hide_follower_shadows then
					self:castShadow(follower, true, false)
				end
			end
		end
		if #self.dropshadow_objects > 0 then
			for _, obj in ipairs(self.dropshadow_objects) do
				if obj and not obj:isRemoved() then
					self:castShadow(obj, true, false)
				end
			end
		end
		if #self.obj_list > 0 then
			for _, obj in ipairs(self.obj_list) do
				if obj and not obj:isRemoved() then
					self:castShadow(obj, true, false)
				end
			end
		end
	end	
	--[[for _, mask in ipairs(Game.world:getEvents("dynamicshadowmask")) do
		if mask then
			mask.alpha = 1 - self.sunlight_alpha
			self:castShadowSelf(mask, nil, false)
		end
	end
	for _, mask in ipairs(Game.world:getEvents("dynamicshadowmask_slope")) do
		mask.alpha = 1 - self.sunlight_alpha
		self:castShadowSelf(mask, nil, false)
	end]]
	love.graphics.setStencilTest()
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
				Draw.pushShader("Mask")
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
				Draw.popShader()
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
	Draw.pushShader(self.shadowblend_shader)
	local shadow_col = self.colour_shadowblend
	shadow_col[4] = self.alpha_shadowblend
	self.shadowblend_shader:sendColor("shadowCol", shadow_col)
	Draw.setColor(1,1,1,1 * shadow_alpha)
	Draw.draw(canv_dyna_shadows, cx, cy, 0, 1, 1)
	Draw.setColor(1,1,1,1 * overcast_alpha)
	love.graphics.rectangle("fill", cx, cy, SCREEN_WIDTH, SCREEN_HEIGHT)
	Draw.popShader()
	local shader = Kristal.Shaders["AddColor"]
    Draw.pushShader(shader)
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
	Draw.popShader()
	love.graphics.setStencilTest()
	love.graphics.pop()
end

return SunShadows
