---@class Event.rotatingtower : Event
local RotatingTower, super = Class(Event, "rotatingtower")

function RotatingTower:init(data)
    super.init(self, data)
	local properties = data and data.properties or {}
	self.tower_width = properties["width"] or 280
	self.appearance = properties["appearance"] or 0
	self.use_tilesets = properties["usetiles"] ~= false
	self.tileset_name = TiledUtils.parsePropertyList("tilelayer", properties)
	self.collision_name = properties["collisionlayer"] or "collision_tower"
	self.background_name = TiledUtils.parsePropertyList("bglayer", properties)
	self.verticaltilecount = properties["verttiles"] or 500
	self.tower_angle = properties["angle"] or 130.91
	self.tower_angle_fine_tune = properties["anglefine"] or 0
	self.use_collision_map = properties["usecollision"] ~= false
	self.use_background_map = properties["usebg"] ~= false
	self.offset_reticle_x = properties["retoffx"] or 0
	self.endclimb = false
	self.endclimbtimer = 0
	self.tower_x = self.x or 320
	self.tower_y = self.y or 0
	self.player_starting_y = 320
	self.destroy_climbstarter = true
	self.turnobjectsintotilevariants = true
	self.tiledefaultclimbable = true
	self.cull_objects = false
	self.tile_dark_color = properties["darkcol"] and TiledUtils.parseColorProperty(properties["darkcol"]) or COLORS.gray
	self.col_blend = 1
	self.visible_indices = {}
	self.backface_indices = {}
	self.tower_xshake = 0
	self.tower_yshake = 0
	self.tower_angle_prev = nil
	self.tower_angle_prev2 = nil
	self.tile_width = 40
	self.tile_height = 40
	self.tile_width_fine = self.tile_width
	self.tile_height_fine = self.tile_height
	if self.appearance == 1 then
		self.tile_width_fine = self.tile_width_fine * 0.5
		self.tile_height_fine = self.tile_height_fine * 0.5
	end
	self.tower_height = self.verticaltilecount * self.tile_height_fine
	self.tower_radius = self.tower_width / 2
	self.tower_circumference = (2 * math.pi) * self.tower_radius
	self.tower_ystart = self.tower_y
	self.tower_y_prev = self.tower_y
	self.maincharayprevious = nil
	self.towertype = 0
	self.timer = 0
	self.angle_extra = 0
	self.checkdamagefloor = 0
	self.krisx = 0
	self.krisy = 0
	self.kristilex = 1
	self.kristiley = 1
	self.px = 0
	self.py = 0
	self.reticle = 0
	self.found = 0
	self.dodraw = false
	self.tower_circumference = MathUtils.round(self.tower_circumference)
	if self.tower_circumference % self.tile_width_fine ~= 0 then
		for i = 0, self.tile_width_fine do
			self.tower_circumference = self.tower_circumference + 1
			if self.tower_circumference % self.tile_width_fine == 0 then
				break
			end
		end
		self.tower_radius = self.tower_circumference / (2 * math.pi)
		self.tower_width = self.tower_radius * 2
	end
	self.horizontaltilecount = self.tower_circumference / self.tile_width_fine
	self.tile_angle_difference = 360 / self.horizontaltilecount
	self.tm_background = {}
	self.tm_tileset = {}
	self.tile_data = {}
	self.tile_id_data = {}
	self.tower_angle_record = {}
	self.yoffset_record = {}
	self.valid_tile_indices = {}
	for iii = 0, 75 do
		table.insert(self.tower_angle_record, self.tower_angle)
		table.insert(self.yoffset_record, self.tower_y)
	end
	self.using_rotating_caterpillars = false
	self.tower_angle_add = 0
    self.gradient40 = Assets.getTexture("backgrounds/gradient40")
	Game.world.map.cyltower = self
	self.x = 0
	self.y = 0
end

function RotatingTower:getTileIndex(x,y)
    return x + (y * self.horizontaltilecount) + 1
end

function RotatingTower:postLoad()
	self.tm_tileset = {}
	self.tile_data = {}
	self.tile_id_data = {}
	local a = 16
	if self.use_tilesets then
		for _, layer in ipairs(self.tileset_name) do
			local layer_id = self.world.map:getTileLayer(layer)
			if layer_id then
				layer_id.visible = false
				table.insert(self.tm_tileset, layer_id)
				self.tile_data[layer_id] = {}
				self.tile_id_data[layer_id] = {}
				for ii = 0, self.verticaltilecount do
					for i = 0, self.horizontaltilecount + 1 do
						local tile = layer_id:getTile(i, math.floor(self.tower_y / self.tile_height) + ii)
						local index = i + (ii * layer_id.map_width) + 1
						if #self.valid_tile_indices == 0 or self.valid_tile_indices[#self.valid_tile_indices] ~= self:getTileIndex(i, ii) then
							table.insert(self.valid_tile_indices, self:getTileIndex(i, ii))
						end
						self.tile_data[layer_id][i + 1] = {vis = 0, x = 0, angle = 360 - ((i + a) * (360 / self.horizontaltilecount)), xscale = 1, color = COLORS.white}
						self.tile_id_data[layer_id][self:getTileIndex(i, ii)] = layer_id.tile_data[index]
					end
				end
			end
		end
	end
	if self.use_collision_map then
		--local layer_id = Game.world.map:loadHitboxes(self.collision_name)
		--self.tm_collision = layer_id
	end
	if self.use_background_map then
		for _, layer in ipairs(self.background_name) do
			local layer_id = self.world.map:getTileLayer(layer)
			table.insert(self.tm_background, layer_id)
		end
	end
	self.tower_angle_prev = nil
	self.tower_angle_prev2 = nil
	self.maincharayprevious = Game.world.player.y
	self.reticle_drawer = RotatingTowerReticleDrawer(self)
	self.reticle_drawer.layer = Game.world.player and Game.world.player.layer or self.layer
	Game.world:addChild(self.reticle_drawer)
end

function RotatingTower:update()
    super.update(self)
	if self.world and self.world.player then
		local px, py = self.world.player:getRelativePos(0, 0)
		self.krisx = self.tower_x
		self.krisy = self.world.player.y
		if (self.world.player.state == "CLIMB" or self.world.player.state == "CLIMBSLIP") and self.world.player.onrotatingtower then
			local adjustment = self.tower_x - self.tower_angle_fine_tune
			local last_angle = self.tower_angle
			self.tower_angle = MathUtils.lerp(0, 360, (px - adjustment) / self.tower_circumference)
			self.tower_angle = (self.tower_angle + 360) % 360
			
			if math.abs(self.tower_angle - last_angle) > 100 then
				self.tower_angle_add = self.tower_angle_add + (360 * MathUtils.sign(self.tower_angle - last_angle))
			end
			
			--self.tower_y = MathUtils.lerp(self.tower_ystart, self.tower_height, py / self.tower_height)
		end
		self.kristilex = (px / self.tile_width_fine) + 1
		self.kristiley = py / self.tile_height_fine
		if self.kristiley > self.verticaltilecount - 1 then
			self.kristiley = self.verticaltilecount - 1
		end
		if self.kristilex > self.horizontaltilecount then
			self.kristilex = self.kristilex - self.horizontaltilecount
		end
		if self.kristilex < 0 then
			self.kristilex = self.kristilex + self.horizontaltilecount
		end
	end
	if self.endclimb then
		self.endclimbtimer = self.endclimbtimer + DTMULT
	end
	if self.tower_angle ~= self.tower_angle_prev2 then
		self.tower_angle_prev2 = self.tower_angle
		self.visible_indices = {}
		self.backface_indices = {}
		for _, layer in ipairs(self.tm_tileset) do
			for i = 0, self.horizontaltilecount do
				local xid = self.tile_data[layer][i + 1]
				local tile_angle1 = xid.angle + self.tower_angle
				if tile_angle1 >= 360 then
					tile_angle1 = tile_angle1 - 360
				elseif tile_angle1 < 0 then
					tile_angle1 = tile_angle1 + 360
				end
				if self.appearance < 2 then
					xid.vis = (tile_angle1 > 350 or tile_angle1 <= 170) and 1 or 0
				else			
					xid.vis = (tile_angle1 >= 345 or tile_angle1 <= 165) and 1 or 0
				end
				if self.appearance == 1 and xid.vis == 0 and (tile_angle1 >= 340 or tile_angle1 <= 190) then
					xid.vis = 2
				end
				if xid.vis ~= 0 then
					xid.x = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle1))
					local tile_angle2 = tile_angle1 + self.tile_angle_difference
					if tile_angle2 > 360 then
						tile_angle2 = tile_angle2 - 360
					elseif tile_angle2 < 0 then
						tile_angle2 = tile_angle2 + 360
					end
					xid.xscale = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle2)) - xid.x
					xid.color = ColorUtils.mergeColor(COLORS.white, self.tile_dark_color, self.col_blend * MathUtils.clamp(math.abs(xid.x + (xid.xscale * 0.5)) / 190, 0, 1))
					if xid.vis == 1 then
						table.insert(self.visible_indices, i)
					elseif xid.vis == 2 then
						table.insert(self.backface_indices, i)
					end
				end
			end
		end
	end
	if self.use_background_map then
		for _, layer in ipairs(self.tm_background) do
			layer.x = -360 + ((self.tower_angle + 360) % 360)
		end
	end
end

function RotatingTower:drawGridTile(layer, xid, id, x, y, col, pos, tileset, gw, gh, flip_x, flip_y, flip_diag)
    local draw_id = tileset:getDrawTile(id)
	local w, h = tileset:getTileSize(draw_id)

    x, y = x or 0, y or 0
    gw, gh = gw or w, gh or h

    local rot = 0
    if flip_diag then
        flip_y = not flip_y
        rot = -math.pi / 2
    end

    local sx, sy = 1, 1
    if tileset.fill_grid and gw and gh and (w ~= gw or h ~= gh) then
        sx = gw / w
        sy = gh / h
        if tileset.preserve_aspect_fit then
            sx = MathUtils.absMin(sx, sy)
            sy = sx
        end
    end
	sx = sx * ((-xid.xscale) / gw)

    local ox, oy = (w * sx) / 2, gh - (h * sy) / 2

    local info = tileset.tile_info[draw_id]
	Draw.setColor(col)
    if info and info.texture then
        if not info.quad then
            Draw.draw(info.texture, (x or 0) + ox, (y or 0) + oy, rot, flip_x and -sx or sx, flip_y and -sy or sy, w / 2, h / 2)
        else
            Draw.draw(info.texture, info.quad, (x or 0) + ox, (y or 0) + oy, rot, flip_x and -sx or sx, flip_y and -sy or sy, w / 2, h / 2)
        end
    else
        Draw.draw(tileset.texture, tileset.quads[draw_id], (x or 0) + ox, (y or 0) + oy, rot, flip_x and -sx or sx, flip_y and -sy or sy, w / 2, h / 2)
    end
end

function RotatingTower:draw()
    super.draw(self)
	local camy = (Game.world.camera.y - SCREEN_HEIGHT/2) - self.tower_y
	local render_ypos = MathUtils.round(camy / self.tile_height_fine)
	local render_ypos_start = render_ypos - 1
	local render_ypos_end = render_ypos + 25
	if render_ypos_start < 0 then
		render_ypos_start = 0
	end
	if render_ypos_end > self.verticaltilecount then
		render_ypos_end = self.verticaltilecount
	end
	self.tower_x = self.tower_x + self.tower_xshake
	self.tower_y = self.tower_y + self.tower_yshake
	for _, event in ipairs(self.world.map.events) do
		if event and event.climb_obstacle then
			if event.id == "ClimbCoin" then	
				local adjustment = -260
				if self.appearance == 1 then
					adjustment = -520
				end
				local coin_angle_pos =  MathUtils.lerp(360, 0, (event.x + adjustment) / self.tower_circumference)
				local coin_angle = coin_angle_pos + self.tower_angle
				if coin_angle > 360 then
					coin_angle = coin_angle - 360
				elseif coin_angle < 0 then
					coin_angle = coin_angle + 360
				end
				if not (coin_angle > 350 or coin_angle <= 170) then
					self:drawTowerCoin(event, coin_angle)
				end
			end
		end
	end
	for _, text in ipairs(Game.stage:getObjects(Text)) do
		if text and text.onrotatingtower then
			local adjustment = -260
			if self.appearance == 1 then
				adjustment = -520
			end
			local text_angle_pos =  MathUtils.lerp(360, 0, (text.x + adjustment) / self.tower_circumference)
			local text_angle = text_angle_pos + self.tower_angle
			if text_angle > 360 then
				text_angle = text_angle - 360
			elseif text_angle < 0 then
				text_angle = text_angle + 360
			end
			if not (text_angle > 350 or text_angle <= 170) then
				self:drawTowerText(text, text_angle)
			end
		end
	end
	if self.use_tilesets then
		local cx = 0
		local cy = 0
		local statictile = nil
		local statictilecount = nil
		local staticyoffset = 760
		for _, layer in ipairs(self.tm_tileset) do
			for i = 1, #self.valid_tile_indices do
				local pos = self.valid_tile_indices[i]
				local k = (pos % self.horizontaltilecount) + 1
				local ii = math.floor(pos / self.horizontaltilecount)
				local xid = self.tile_data[layer][k]
				local xid2 = self.tile_id_data[layer][self:getTileIndex(k - 1, ii)]

				if xid and xid2 then
					local gid, flip_x, flip_y, flip_diag = TiledUtils.parseTileGid(xid2)
					local tileset, id = self.world.map:getTileset(gid)
					if tileset and xid.vis == 1 and ii >= render_ypos_start and ii <= render_ypos_end then
						Draw.setColor(xid.color)
						local xx = (self.tower_x - self.tower_xshake) + xid.x + (xid.xscale)
						local yy = (self.tile_height_fine * ii) + self.tower_ystart + 10
						self:drawGridTile(layer, xid, id, xx - cx, yy - cy, col, pos, tileset, self.tile_width_fine, self.tile_height_fine, flip_x, flip_y, flip_diag)
					end 
				end
			end
		end
	end
	local cull_top = render_ypos_start * self.tile_height_fine
	local cull_bottom = render_ypos_end * self.tile_height_fine
	local xscale_scaled = 1 / self.tile_width_fine
	for _, event in ipairs(self.world.map.events) do
		if event and event.climb_obstacle then
			if event.id == "ClimbWaterBucket" then
				local tilex = math.floor((event.x * xscale_scaled) + 1)
				if tilex > self.horizontaltilecount - 1 then
					tilex = tilex - self.horizontaltilecount - 1
				elseif tilex < 0 then
					tilex = tilex + self.horizontaltilecount - 1
				end
				local tile = self.tile_data[self.tm_tileset[1]][tilex - 1]
				if tile.vis == 1 then
					Draw.setColor(tile.color)
					if event.generator then
						Draw.draw(event.sprite.texture, self.tower_x + event.graphics.shake_x + tile.x, event.y + event.graphics.shake_y, 0, (tile.xscale * 2) / self.tile_width_fine, -2, 0, 10)
						if event.drawwater > 0 then
							local sprite = Assets.getFrames("world/events/climbwater/climb_waterbucket_splash")
							local frame = math.floor(#sprite - (event.drawwater / 3)) + 1
							Draw.draw(sprite[frame], self.tower_x + event.graphics.shake_x + tile.x, event.y + event.graphics.shake_y, 0, (tile.xscale * 2) / self.tile_width_fine, 2.2, 0, 13)
						end
					else
						Draw.draw(event.sprite.texture, self.tower_x + event.graphics.shake_x + tile.x, event.y + event.graphics.shake_y, 0, (tile.xscale * 2) / self.tile_width_fine, 2.2, 0, 10)
						if event.drawwater > 0 then
							local sprite = Assets.getFrames("world/events/climbwater/climb_waterbucket_splash")
							local frame = math.floor(#sprite - (event.drawwater / 3)) + 1
							Draw.draw(sprite[frame], self.tower_x + event.graphics.shake_x + tile.x, event.y + event.graphics.shake_y, 0, (tile.xscale * 2) / self.tile_width_fine, 2.2, 0, 13)
						end
					end
				end
			elseif event.id == "ClimbEnemy" then
				local adjustment = -260
				if self.appearance == 1 then
					adjustment = -520
				end
				local tile_angle = MathUtils.lerp(360, 0, (event.x + adjustment) / self.tower_circumference)
				local tile_angle1 = tile_angle + self.tower_angle
				while tile_angle1 > 360 do
					tile_angle1 = tile_angle1 - 360
				end
				if tile_angle1 < 0 then
					tile_angle1 = tile_angle1 + 360
				end
				if not (tile_angle1 > 350 or tile_angle1 <= 170) then
					-- end here
				else
					local tile_x = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle1))
					local tile_angle2 = tile_angle1 + self.tile_angle_difference
					if tile_angle2 > 360 then
						tile_angle2 = tile_angle2 - 360
					elseif tile_angle2 < 0 then
						tile_angle2 = tile_angle2 + 360
					end
					local tile_xscale = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle2)) - tile_x
					local tile_yscale = self.tile_height_fine
					tile_xscale = tile_xscale / self.tile_width_fine
					tile_yscale = tile_yscale / self.tile_height_fine
					local tile_color = ColorUtils.mergeColor(COLORS.white, COLORS.gray, math.abs(tile_x + (tile_xscale / 2)) / 190)
					local event_canvas = Draw.pushCanvas(event.sprite.width, event.sprite.height)
					Draw.setColor(1,1,1,event.alpha)
					Draw.draw(event.sprite.texture, event.sprite.width/2, event.sprite.height/2, -event.sprite.rotation, 1, 1, event.sprite.width/2, event.sprite.height/2)
					Draw.popCanvas()
					Draw.setColor(tile_color)
					Draw.drawCanvas(event_canvas, self.tower_x + event.graphics.shake_x + tile_x, event.y + event.graphics.shake_y - 20, 0, tile_xscale, tile_yscale, ox, oy)
				end
			elseif event.id == "DestructableClimbArea" then
				for i = 1, event.tiles_x do
					for j = 1, event.tiles_y do
						local xoff = 0
						local yoff = 0
						if event.con == 2 then
							local falamt = math.abs(event.y - event.y_start) / 10
							if j % 2 == 0 then
								falamt = -falamt
							end
							xoff = (math.sin(event.siner + ((i + j) * event.con * 80)) * 2) + falamt
							yoff = math.sin(event.siner + ((i + j) * event.con * 60)) * 2
							local adjustment = -260
							if self.appearance == 1 then
								adjustment = -520
							end
							local tile_angle = MathUtils.lerp(360, 0, ((event.x + 20 + xoff + (i - 1) * 40) + adjustment) / self.tower_circumference)
							local tile_angle1 = tile_angle + self.tower_angle
							while tile_angle1 > 360 do
								tile_angle1 = tile_angle1 - 360
							end
							if tile_angle1 < 0 then
								tile_angle1 = tile_angle1 + 360
							end
							if not (tile_angle1 > 350 or tile_angle1 <= 170) then
								-- end here
							else
								local tile_x = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle1))
								local tile_angle2 = tile_angle1 + self.tile_angle_difference
								if tile_angle2 > 360 then
									tile_angle2 = tile_angle2 - 360
								elseif tile_angle2 < 0 then
									tile_angle2 = tile_angle2 + 360
								end
								local tile_xscale = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle2)) - tile_x
								local tile_yscale = self.tile_height_fine
								tile_xscale = tile_xscale / self.tile_width_fine
								tile_yscale = tile_yscale / self.tile_height_fine
								local tile_color = ColorUtils.mergeColor(COLORS.white, COLORS.gray, math.abs(tile_x + (tile_xscale / 2)) / 190)
								Draw.setColor(tile_color)
								Draw.draw(event.sprite_tex, self.tower_x + event.graphics.shake_x + tile_x, event.y + event.graphics.shake_y + yoff + (j - 1) * 40 + 10, 0, tile_xscale * 2, 2)
							end
						else
							local tilex = math.floor(((event.x + 40 + (i - 1) * 40) * xscale_scaled) + 1)
							if tilex > self.horizontaltilecount - 1 then
								tilex = tilex - self.horizontaltilecount - 1
							elseif tilex < 0 then
								tilex = tilex + self.horizontaltilecount - 1
							end
							local tile = self.tile_data[self.tm_tileset[1]][tilex - 1]
							if tile.vis == 1 then
								Draw.setColor(tile.color)
								Draw.draw(event.sprite_tex, self.tower_x + event.graphics.shake_x + tile.x, event.y + event.graphics.shake_y + (j - 1) * 40 + 30, 0, (tile.xscale * 2) / self.tile_width_fine, 2, 0, 10)
							end
						end
					end
				end
			elseif event.id == "ClimbCoin" then	
				local adjustment = -260
				if self.appearance == 1 then
					adjustment = -520
				end
				local tile_angle = MathUtils.lerp(360, 0, (event.x + 20 + adjustment) / self.tower_circumference)
				local tile_angle1 = tile_angle + self.tower_angle
				while tile_angle1 > 360 do
					tile_angle1 = tile_angle1 - 360
				end
				if tile_angle1 < 0 then
					tile_angle1 = tile_angle1 + 360
				end
				if not (tile_angle1 > 350 or tile_angle1 <= 170) then
					-- end here
				else
					local tile_x = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle1))
					local tile_angle2 = tile_angle1 + self.tile_angle_difference
					if tile_angle2 > 360 then
						tile_angle2 = tile_angle2 - 360
					elseif tile_angle2 < 0 then
						tile_angle2 = tile_angle2 + 360
					end
					local tile_xscale = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle2)) - tile_x
					local tile_yscale = self.tile_height_fine
					tile_xscale = tile_xscale / self.tile_width_fine
					tile_yscale = tile_yscale / self.tile_height_fine
					local brightcol = ColorUtils.mergeColor(COLORS.white, COLORS.gray, math.abs(tile_x + (tile_xscale / 2)) / 190)
					local darkcol = ColorUtils.mergeColor(COLORS.gray, COLORS.dkgray, math.abs(tile_x + (tile_xscale / 2)) / 190)
					local tile_color = ColorUtils.mergeColor(brightcol, darkcol, event.bowlindex/15)
					local sinamt = math.sin(event.siner / 20) * 6 * MathUtils.clamp(1 - (event.bowlindex / 7), 0, 1)
					Draw.setColor(tile_color)
					Draw.draw(event.sprite_tex[(math.floor(event.bowlindex)%6)+1], self.tower_x + event.graphics.shake_x + tile_x, event.y + 10 + event.graphics.shake_y - sinamt, 0, tile_xscale * 2, tile_yscale * 2, ox, oy)
				end
			elseif event.id == "ClimbSwitch" then
				local tilex = math.floor(((event.x + 40) * xscale_scaled) + 1)
				if tilex > self.horizontaltilecount - 1 then
					tilex = tilex - self.horizontaltilecount - 1
				elseif tilex < 0 then
					tilex = tilex + self.horizontaltilecount - 1
				end
				local tile = self.tile_data[self.tm_tileset[1]][tilex - 1]
				if tile.vis == 1 then
					Draw.setColor(tile.color)
					Draw.draw(event.sprite.texture, self.tower_x + event.graphics.shake_x + tile.x, event.y + 10 + event.graphics.shake_y, 0, (tile.xscale * 2) / self.tile_width_fine, 2, 0, 0)
				end
			elseif event.id == "ClimbMover" then
				local adjustment = -260
				if self.appearance == 1 then
					adjustment = -520
				end
				local tile_angle = MathUtils.lerp(360, 0, (event.x + adjustment) / self.tower_circumference)
				local tile_angle1 = tile_angle + self.tower_angle
				while tile_angle1 > 360 do
					tile_angle1 = tile_angle1 - 360
				end
				if tile_angle1 < 0 then
					tile_angle1 = tile_angle1 + 360
				end
				if not (tile_angle1 > 350 or tile_angle1 <= 170) then
					-- end here
				else
					local tile_x = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle1))
					local tile_angle2 = tile_angle1 + self.tile_angle_difference
					if tile_angle2 > 360 then
						tile_angle2 = tile_angle2 - 360
					elseif tile_angle2 < 0 then
						tile_angle2 = tile_angle2 + 360
					end
					local tile_xscale = MathUtils.lengthDirX(self.tower_radius, -math.rad(tile_angle2)) - tile_x
					local tile_yscale = self.tile_height_fine
					tile_xscale = tile_xscale / self.tile_width_fine
					tile_yscale = tile_yscale / self.tile_height_fine
					local tile_color = ColorUtils.mergeColor(COLORS.white, COLORS.gray, math.abs(tile_x + (tile_xscale / 2)) / 190)
					Draw.setColor(tile_color)
					Draw.draw(event.sprite.texture, self.tower_x + event.graphics.shake_x + tile_x, event.y + event.graphics.shake_y - 20, 0, tile_xscale, tile_yscale, ox, oy)
				end
			else
				local ox, oy = event:getOriginExact()
				local adjustment = 1
				if self.appearance == 1 then
					adjustment = 3
				end
				local tilex = math.floor((event.x * xscale_scaled) + adjustment)
				if tilex > self.horizontaltilecount - 1 then
					tilex = tilex - self.horizontaltilecount - 1
				elseif tilex < 0 then
					tilex = tilex + self.horizontaltilecount - 1
				end
				local tile = self.tile_data[self.tm_tileset[1]][tilex - 1]
				if tile.vis == 1 then
					Draw.setColor(tile.color)
					Draw.draw(event.sprite.texture, self.tower_x + event.graphics.shake_x + tile.x, event.y + event.graphics.shake_y, 0, (tile.xscale * event.scale_x) / self.tile_width_fine, event.scale_y, ox, oy)
				end
			end
		end
	end
	for _, flash in ipairs(Game.stage:getObjects(FlashFadeTower)) do
		if flash then
			local ox, oy = flash:getOriginExact()
			local tilex = math.floor((flash.x * xscale_scaled) + 1)
			if tilex > self.horizontaltilecount - 1 then
				tilex = tilex - self.horizontaltilecount - 1
			elseif tilex < 0 then
				tilex = tilex + self.horizontaltilecount - 1
			end
			local xoff = flash.x % self.tile_width_fine
			local tile = self.tile_data[self.tm_tileset[1]][tilex - 1]
			if tile.vis == 1 then
				Draw.setColor(tile.color)
				local last_shader = love.graphics.getShader()
				local shader = Kristal.Shaders["AddColor"]
				love.graphics.setShader(shader)
				shader:send("inputcolor", COLORS.white)
				shader:send("amount", flash.alpha)
				Draw.draw(flash.texture, self.tower_x + flash.graphics.shake_x + tile.x + xoff, flash.y + flash.graphics.shake_y, 0, (tile.xscale * flash.scale_x) / self.tile_width_fine, flash.scale_y, ox, oy)
				shader:send("amount", 1)
				love.graphics.setShader(last_shader)
			end
		end
	end
	for _, cuthalf in ipairs(Game.stage:getObjects(AfterImageCutHalfTower)) do
		if cuthalf then
			local ox, oy = cuthalf:getOriginExact()
			local tilex = math.floor((cuthalf.x * xscale_scaled) + 1)
			if tilex > self.horizontaltilecount - 1 then
				tilex = tilex - self.horizontaltilecount - 1
			elseif tilex < 0 then
				tilex = tilex + self.horizontaltilecount - 1
			end
			local xoff = cuthalf.x % self.tile_width_fine
			local tile = self.tile_data[self.tm_tileset[1]][tilex - 1]
			if tile.vis == 1 then
				local x = self.tower_x + cuthalf.graphics.shake_x + tile.x - 20 
				if cuthalf.flash then
					cuthalf.flash = false
				else
					local r, g, b, a = cuthalf:getDrawColor()
					
					local hw = cuthalf.width/2
					local hh = cuthalf.height/2

					local m = Utils.ease(0, hh, (cuthalf.siner + 2)/10, "out-sine")
					love.graphics.setColor(r, g, b, cuthalf.spr_alpha)
					
					Draw.drawPart(cuthalf.texture, x - (cuthalf.width / 2), (cuthalf.y - m) - ((cuthalf.yo * cuthalf.scale_y) / 2), 0, 0, hw * 2, hh, ox, oy)
					Draw.drawPart(cuthalf.texture, x - (cuthalf.width / 2), (cuthalf.y + m) - ((cuthalf.yo * cuthalf.scale_y) / 2), 0, hh, hw * 2, hh, ox, oy)
				end
			end
		end
	end
	if self.appearance == 0 then
		Draw.setColor(0,0,0,0.6 * self.col_blend)
		Draw.draw(self.gradient40, (self.tower_x - self.tower_radius) + self.tile_width, self.tower_y, -math.rad(270), self.verticaltilecount + 1, 1)
		Draw.draw(self.gradient40, (self.tower_x + self.tower_radius) - self.tile_width, self.tower_y, -math.rad(90), -self.verticaltilecount - 1, 1)
	end
	for _, event in ipairs(self.world.map.events) do
		if event and event.climb_obstacle then
			if event.id == "ClimbCoin" then	
				local adjustment = -260
				if self.appearance == 1 then
					adjustment = -520
				end
				local coin_angle_pos =  MathUtils.lerp(360, 0, (event.x + adjustment) / self.tower_circumference)
				local coin_angle = coin_angle_pos + self.tower_angle
				if coin_angle > 360 then
					coin_angle = coin_angle - 360
				elseif coin_angle < 0 then
					coin_angle = coin_angle + 360
				end
				if (coin_angle > 350 or coin_angle <= 170) then
					self:drawTowerCoin(event, coin_angle)
				end
			end
		end
	end
	for _, text in ipairs(Game.stage:getObjects(Text)) do
		if text and text.onrotatingtower then
			local adjustment = -260
			if self.appearance == 1 then
				adjustment = -520
			end
			local text_angle_pos =  MathUtils.lerp(360, 0, (text.x + adjustment) / self.tower_circumference)
			local text_angle = text_angle_pos + self.tower_angle
			if text_angle > 360 then
				text_angle = text_angle - 360
			elseif text_angle < 0 then
				text_angle = text_angle + 360
			end
			if (text_angle > 350 or text_angle <= 170) then
				self:drawTowerText(text, text_angle)
			end
		end
	end
	self.tower_x = self.tower_x - self.tower_xshake
	self.tower_y = self.tower_y - self.tower_yshake
	Draw.setColor(1,1,1,1)
end

function RotatingTower:drawTowerCoin(event, angle)
	local dist_from_tower = 15
	if self.appearance == 2 then
		dist_from_tower = 45
	end
	local coin_x = self.tower_x + MathUtils.lengthDirX(self.tower_radius + dist_from_tower, -math.rad(angle))
	local factor = math.sin(math.rad(angle))
	local spr = event.silver_tex[(math.floor(event.siner/4)%4)+1]
	local xoff = 4
	local yoff = 4
	if event.value > 5 then
		spr = event.gold_tex[(math.floor(event.siner/4)%4)+1]
		yoff = 5
	end
	Draw.setColor(ColorUtils.mergeColor(COLORS.white, COLORS.black, MathUtils.clamp(1 - factor, 0, 1)))
	if event.con == 0 then
		Draw.draw(spr, coin_x, event.y + 30 + math.sin(event.siner / 20) * 4, 0, 2, 2, xoff, yoff)
	end
end

function RotatingTower:drawTowerText(text, angle)
	local dist_from_tower = 25
	if self.appearance == 2 then
		dist_from_tower = 55
	end
	local text_x = self.tower_x - text.x_offset + MathUtils.lengthDirX(self.tower_radius + dist_from_tower, -math.rad(angle))
	local factor = math.sin(math.rad(angle))
	Draw.setColor(ColorUtils.mergeColor(COLORS.white, COLORS.black, MathUtils.clamp(1 - factor, 0, 1)))
	Draw.draw(text.canvas, text_x, text.y)
end

return RotatingTower