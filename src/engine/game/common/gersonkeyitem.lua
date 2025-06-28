--- The object used to represent Gerson when he appears in the Dark World key items menu if present in the inventory (item id `old_man`).
---@class GersonKeyItem : Object
---@overload fun(...) : GersonKeyItem
local GersonKeyItem, super = Class(Object)

function GersonKeyItem:init(x, y)
    super.init(self, x, y)
    self.parallax_x = 0
    self.parallax_y = 0
	
    self.gerson = ActorSprite("gerson_keyitem")
    self.gerson:setScale(2)
    self:addChild(self.gerson)

    self.movecon = 3
    self.con = 0
    
    self.custom_animation = ""

    self.minx = 100 + x 
    self.maxx = 400 + x 
    self.maxy = 270 + y

    self.x = (self.minx + 50)
    self.y = self.maxy

    self.remmovecon = 0
	
    self.stop_check = false
	
    self.timer = Timer()
    self:addChild(self.timer)
	
    self.timer:every(3, function()
        if self.movecon < 0 then
            return false
        end
        self.remmovecon = self.movecon
        self.movecon = Utils.random(0, 2, 1)
        if self.movecon == self.remmovecon then
            self.movecon = Utils.random(0, 2, 1)
        end
        self.con = 0
    end)
end

function GersonKeyItem:update()
    super.update(self)

    if self.movecon == -1 then
        self.gerson:setAnimation(self.custom_animation)
        self.movecon = -2
        self:setPhysics({
            speed_x = 0,
            gravity = 0,
        })
    end

    if self.movecon == 0 or self.movecon == 1 then
        if self.con == 0 then
            if self.movecon == 0 then
                self:setPhysics({
                    speed_x = -2,
                })
                self.gerson:setAnimation("walk_left")
			end
            if self.movecon == 1 then
                self:setPhysics({
                    speed_x = 2,
                })
                self.gerson:setAnimation("walk_right")
			end
            self.con = 1
            self.contimer = 0
            self.contimermax = 60
		end
        if self.con == 1 then
            self.stop = 0
            self.contimer = self.contimer + DTMULT
            if self.x < self.minx and self.movecon ~= 1 then
                self.stop = 1
                self.gerson:setSprite("right_1")
            elseif self.x > self.maxx and self.movecon ~= 0 then
                self.stop = 1
                self.gerson:setSprite("left_1")
            elseif self.contimer > self.contimermax then
                self.stop = 1
                self.gerson:setSprite("left_1")
            end
            if self.stop == 1 then
                if self.movecon == 0 then
                    self.gerson:setSprite("left_1")
                end
                if self.movecon == 1 then
                    self.gerson:setSprite("right_1")
                end
			
                self:setPhysics({
                    speed_x = 0,
                })
                self.con = 2
			end
		end
	end
    if self.movecon == 2 then
        if self.con == 0 then
            if self.x > self.maxx and Game.inventory:hasItem("rouxls_kaard") then
                self.gerson:setSprite("look_up_right")
            else
                self.gerson:setAnimation(Utils.pick{"beard_thinking", "shifty"})
            end
            self.shiftytimer = 0
            self.con = 1
            self:setPhysics({
                speed = 0,
                speed_x = 0,
                gravity = 0,
            })
        end
        if self.con == 1 then
            self.shiftytimer = self.shiftytimer + DTMULT
            if self.shiftytimer >= 20 then
                if self.x < self.minx then
                    self.stop = 1
                    self.movecon = 1
                elseif self.x > self.maxx then
                    self.stop = 1
                    self.movecon = 0
                end
				
                self.con = 2
            end
        end
    end
end

return GersonKeyItem