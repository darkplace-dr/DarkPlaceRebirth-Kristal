---@class Event.chr : Event
local chr, super = Class( Event)

function chr:init(...)
    super.init(self,...)
    -- self.solid = true
    --self.collider = CircleCollider(self, self.width/2, self.height/2, self.width/2)
    
    self.chr = Sprite("world/npcs/cliffside/chr/attack")
    --self.chr.layer = Game.world.player.layer or self.layer
    self:addChild(self.chr)
    --self.chr:play(1/12, true)
    self.chr:setScale(2)

    self.chr.x = -64
    self.chr.y = -474

    self.colliders = {}

    self.hit = Hitbox(self, 0, 0, 120, 40)
    table.insert(self.colliders, self.hit)

    self.area = Hitbox(self, -40, 0, 200, 80)
    table.insert(self.colliders, self.area)

    self.collider = ColliderGroup(self, self.colliders)


    self.slam_box = Event(self.x, self.y, 120, 40)
    Game.world:addChild(self.slam_box)
end
function chr:update()
    super.update(self)

    if self.end_game then
            Kristal.hideBorder(0)
            self.state = "GAMEOVER"
            if Game.battle   then Game.battle  :remove() end
            if Game.world    then Game.world   :remove() end
            if Game.shop     then Game.shop    :remove() end
            if Game.gameover then Game.gameover:remove() end
            if Game.legend   then Game.legend  :remove() end
            if Game.dogcheck then Game.dogcheck:remove() end
            Game.gameover = GameOver(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, "", "turncoat")
            Game.stage:addChild(Game.gameover)
    end

    if self.area:collidesWith(Game.world.player) then
        if not self.played then
            self.played = true
            self.chr:play(1/12, false)
            self.timer = 0
        end
        if self.hit:collidesWith(Game.world.player) and self.chr.frame >= 7 then

            self.end_game = true
        end
    end

    if self.played and self.chr.frame == 10 then
       if self.timer >= 30*3 then
           self.played = nil
           self.chr:setFrame(1)
           self.chr.alpha = 1
       else
           self.timer = self.timer + DTMULT
           self.chr.alpha = ((30*3) - self.timer)/(30*3)
       end
    end

    if self.chr.frame >= 7 then
        self.slam_box.solid = true

        if self.chr.frame == 7 then
            self:slam_set(-10, 0, 60, 140)
            self.layer = Game.world.player.layer + 0.01
        else
            self:slam_set(0, 0, 40, 120)
            self.layer = Game.world.player.layer
        end
        if not self.sound then
            self.sound = true
            Assets.playSound("impact", 1, 0.8)
        end
    else
        self.layer = Game.world.player.layer - 0.01
        self.slam_box.solid = false
        self.sound = nil
    end

end

function chr:slam_set(x, y, height, width)

            self.slam_box.height = height + 2
            self.hit.height = height

            self.slam_box.width = width + 2
            self.hit.width = width

            self.slam_box.x = self.x + x
            self.hit.x = x
            self.slam_box.y = self.y + y
            self.hit.y = y
end

return chr