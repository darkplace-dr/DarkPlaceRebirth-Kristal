local DojoFX, super = Class(Event, "dojofx")

function DojoFX:init(data)
    super.init(self, data)

    self.solid = false

    self.count          = data.properties["boombox_count"] or 12
    self.siner = 0
    self.bsiner = 0
    
    self.max_width      = data.properties["max_width"] or SCREEN_WIDTH
    self.hue            = data.properties["hue"] or math.random()
    self.show_spotlight = data.properties["show_spotlight"] ~= false
    self.show_discoball = data.properties["show_discoball"] ~= false
    self.is_love        = data.properties["is_love"]

    Game.world.discoball = Discoball()
    Game.world.discoball:setLayer(WORLD_LAYERS["below_ui"])
    Game.world.discoball.x = self.max_width/2
    Game.world.discoball.y = 0
    Game.world.discoball.hue = self.hue
    Game.world.discoball.visible = self.show_discoball
	Game.world.discoball.persist_to_world = true
    Game.world:addChild(Game.world.discoball)
    local COLOR_MUL = love._version >= "11.0" and 1 or 255
    self.spotlight = love.graphics.newMesh({
        {0.5,0,0,0,1,1,1,COLOR_MUL},
        {0.5,0,1,0,1,1,1,COLOR_MUL},
        {1,1,1,1,0,0,0,COLOR_MUL},
        {0,1,0,1,0,0,0,COLOR_MUL},
    }, "strip", "static")
    self.discoball_col = Game.world.discoball.hsv_color or COLORS.white
    self.discoball_siner = Game.world.discoball.siner or 0
    
    self.light_count = 16
end

function DojoFX:onRemove(parent)
    super.onRemove(self, parent)
    Game.world.discoball:remove()
end

function DojoFX:draw()
    self.siner = self.siner + DTMULT
    self.bsiner = self.bsiner + DTMULT

    if self.bsiner >= 80 then
        self.bsiner = self.bsiner - 80
    end
    
    if Game.world.discoball then
        self.discoball_col = Game.world.discoball.hsv_color
        self.discoball_siner = Game.world.discoball.siner
    end
    
    for i = 0, self.light_count - 1 do
        if self.show_discoball then
            Draw.setColor({self.discoball_col[1], self.discoball_col[2], self.discoball_col[3] , 0.5})
            local sino = math.sin(((i / 2) + (self.discoball_siner / 48)))
            love.graphics.circle("fill", ((self.max_width/2) + (sino * 200)), ((self.y + 60) + (math.sin((i / 4)) * 20)), (16 + (math.abs(sino) * 12)))
        end
    end
    if self.show_spotlight then
        Draw.setColor(1, 1, 1, 0.5)
        love.graphics.draw(self.spotlight, self.max_width/2-80, 80, 0, 160, 120)
    end
    
    for i = 0, self.count - 1 do
        local x = 4
        local y = ((-240 + self.y) + (i * 80)) - self.bsiner

        local frames = Assets.getFrames("world/events/boombox")
        local frame = math.floor(self.discoball_siner / 8) + 1
        frame = Utils.clampWrap(frame, #frames)
        Draw.setColor(self.discoball_col)
        Draw.draw(frames[frame], x, y, 0, 2, 2)

        local x2 = self.max_width - 70
        local y2 = ((-240 + self.y) + (i * 80)) + self.bsiner

        local frames2 = Assets.getFrames("world/events/boombox")
        local frame2 = math.floor(self.discoball_siner / 8) + 1
        frame2 = Utils.clampWrap(frame2, #frames2)
        Draw.setColor(self.discoball_col)
        Draw.draw(frames2[frame2], x2, y2, 0, 2, 2)
    end
    
    super.draw(self)
end

return DojoFX