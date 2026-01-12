local TileObject, super = HookSystem.hookScript(TileObject)

function TileObject:init(tileset, tile, x, y, w, h, rotation, flip_x, flip_y, properties)
    super.init(self, tileset, tile, x, y, w, h, rotation, flip_x, flip_y)

	self.properties = properties or {}
	self.light_area = self.properties["light"] or false
	self.light_type = self.properties["light_type"] or 1
	self.light_alpha = self.properties["light_alpha"] or 1
	self.light_color = TiledUtils.parseColorProperty(self.properties["light_color"])
	self.light_dust = self.properties["light_dust"] or false
	self.tint_color = TiledUtils.parseColorProperty(self.properties["color"]) or nil
	self.light_amount = 1
end

function TileObject:drawLightA()
	if self.light_area then
		local tile_width, tile_height = self.tileset:getTileSize(self.tileset:getDrawTile(self.tile))
		local sx = self.width / tile_width * (self.tile_flip_x and -1 or 1)
		local sy = self.height / tile_height * (self.tile_flip_y and -1 or 1)
		if self.tileset.preserve_aspect_fit then
			sx = MathUtils.absMin(sx, sy)
			sy = sx
		end
		if self.light_type == 1 then
			if Ch4Lib.accurate_blending then
				love.graphics.push()
				Ch4Lib.setBlendState("add", "zero", "oneminussrccolor")
				love.graphics.setColor(1,1,1,1)
				local xx, yy = self:localToScreenPos(0,0)
				self.tileset:drawTile(self.tile, xx+self.width/2, yy+self.height/2, 0, sx, sy, tile_width/2, tile_height/2)
				Ch4Lib.setBlendState("add", "srcalpha", "oneminussrcalpha")
				love.graphics.pop()
			end
		end
		if Ch4Lib.accurate_blending then
			if self.light_type == 2 or self.light_type == 4 then
				love.graphics.setColor(1,1,1,self.light_alpha)
				local xx, yy = self:localToScreenPos(0,0)
				self.tileset:drawTile(self.tile, xx+self.width/2, yy+self.height/2, 0, sx, sy, tile_width/2, tile_height/2)
			end
		else
			if self.light_type == 3 or self.light_type == 5 then
				love.graphics.setColor(1,1,1,self.light_alpha)
				local xx, yy = self:localToScreenPos(0,0)
				self.tileset:drawTile(self.tile, xx+self.width/2, yy+self.height/2, 0, sx, sy, tile_width/2, tile_height/2)
			end
		end
	end
end

function TileObject:drawLightB()
	if self.light_area then
		local tile_width, tile_height = self.tileset:getTileSize(self.tileset:getDrawTile(self.tile))
		local sx = self.width / tile_width * (self.tile_flip_x and -1 or 1)
		local sy = self.height / tile_height * (self.tile_flip_y and -1 or 1)
		if self.tileset.preserve_aspect_fit then
			sx = MathUtils.absMin(sx, sy)
			sy = sx
		end
		if Ch4Lib.accurate_blending then
			if self.light_type == 1 or self.light_type == 2 or self.light_type == 3 or self.light_type == 4 or self.light_type == 5 then
				love.graphics.setColor(1,1,1,1)
				local xx, yy = self:localToScreenPos(0,0)
				self.tileset:drawTile(self.tile, xx+self.width/2, yy+self.height/2, 0, sx, sy, tile_width/2, tile_height/2)
			end
		else
			if self.light_type == 1 or self.light_type == 2 or self.light_type == 4 then
				love.graphics.setColor(1,1,1,1)
				local xx, yy = self:localToScreenPos(0,0)
				self.tileset:drawTile(self.tile, xx+self.width/2, yy+self.height/2, 0, sx, sy, tile_width/2, tile_height/2)
			end
		end
	end
end

function TileObject:draw()
    local tile_width, tile_height = self.tileset:getTileSize(self.tileset:getDrawTile(self.tile))
    local sx = self.width / tile_width * (self.tile_flip_x and -1 or 1)
    local sy = self.height / tile_height * (self.tile_flip_y and -1 or 1)
    if self.tileset.preserve_aspect_fit then
        sx = MathUtils.absMin(sx, sy)
        sy = sx
    end
	if self.light_area and self.light_type == 1 then
		love.graphics.setBlendMode("add")
		love.graphics.setColor(self.light_color[1], self.light_color[2], self.light_color[3], self.light_alpha * self.light_amount)
	elseif self.tint_color then
		love.graphics.setColor(self.tint_color[1], self.tint_color[2], self.tint_color[3], 1)
	end
	if self.light_type ~= 4 and self.light_type ~= 5 then
		self.tileset:drawTile(self.tile, self.width/2, self.height/2, 0, sx, sy, tile_width/2, tile_height/2)
	end
	love.graphics.setBlendMode("alpha")
end

return TileObject