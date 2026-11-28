---@class MikeCatBasket : Object
local MikeCatBasket, super = Class(Sprite)

function MikeCatBasket:init(x, y)
    super.init(self, "minigame/bullets/mike/catbasket", x, y)
    self:stop()

    self:setOriginExact(45, 48)
    self.collider = Hitbox(self, 9, 50, 71, 16)

    self.layer = 2
    self.action = 0
    self.xscale, self.yscale = 1, 1
    self.timer = MathUtils.randomInt(120+1)
    self.move = false
    self.type = 0
    self.lastx = self.init_x
    self.y = SCREEN_HEIGHT + 200
    self.last_cat_was_thrown = false
    self.cats = 0

    self.scale = {}
    self.xx = {}
    self.yy = {}

    for i = 1, 20 do
        self.scale[i] = 0
        self.xx[i] = 0
        self.yy[i] = 0
    end

    self.scoreflash = 0
    self.keepalive = false
end

local function lengthDirX(length, dir)
    return math.cos(dir) * length
end

local function lengthDirY(length, dir)
    return math.sin(dir) * length
end

function MikeCatBasket:update()
    super.update(self)

    if self.action < 3 then
        if self.move then
            self.y = MathUtils.approach(self.y, self.init_y + 200, 12*DTMULT)
            
            if self.y == (self.init_y + 200) then
                self.move = false
                
                while (self.x == self.last_x) do
                    self.x = self.init_x + choose(-250, 0, 250)
                end
                
                self.last_x = self.x
            end
        else
            self.y = MathUtils.approach(self.y, self.init_y, 12*DTMULT)
        end
    else
        self.physics.speed_y = self.physics.speed_y + 0.5 * DTMULT
    end
end

function MikeCatBasket:drawSelf()
    super.drawSelf(self)

    local maxcats = math.min(self.cats, 20)

    for i = 1, maxcats do
        self.scale[i] = MathUtils.approach(self.scale[i], 2, 0.25*DTMULT)
        self.xx[i] = self.xx[i] + (lengthDirX(10 * self.scale[i], -math.rad((i / maxcats) * 360) - self.xx[i])) * 0.2
        self.yy[i] = self.yy[i] + (lengthDirY(5 * self.scale[i], -math.rad((i / maxcats) * 360) - self.yy[i])) * 0.2

        Draw.setColor(0, 1, 1, 1)
        local current_time = (Kristal.getTime() * 1000) / 30
        Draw.draw(Assets.getTexture("minigame/bullets/mike/cat_face"), self.x + self.xx[i], self.y + self.yy[i], -math.rad(math.sin(i + (current_time / 200)) * 10), self.scale[i], self.scale[i], 12, 8)
    end
    
    Draw.setColor({self:getColor()})
    Draw.draw(Assets.getFrames("minigame/bullets/mike/catbasket")[2], self.x, self.y, self.rotation, self.scale_x, self.scale_y, 45, 48)

    if DEBUG_RENDER then
        self.collider:drawFor(self, 0, 1, 1)
    end
end

return MikeCatBasket