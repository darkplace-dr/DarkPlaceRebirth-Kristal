local AfterImageCutHalfTower, super = Class(Object)

function AfterImageCutHalfTower:init(texture, after)
    super.init(self, x, y)

    if type(texture) == "string" then
        texture = Assets.getTexture(texture) or (Assets.getFrames(texture)[1])
    end
    self.texture = texture

    self.start_color = {1, 1, 1}

    self.done = false
    self.after_func = after

    self.width, self.height = texture:getWidth(), texture:getHeight()
    self.xo, self.yo = self:getOrigin()
	
    self.spr_alpha = 1.5
    self.faderate = 0.1
    self.siner = 0
    
    self.flash = true
	
    self.flash_timer = Timer()
    self:addChild(self.flash_timer)
end

function AfterImageCutHalfTower:onAdd(parent)
    super.onAdd(parent)

    self.start_color = self.color
end

function AfterImageCutHalfTower:update()
    self.siner = self.siner + DTMULT
    self.spr_alpha = self.spr_alpha - self.faderate * DTMULT
	
    if self.spr_alpha <= 0 then
        self.done = true
        if self.after_func then
            self.after_func()
        end
        self:remove()
    end

    super.update(self)
end

return AfterImageCutHalfTower