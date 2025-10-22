---@class Event.destructableclimbarea : Event
local event, super = Class(Event, "destructableclimbarea")

function event:init(data)
    super.init(self, data)
    local properties = data and data.properties or {}
    self.climbable = true
    self.dangerous = properties["dangerous"] or false
    self.dangertime = properties["dangertime"] or 60
    self.only_break_upwards = properties["break_Upward"] or false
    self.sprite = properties["sprite"] or "world/events/climbtiles/brittle"
    self.sprite_tex = Assets.getTexture(self.sprite)
    self.always_break_on_timer = properties["break_ontime"] or true
    self.con = 0
    self.tiles_x = math.floor(self.width/40)
    self.tiles_y = math.floor(self.height/40)
    self.y_start = self.y
    self.siner = 0
    self.timer = 0
end

function event:update()
    super.update(self)
    local collider = Hitbox(self, 0, 0, self.tiles_x * 40, self.tiles_y * 40)
    if self.con == 0 then
        Object.startCache()
        if self.world.player:collidesWith(collider) and self.world.player.state == "CLIMB" then
            if self.con == 0 then
                self.con = 1
            end
        end
        Object.endCache()
    end
    if self.con == 1 then
        local endme = false
        if self.always_break_on_timer then
            Object.startCache()
            if not self.world.player:collidesWith(collider) and self.world.player.state == "CLIMB" then
                if not self.only_break_upwards or self.world.player.y < self.y then
                    self.con = 2
                    endme = true
                else
                    self.con = 0
                end
            end
            Object.endCache()
        end
        if self.dangerous and self.timer >= self.dangertime then
            self.con = 2
            self.world.player.falling = 1
            endme = true
        end
        if endme then
            self.climbable = false
            Assets.playSound("heavyswing")
            self.world.timer:after(1, function()
                self:remove()
            end)
            self.physics.gravity = 1
        end
    end
end

function event:draw()
    for i = 1, self.tiles_x do
        for j = 1, self.tiles_y do
            local xoff = 0
            local yoff = 0
            if self.con == 2 then
                local falamt = math.abs(self.y - self.y_start) / 10
                if j % 2 == 0 then
                    falamt = -falamt
                end
                xoff = (math.sin(self.siner + ((i + j) * self.con * 80)) * 2) + falamt
                yoff = math.sin(self.siner + ((i + j) * self.con * 60)) * 2
            end
            Draw.draw(self.sprite_tex, xoff + (i - 1) * 40, yoff + (j - 1) * 40, 0, 2, 2)
        end
    end
    if self.con < 2 then
        self.siner = self.siner + DTMULT
    end
    super.draw(self)
    if DEBUG_RENDER then
        Draw.setColor(1, 0.5, 1)
        for x=0,self.width-1,40 do
            for y=0,self.height-1,40 do
                love.graphics.rectangle("line", x+4,y+4,40-8,20-8)
                love.graphics.rectangle("line", x+4,y+24,40-8,20-8)
                love.graphics.rectangle("line", x+4,y+4,40-8,40-8)
            end
        end
    end
end

return event
