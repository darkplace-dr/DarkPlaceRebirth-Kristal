local ShuttahSpeechBubble, super = Class(SpeechBubble)

function ShuttahSpeechBubble:getTailWidth()
    return 0
end

function ShuttahSpeechBubble:draw()
    if not self.auto then
        Draw.draw(self:getSprite(), 0, 0)
    else
        local inner_left = -self.padding["left"]
        local inner_top = -self.padding["top"]
        local inner_right = self.text_width + self.padding["right"]
        local inner_bottom = self.text_height + self.padding["bottom"]

        local inner_width = self.padding["left"] + inner_right
        local inner_height = self.padding["top"] + inner_bottom

        local offset = 0

        local sprite_fill = self:getSprite("fill")
        local sprite_tail = self:getSprite("tail")

        local sprite_left   = self:getSprite("left"  )
        local sprite_top    = self:getSprite("top"   )
        local sprite_right  = self:getSprite("right" )
        local sprite_bottom = self:getSprite("bottom")

        local sprite_top_left     = self:getSprite("top_left"    )
        local sprite_top_right    = self:getSprite("top_right"   )
        local sprite_bottom_left  = self:getSprite("bottom_left" )
        local sprite_bottom_right = self:getSprite("bottom_right")


        if sprite_fill then Draw.draw(sprite_fill, offset + inner_left, inner_top, 0, inner_width / sprite_fill:getWidth(), inner_height / sprite_fill:getHeight()) end

        if sprite_left   then Draw.draw(sprite_left,   offset + inner_left - sprite_left:getWidth(), inner_top,                          0, 1,                                      inner_height / sprite_left:getHeight())  end
        if sprite_top    then Draw.draw(sprite_top,    offset + inner_left,                          inner_top - sprite_top:getHeight(), 0, inner_width / sprite_top:getWidth(),    1)                                       end
        if sprite_right  then Draw.draw(sprite_right,  offset + inner_right,                         inner_top,                          0, 1,                                      inner_height / sprite_right:getHeight()) end
        if sprite_bottom then Draw.draw(sprite_bottom, offset + inner_left,                          inner_bottom,                       0, inner_width / sprite_bottom:getWidth(), 1)                                       end

        if sprite_top_left     then Draw.draw(sprite_top_left,     offset + inner_left - sprite_top_left:getWidth(),    inner_top - sprite_top_left:getHeight())  end
        if sprite_top_right    then Draw.draw(sprite_top_right,    offset + inner_right,                                inner_top - sprite_top_right:getHeight()) end
        if sprite_bottom_left  then Draw.draw(sprite_bottom_left,  offset + inner_left - sprite_bottom_left:getWidth(), inner_bottom)                             end
        if sprite_bottom_right then Draw.draw(sprite_bottom_right, offset + inner_right,                                inner_bottom)                             end

        local scale = 1
        if self.text.width < 35 then
            scale = 0.5
        end

        if sprite_tail then
            local _, bottom = self:getSpriteSize("bottom")
            Draw.draw(sprite_tail, (self.text_width / 2 + 1 + (sprite_tail:getWidth() / 2)), inner_bottom + bottom, math.rad(90), 1, 1)
        end
    end

    super.super.draw(self)
end

return ShuttahSpeechBubble