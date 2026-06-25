local WaterReflect, super = Class(Event, "waterreflect")

function WaterReflect:init(data)
    super.init(self, data)

    local properties = data.properties or {}

    self.reflect = properties["reflect"] or false
	self.shadow_y_offset = properties["offset"] or self.height
	self.tile_layers = TiledUtils.parsePropertyList("tiles", properties)
	self.tile_canvas = nil
end

function WaterReflect:postLoad()
    super.postLoad(self)

	self.tile_canvas = love.graphics.newCanvas(self.width, self.height + 80)
	Draw.pushCanvas(self.tile_canvas)
	love.graphics.clear()
	self:drawTiles()
	Draw.popCanvas()
end

function WaterReflect:onRemove(parent)
	super.onRemove(self, parent)
	self.tile_canvas:release()
    self.tile_canvas = nil
end

function WaterReflect:drawMirror()
    local to_draw = {}
    local to_draw_events = {}
    for _, obj in ipairs(Game.world.children) do
        if obj:includes(Event) then
            table.insert(to_draw_events, obj)
        end
        if obj:includes(Character) then
            table.insert(to_draw, obj)
        end
    end
    for _, obj in ipairs(to_draw_events) do
        if self.reflect then
            self:drawEvent(obj)
        end
    end
    for _, obj in ipairs(to_draw) do
        self:drawCharacter(obj)
    end
	if self.tile_canvas then
		Draw.draw(self.tile_canvas)
	end
end

function WaterReflect:drawCharacter(chara)
    love.graphics.push()
    chara:preDraw()
	local refl_off = 0
	if chara.reflection_offset then
		refl_off = chara.reflection_offset
	end
    love.graphics.translate(0, chara.height + refl_off)
	love.graphics.scale(-1, 1)
	love.graphics.rotate(-math.rad(180))
    chara:draw()
    chara:postDraw()
    love.graphics.pop()
end

function WaterReflect:drawEvent(event)
    if event.sprite and event.reflection then
        love.graphics.push()
        event:preDraw()
		local refl_off = 0
		if event.reflection_offset then
			refl_off = event.reflection_offset
		end
		love.graphics.translate(0, event.height + refl_off)
		love.graphics.scale(-1, 1)
		love.graphics.rotate(-math.rad(180))
        event:draw()
        event:postDraw()
        love.graphics.pop()
    end
end

function WaterReflect:drawTiles()
    love.graphics.push()
	love.graphics.origin()
	for _, layer in ipairs(self.tile_layers) do
		local tile_layer = Game.world.map:getTileLayer(layer)
		if tile_layer then
			local r, g, b, a = tile_layer:getDrawColor()
			Draw.setColor(r, g, b, 1)
			local grid_w, grid_h = Game.world.map.tile_width, Game.world.map.tile_height
			for i, xid in ipairs(tile_layer.tile_data) do
				local tx = ((i - 1) % tile_layer.map_width)
				local ty = math.floor((i - 1) / tile_layer.map_width)

				if tx >= math.floor(self.x / grid_w) and tx <= math.floor((self.x + self.width) / grid_w)
				and ty >= math.floor(self.y / grid_h) and ty <= math.floor((self.y + self.height + 80) / grid_h) then 
					local gid, flip_x, flip_y, flip_diag = TiledUtils.parseTileGid(xid)
					local tileset, id = Game.world.map:getTileset(gid)
					if tileset then
						local draw_id = tileset:getDrawTile(id)
						local w, h = tileset:getTileSize(draw_id)
						local rot = 0
						if flip_diag then
							if flip_x == flip_y then
								flip_x = not flip_x
							else
								flip_y = not flip_y
							end
							rot = -math.pi / 2
						end
						flip_y = not flip_y
						local sx, sy = 1, 1
						if tileset.fill_grid and grid_w and grid_h and (w ~= grid_w or h ~= grid_h) then
							sx = grid_w / w
							sy = grid_h / h
							if tileset.preserve_aspect_fit then
								sx = MathUtils.absMin(sx, sy)
								sy = sx
							end
						end
						local ox, oy = (w * sx) / 2, grid_h - (h * sy) / 2
						tileset:drawTile(id, (tx * grid_w) - self.x + ox, (self.y + self.height) - (ty * grid_h) + grid_h + oy, rot, flip_x and -sx or sx, flip_y and -sy or sy, ox, oy)
					end
				end
			end
		end
	end
    love.graphics.pop()
end

function WaterReflect:draw()
    super.draw(self)

    local canvas = Draw.pushCanvas(self.width, self.height + 80)
    love.graphics.clear()
    love.graphics.translate(-self.x, -self.y)
    self:drawMirror()
    Draw.popCanvas()

	love.graphics.setBlendMode("add")
    Draw.setColor(1, 1, 1, 0.5)
    Draw.draw(canvas, 0, self.shadow_y_offset)
    Draw.setColor(1, 1, 1, 1)
	love.graphics.setBlendMode("alpha")
	if self.tile_canvas then
		Draw.draw(self.tile_canvas)
	end
end

return WaterReflect