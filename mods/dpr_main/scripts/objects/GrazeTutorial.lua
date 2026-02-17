---@class GrazeTutorial : Object
local GrazeTutorial, super = Class(Object)

function GrazeTutorial:init()
    super.init(self)
    self:setPosition(0,0)
    self:setParallax(0,0)
	self.puzboy = nil
	self.bullets = {}
	self.con = 0
	self.sprite = nil
    self.color = {0, 0.75, 0}
	self.rotation = 0
    self.line_width = 4
    self.shape = TableUtils.copy({{0, 0}, {142, 0}, {142, 142}, {0, 142}}, true)
    self.processed_shape = TableUtils.copy({{0, 0}, {142, 0}, {142, 142}, {0, 142}}, true)

    local min_x, min_y, max_x, max_y
    for _, point in ipairs(self.shape) do
        min_x, min_y = math.min(min_x or point[1], point[1]), math.min(min_y or point[2], point[2])
        max_x, max_y = math.max(max_x or point[1], point[1]), math.max(max_y or point[2], point[2])
    end
    for _, point in ipairs(self.shape) do
        point[1] = point[1] - min_x
        point[2] = point[2] - min_y
    end
    self.width = max_x - min_x
    self.height = max_y - min_y

    self.processed_width = self.width
    self.processed_height = self.height

    self.left = math.floor(self.x - self.width / 2)
    self.right = math.floor(self.x + self.width / 2)
    self.top = math.floor(self.y - self.height / 2)
    self.bottom = math.floor(self.y + self.height / 2)

    self.triangles = love.math.triangulate(Utils.unpackPolygon(self.shape))

    self.border_line = {Utils.unpackPolygon(Utils.getPolygonOffset(self.shape, self.line_width/2))}

    self.clockwise = Utils.isPolygonClockwise(self.shape)
end

function GrazeTutorial:getBackgroundColor()
    return {0, 0, 0}
end

function GrazeTutorial:onAdd(parent)
    super.onAdd(self, parent)
    self:setLayer(WORLD_LAYERS["ui"])
end

function GrazeTutorial:createArena()
    self.sprite = ArenaSprite(self, SCREEN_WIDTH/2 - self.width / 2, SCREEN_HEIGHT/2 - 80 - self.height / 2)
    self:addChild(self.sprite)

    self.sprite:setScale(0, 0)
    self.sprite.alpha = 0.5
    self.sprite.rotation = math.pi

    local center_x, center_y = SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 80

    local afterimage_timer = 0
    local afterimage_count = 0
    Game.world.timer:during(
        15 / 30,
        function()
            afterimage_timer = MathUtils.approach(afterimage_timer, 15, DTMULT)

            local real_progress = afterimage_timer / 15

            self.sprite:setScale(real_progress, real_progress)
            self.sprite.alpha = 0.5 + (0.5 * real_progress)
            self.sprite.rotation = (math.pi) * (1 - real_progress)

            while afterimage_count < math.floor(afterimage_timer) do
                afterimage_count = afterimage_count + 1

                local progress = afterimage_count / 15

                local afterimg = ArenaSprite(self, center_x, center_y)
                afterimg:setOrigin(0.5, 0.5)
                afterimg:setScale(progress, progress)
                afterimg:fadeOutSpeedAndRemove()
                afterimg.background = false
                afterimg.alpha = 0.6 - (0.5 * progress)
                afterimg.rotation = (math.pi) * (1 - progress)
                Game.world:addChild(afterimg)
                afterimg:setLayer(self.layer + (1 - progress))
            end
        end,
        function()
            self.sprite:setScale(1)
            self.sprite.alpha = 1
        end
    )
end

function GrazeTutorial:onRemove(parent)
	super.onRemove(self, parent)
	if self.puzboy then
		self.puzboy.fade = true
	end
	for _, bullet in ipairs(self.bullets) do
		if bullet and not bullet:isRemoved() then
			bullet.fade = true
		end
	end
	self.sprite:remove()
    local orig_sprite = ArenaSprite(self, SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 80)
    orig_sprite:setOrigin(0.5, 0.5)
    parent:addChild(orig_sprite)
    orig_sprite:setLayer(self.layer)
    orig_sprite.rotation = self.rotation
    local rotation = self.rotation

    local afterimage_timer = 0
    local afterimage_count = 0
    Game.world.timer:during(
        15 / 30,
        function()
            afterimage_timer = MathUtils.approach(afterimage_timer, 15, DTMULT)

            local real_progress = 1 - (afterimage_timer / 15)

            orig_sprite:setScale(real_progress, real_progress)
            orig_sprite.alpha = 0.5 + (0.5 * real_progress)
            orig_sprite.rotation = rotation + ((math.pi) * (1 - real_progress))

            while afterimage_count < math.floor(afterimage_timer) do
                afterimage_count = afterimage_count + 1

                local progress = 1 - (afterimage_count / 15)

                local afterimg = ArenaSprite(self, orig_sprite.x, orig_sprite.y)
                afterimg:setOrigin(0.5, 0.5)
                afterimg:setScale(progress, progress)
                afterimg:fadeOutSpeedAndRemove()
                afterimg.background = false
                afterimg.alpha = 0.6 - (0.5 * progress)
                afterimg.rotation = rotation + ((math.pi) * (1 - progress))
                parent:addChild(afterimg)
                afterimg:setLayer(self.layer + (1 - progress))
            end
        end,
        function()
            orig_sprite:remove()
        end
    )
end

function GrazeTutorial:update()
    super.update(self)
	if self.con == 0 then
		self.timer = 0
		self:createArena()
		self.puzboy = TutorialPuzBoy(SCREEN_WIDTH/2, SCREEN_HEIGHT/2 - 80 + 32 + 20)
		self.puzboy.layer = self.layer + 0.5
		Game.world:addChild(self.puzboy)
		self.con = 1
		self.xvar = SCREEN_WIDTH/2 + MathUtils.random(-30, 30)
	end
	if self.con == 1 then
		self.timer = self.timer + DTMULT
		
		if self.timer > 4 and self.puzboy.x < 340 and self.puzboy.x > 300 then
			self.xvar = SCREEN_WIDTH/2
			local b = TutorialBullet(self.xvar, 80, self.puzboy)
			b.physics.direction = MathUtils.angle(b.x, b.y, self.puzboy.x, self.puzboy.y)
			b.physics.speed = 5
			b.rotation = b.physics.direction
			b.layer = self.layer + 1
			Game.world:addChild(b)
			table.insert(self.bullets, b)
			local b2 = TutorialBullet(self.xvar, 80, self.puzboy)
			b2.physics.direction = b.physics.direction + math.rad(33)
			b2.physics.speed = 5
			b2.rotation = b2.physics.direction
			b2.layer = self.layer + 1
			Game.world:addChild(b2)
			table.insert(self.bullets, b2)
			local b3 = TutorialBullet(self.xvar, 80, self.puzboy)
			b3.physics.direction = b.physics.direction - math.rad(33)
			b3.physics.speed = 5
			b3.rotation = b3.physics.direction
			b3.layer = self.layer + 1
			Game.world:addChild(b3)
			table.insert(self.bullets, b3)
			self.timer = 0
		end
	end
	if not Game.world:hasCutscene() then
		self:remove()
	end
end

return GrazeTutorial