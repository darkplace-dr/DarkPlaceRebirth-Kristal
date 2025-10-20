local shakytextobject, super = Class(Text)


function shakytextobject:draw()
    love.graphics.push()
    love.graphics.translate(math.random(-1, 1), math.random(-1, 1))
    super.draw(self)
    love.graphics.pop()
end

return shakytextobject
