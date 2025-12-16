local DessimationCircler, super = Class(Sprite)

function DessimationCircler:init(target, i)
    super.init(self, target.sprite, target.x, target.y-target.height/2)

    self:setScale(2)
    self:setOrigin(0.5)

    self.target = target
    self.i = i

    self.elapsed_time = 0
end

function DessimationCircler:update()
    super.update(self)
    -- ideally I'd want 4 of these circling around Dess but when they spawn, they spawn all on her and like their circle radius rises and they form a circle around her (does that make sense)

    self:setSprite(self.target.sprite)
    self:setFrame(self.target.sprite.frame)
          --math.sin((2 * math.pi * i/#bullets) + w*self.elapsed_time) * arena.width / 2 + arena.x -- that was my refrence I took somewhere in Kristal server
    self.x = math.sin(2 * math.pi * self.i/4) + (1*self.elapsed_time) * self.target.width + self.target.x
    self.y = math.cos(2 * math.pi * self.i/4) + (1*self.elapsed_time) * self.target.height + self.target.y

    self.elapsed_time = self.elapsed_time + DT
end

function DessimationCircler:draw()
    super.draw(self)
end

return DessimationCircler