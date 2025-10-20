local PurpleSoul, super = Class(Soul)

function PurpleSoul:init(x, y)
    super.init(self, x, y)

    self:setColor(0.9, 0.3, 0.9)
end

function PurpleSoul:doMovement()

    -- Keyboard input:
    if Input.down("left") and not Input.down("right") then 
        self.x = 320 - 50
    else if not Input.down("left") and Input.down("right") then 
            self.x = 320 + 50 
        else self.x = 320 end
    end

    if Input.down("up") and not Input.down("down") then 
        self.y = 170 - 50
    else if not Input.down("up") and Input.down("down") then 
            self.y = 170 + 50 
        else self.y = 170 end
    end
end

function PurpleSoul:update()

    super.update(self)
end

return PurpleSoul