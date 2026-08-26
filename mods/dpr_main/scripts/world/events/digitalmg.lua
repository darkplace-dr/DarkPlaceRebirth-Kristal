local DigitalMagicGlass, super = Class(Event)

function DigitalMagicGlass:init(data)
    super.init(self, data)

	self.default_color = ColorUtils.hexToRGB("#c3ff00")
    self.texture = Assets.getTexture("world/events/digitalmg")

    self.tiles_x = math.floor(self.width / 40)
    self.tiles_y = math.floor(self.height / 40)

    self.glass_colliders = {}
    self.tile_alphas = {}

    for i = 1, self.tiles_x do
        for j = 1, self.tiles_y do
            local hitbox = Hitbox(self, (i - 1) * 40, (j - 1) * 40, 40, 40)
            table.insert(self.glass_colliders, hitbox)
            table.insert(self.tile_alphas, 0.5)
        end
    end

    self.collider = Hitbox(self, 0, 0, self.width, self.height)
end

function DigitalMagicGlass:updateGlassAlpha(index, colliding)
    if #colliding > 0 then
        self.tile_alphas[index] = MathUtils.lerp(self.tile_alphas[index], 1, 0.4 * DTMULT)
    else
        self.tile_alphas[index] = MathUtils.lerp(self.tile_alphas[index], 0.5, 0.4 * DTMULT)
    end
end

function DigitalMagicGlass:getGlassRevealingObjects()
    return Game.stage:getObjects(Character)
end

function DigitalMagicGlass:update()
    Object.startCache()

    local valid_objs = {}

    for _, obj in ipairs(self:getGlassRevealingObjects()) do
        if obj:meetsCollider(self.collider) then
            table.insert(valid_objs, obj)
        end
    end

    local collided = {}

    for i, collider in ipairs(self.glass_colliders) do
        for _, obj in ipairs(valid_objs) do
            if obj:meetsCollider(collider) then
                table.insert(collided, obj)
            end
        end

        self:updateGlassAlpha(i, collided)

        if #collided > 0 then
            collided = {}
        end
    end

    Object.endCache()

    super.update(self)
end

function DigitalMagicGlass:draw()
	local color = self.default_color
	if Game.world.map.demoscene_bg then
		color = ColorUtils.mergeColor(self.default_color, Game.world.map.demoscene_bg.rainbow_color, Game.world.map.demoscene_bg.demo_alpha)
    end
	local id = 1
    for i = 1, self.tiles_x do
        for j = 1, self.tiles_y do
            Draw.setColor(color, self.tile_alphas[id])
            Draw.draw(self.texture, (i - 1) * 40, (j - 1) * 40 + (20-(self.tile_alphas[id])*20), 0, 2, 2)
            id = id + 1
        end
    end

    super.draw(self)
end

return DigitalMagicGlass