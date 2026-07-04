local GrassTileAnim, super = Class(Event)

function GrassTileAnim:init(data,...)
    super.init(self,data,...)
    local properties = data and data.properties or {}
    self.layers = TiledUtils.parsePropertyList("layer", properties)
	self.tmwidth = Game.world.map.width
	self.tmheight = Game.world.map.height
	self.tile_size = Game.world.map.tile_width
	self.tile_row_length = 8
	self.anim = 0
	self.anim_speed = 0.2
	self.anim_length = 9
	self.anim_indicies = {0, 1, 2, 3, 0, 0, 0, 0, 0, 0, 0}
end

function GrassTileAnim:update()
    super.update(self)
	local _cx = Game.world.camera.x - SCREEN_WIDTH/2
	local _cy = Game.world.camera.y - SCREEN_HEIGHT/2
	local _left = math.max(0, math.floor((_cx - self.tile_size) / self.tile_size))
	local _top = math.max(0, math.floor((_cy - self.tile_size) / self.tile_size))
	local _right = math.min(self.tmwidth, math.floor((_cx + 700) / self.tile_size))
	local _bottom = math.min(self.tmheight, math.floor((_cy + 520) / self.tile_size))
	local mult = 1
	local last_anim = math.floor(self.anim / (self.anim_speed * mult))
	self.anim = self.anim + (self.anim_speed * mult) * DTMULT
	if self.anim > self.anim_length then
		self.anim = self.anim - self.anim_length
	end
	if math.floor(self.anim / (self.anim_speed * mult)) ~= last_anim then
		-- mark platformer floor textures as dirty here
	end
	if self.layers then
		for xx = _left, _right do
			for yy = _top, _bottom do
				for _, layer in ipairs(self.layers) do
					local tile_layer = Game.world.map:getTileLayer(layer)
					local _tileset, _data = tile_layer:getTile(xx, yy)
					if _tileset then
						local _row_start = math.floor(_data / self.tile_row_length) * self.tile_row_length
						local _min = 1 + _row_start
						local _max = 4 + _row_start
						if _data >= _min and _data <= _max then
							tile_layer:setTile(xx, yy, _tileset.name, _min + self.anim_indicies[math.floor((self.anim + (xx * 0.125) + (yy * 0.125)) % self.anim_length) + 1])
						end
					end
				end
			end
		end
	end
end

return GrassTileAnim