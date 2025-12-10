-- Extend the Event class, and set the ID to "pinwheel"
-- This is what you'll use to refer to the event in Tiled
local SquareTest, super = Class(Event, "darknesstest")

-- `data` is the data directly from Tiled
function SquareTest:init(x, y, shape)
    -- Place the event at the correct position, and make the size 20x20
    super.init(self, x, y, shape)
self.canvas = love.graphics.newCanvas(SCREEN_WIDTH*2, SCREEN_HEIGHT*2)

    -- Any custom properties are stored in `data.properties`, but we don't use any.

    -- Just some variables for the pinwheel

    -- Most events in DELTARUNE are 2x sized
    self:setScale(1)

    -- We placed a single point in Tiled, which we want to be the bottom center of the pinwheel
    self.siner = 0
    self.opacity = 1
end

-- Update gets called every frame
function SquareTest:update()
    super.update(self)
    self.siner = self.siner + DT
        
        if Game.darkshow ~= true then
            if self.opacity < 0 then
                self.opacity = 0
            end
        self.opacity = self.opacity + DT*2
        else
            if self.opacity > 1 then
                self.opacity = 1
            
            end
            self.opacity = self.opacity - DT*2
        end
    
end



function SquareTest:draw()
    super.draw(self)
    Draw.pushCanvas(self.canvas)
    love.graphics.clear()
    love.graphics.translate(0, -40)
--love.graphics.push()
    self.circlex = 0
    self.circley = 0
    -- First, draw the base
    -- Then draw the pinwheel, spinning
Draw:setColor(1, 1, 1)
love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 40, 80, self.width, self.height)
    for i=1,self.height/40 do
        for i=1,self.width/40+1 do
            love.graphics.setColor(1, 1, 1)
            self.siner = self.siner - i
            self.siner = self.siner - self.circley/2
            love.graphics.circle("fill", self.circlex+40, (math.sin(self.siner * 1.5) * 10 + 20)+self.circley*40+80, 40)
            self.siner = self.siner + i
            self.siner = self.siner + self.circley/2
            self.circlex = self.circlex + 40
        end
        self.circlex = 0
        self.circley = self.circley+1
    end
    self.circlex = 0
    self.circley = 0
    for i=1,self.height/40 do
        for i=1,self.width/40+1 do
            self.siner = self.siner - i
            self.siner = self.siner - self.circley/2
            love.graphics.setColor(0, 0, 0)
            love.graphics.circle("fill", self.circlex+40, (math.sin(self.siner * 1.5) * 10 + 20)+self.circley*40+80, 35)
            self.siner = self.siner + i
            self.siner = self.siner + self.circley/2
            self.circlex = self.circlex + 40
        end
        self.circlex = 0
        self.circley = self.circley+1

    end
    
    Draw.popCanvas() -- Revert current canvas back to before
Draw.setColor(COLORS.white, self.opacity) -- Set color and alpha
love.graphics.draw(self.canvas) -- Draw the canvas


end

-- When we interact with the pinwheel, make it spin faster!
return SquareTest