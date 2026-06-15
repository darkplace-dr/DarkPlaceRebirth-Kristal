-- Extend the Event class, and set the ID to "pinwheel"
-- This is what you'll use to refer to the event in Tiled
local SquareTest, super = Class(Event, "squaretest")

-- `data` is the data directly from Tiled
function SquareTest:init(x, y, shape)
    -- Place the event at the correct position, and make the size 20x20
    super.init(self, x, y, shape) --See the "squaretestback" script for proper documentation. Do note that you will have to edit the values in both files.
    self.x = self.x - 40
    self.y = self.y - 40
    self.fposx = 55
    self.fposy = 55
    self.falsex = Game.world.player.x
    self.falsey = Game.world.player.y
    self.falsexx = self.falsex
    self.falseyy = self.falsey
    self.posx = 0
    self.posy = 0
    self.size = 20
    self.holeheight = 30
    self.extrasize = 20
    self.extrabigsize = 40
    self.extrabigsizeoffset = 1
    self.lerp = 0.9
    self.lerpouter = 0.5
self.canvas = love.graphics.newCanvas(SCREEN_WIDTH*2, SCREEN_HEIGHT*2)
local fx = self:addFX(MaskFX(function()
    love.graphics.circle("fill", self.falsex+(math.sin(self.siner * 1) * 15) -(Game.world.camera.x - 320), self.falsey+(math.sin(self.siner * 1.7) * 12 - self.holeheight)-(Game.world.camera.y - 240)-15, (self.size+self.extrabigsize)+(math.sin(self.siner * 2.3 + self.extrabigsizeoffset) * 10 + self.extrasize))
    love.graphics.circle("fill", self.falsexx+(math.sin(self.siner * 1) * 15) -(Game.world.camera.x - 320), self.falseyy+(math.sin(self.siner * 1.7) * 12 + self.posy - self.holeheight)-(Game.world.camera.y - 240)-15, self.size+(math.sin(self.siner * 2.3) * 10 + self.extrasize))
    love.graphics.circle("fill", self.falsexx+(math.sin(self.siner * 1) * 15) -(Game.world.camera.x - 320), self.falseyy+(math.sin(self.siner * 1.7) * 12 - self.posy - self.holeheight)-(Game.world.camera.y - 240)-15, self.size+(math.sin(self.siner * 2.3) * 10 + self.extrasize))
    love.graphics.circle("fill", self.falsexx+(math.sin(self.siner * 1) * 15) -(Game.world.camera.x - 320)+(self.posx/1.1), self.falseyy+(math.sin(self.siner * 1.7) * 12 + (self.posy/1.1) - self.holeheight)-(Game.world.camera.y - 240)-15, self.size+(math.sin(self.siner * 2.3) * 10 + self.extrasize))
    love.graphics.circle("fill", self.falsexx+(math.sin(self.siner * 1) * 15) -(Game.world.camera.x - 320)-(self.posx/1.1), self.falseyy+(math.sin(self.siner * 1.7) * 12 - (self.posy/1.1) - self.holeheight)-(Game.world.camera.y - 240)-15, self.size+(math.sin(self.siner * 2.3) * 10 + self.extrasize))
    love.graphics.circle("fill", self.falsexx+(math.sin(self.siner * 1) * 15) -(Game.world.camera.x - 320)+self.posx, self.falseyy+(math.sin(self.siner * 1.7) * 12 - self.holeheight)-(Game.world.camera.y - 240)-15, self.size+(math.sin(self.siner * 2.3) * 10 + self.extrasize))
    love.graphics.circle("fill", self.falsexx+(math.sin(self.siner * 1) * 15) -(Game.world.camera.x - 320)-self.posx, self.falseyy+(math.sin(self.siner * 1.7) * 12 - self.holeheight)-(Game.world.camera.y - 240)-15, self.size+(math.sin(self.siner * 2.3) * 10 + self.extrasize))
    love.graphics.circle("fill", self.falsexx+(math.sin(self.siner * 1) * 15) -(Game.world.camera.x - 320)+(self.posx/1.1), self.falseyy+(math.sin(self.siner * 1.7) * 12 - (self.posy/1.1) - self.holeheight)-(Game.world.camera.y - 240)-15, self.size+(math.sin(self.siner * 2.3) * 10 + self.extrasize))
    love.graphics.circle("fill", self.falsexx+(math.sin(self.siner * 1) * 15) -(Game.world.camera.x - 320)-(self.posx/1.1), self.falseyy+(math.sin(self.siner * 1.7) * 12 + (self.posy/1.1) - self.holeheight)-(Game.world.camera.y - 240)-15, self.size+(math.sin(self.siner * 2.3) * 10 + self.extrasize))
end))
fx.inverted = true


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
    self.posy = self.fposy - (math.sin(self.siner * 1.7) * 5)
    self.posx = self.fposx - (math.sin(self.siner * 1.7) * 5)
    self.falsex = Utils.lerp(self.falsex, Game.world.player.x, self.lerp)
    self.falsey = Utils.lerp(self.falsey, Game.world.player.y, self.lerp)
    self.falsexx = Utils.lerp(self.falsexx, Game.world.player.x, self.lerpouter)
    self.falseyy = Utils.lerp(self.falseyy, Game.world.player.y, self.lerpouter)
    if Game.instantshow == false then
        
        if Game.show ~= true then
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
    elseif Game.instantshow == true then
        if Game.show ~= true then
            self.opacity = 1
        else
            self.opacity = 0
        end
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
    self.circlex = 0
    self.circley = 0
    for i=1,self.height/40 do
        for i=1,self.width/40+1 do
            self.siner = self.siner - i
            self.siner = self.siner - self.circley/2
            love.graphics.setColor(0, 0, 0)
            love.graphics.circle("fill", (math.sin(self.siner * 1.5) * 10 + 20)+self.circlex+40, (math.sin(self.siner * 1.5) * 10 + 20)+self.circley*40+80, 35)
            self.siner = self.siner + i
            self.siner = self.siner + self.circley/2
            self.circlex = self.circlex + 40
        end
        self.circlex = 0
        self.circley = self.circley+1

    end
    
    Draw.popCanvas() -- Revert current canvas back to before
Draw.setColor(COLORS.black, self.opacity) -- Set color and alpha
love.graphics.draw(self.canvas) -- Draw the canvas


end

-- When we interact with the pinwheel, make it spin faster!
return SquareTest