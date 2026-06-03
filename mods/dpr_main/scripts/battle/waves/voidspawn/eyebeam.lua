local EyeBeam, super = Class(Wave)

function EyeBeam:init()
    super.init(self)

    self.voidspawn = self:getAttackers()
    for _, voidspawn in ipairs(self.voidspawn) do
        voidspawn.sprite:setEyeState("FOLLOWING")
    end
end

function EyeBeam:onStart()
    for _, voidspawn in ipairs(self.voidspawn) do
        local x, y = voidspawn:getRelativePos(voidspawn.width/2 + voidspawn.sprite.iris_x, voidspawn.height/2 + voidspawn.sprite.iris_y)
        self:spawnBullet("voidspawn/eyebeam_controller", x, y, voidspawn)
    end
end

function EyeBeam:onEnd()
    super.onEnd(self)

    for _, voidspawn in ipairs(self.voidspawn) do
        voidspawn.sprite:setEyeState("SET", voidspawn.x - 10, voidspawn.y + 30)
    end
end

function EyeBeam:update()
    -- Code here gets called every frame

    super.update(self)
end

return EyeBeam