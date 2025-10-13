local Egg, super = Class(ActorSprite)

function Egg:init(actor)
    super.init(self, actor)

    self.ray = EggRay(51, 46)
    self.ray.id = "ray"
    self.ray.layer = -10
    self:addChild(self.ray)

    self.hand = EggPart("battle/enemies/egg/hand", 16, 48, 0.5, 0)
    self.hand.id = "hand"
    self.hand.layer = -8
    self:addChild(self.hand)

    self.egg = EggEgg(52, 46)
    self.egg.id = "egg"
    self.egg.layer = -9
    self:addChild(self.egg)

    -- deltarune adds these parts in a very specific order which apparently influences swing speed
    self.parts = {
        self.egg,
        self.hand,
        self.ray,
    }

    self.swing_speed = 1
    self.swing_range = {math.rad(-10), math.rad(10)}

    self.timer = Timer()
    self:addChild(self.timer)
end

-- heck it, custom version
function Egg:setAnimation(anim, ...)
    if not ignore_actor then
        self.actor:onSetAnimation(self, anim, ...)
    end
end

function Egg:getPart(name)
    if isClass(name) then
        return name
    elseif self[name] then
        return self[name]
    else
        error("Part does not exist: "..name)
    end
end

function Egg:getPartIndex(part)
    for i,other in ipairs(self.parts) do
        if other == part then
            return i
        end
    end
end

function Egg:setPartSprite(name, path)
    local part = self:getPart(name)
    part:setSprite(path)
end

function Egg:setPartRotation(name, rotation)
    local part = self:getPart(name)
    part.swing_rotation = rotation
end

function Egg:tweenPartRotation(name, rotation, time, ease)
    local part = self:getPart(name)
    self.timer:tween(time or 0.5, part, {swing_rotation = rotation}, ease or "linear")
end

function Egg:setPartScale(name, scale_x, scale_y)
    local part = self:getPart(name)
    part:setScale(scale_x, scale_y or scale_x)
end

function Egg:tweenPartScale(name, scale_x, scale_y, time, ease)
    local part = self:getPart(name)
    self.timer:tween(time or 0.5, part, {scale_x = scale_x, scale_y = scale_y or scale_x}, ease or "linear")
end

function Egg:setPartShaking(name, shake)
    local part = self:getPart(name)
    if type(shake) == "number" then
        part.shake = shake
    elseif shake then
        part.shake = 0.5
    else
        part.shake = 0
    end
end

function Egg:setPartSwingShaking(name, shake)
    local part = self:getPart(name)
    if type(shake) == "number" then
        part.swing_shake = shake
    elseif shake then
        part.swing_shake = math.rad(2)
    else
        part.swing_shake = 0
    end
end

function Egg:setPartSwingSpeed(name, speed, keep_spin)
    local part = self:getPart(name)
    part.swing_speed = speed
    if speed == 0 then
        part.siner = 0
    end
    if keep_spin then
        part.swing_rotation = part.sprite.rotation
    end
end

function Egg:setPartSwingRange(name, min, max)
    local part = self:getPart(name)
    if not max then
        part.swing_range = {-min, min}
    elseif min then
        part.swing_range = {min, max}
    else
        part.swing_range = nil
    end
end

function Egg:tweenPartSwingRange(name, min, max, time, ease)
    local part = self:getPart(name)
    if not max then
        min, max = -min, min
    end
    if not part.swing_range then
        part.swing_range = Utils.copy(self.swing_range)
    end
    self.timer:tween(time or 0.5, part.swing_range, {min, max}, ease or "linear")
end

function Egg:setPartSine(name, value)
    local part = self:getPart(name)
    part.siner = value or 0
end

function Egg:setAllPartsShaking(shake)
    for _,part in ipairs(self.parts) do
        if type(shake) == "number" then
            part.shake = shake
        elseif shake then
            part.shake = 0.5
        else
            part.shake = 0
        end
    end
end

function Egg:setSwingSpeed(speed)
    self.swing_speed = speed
end

function Egg:setSwingRange(min, max)
    if not max then
        self.swing_range = {-min, min}
    else
        self.swing_range = {min, max}
    end
end

function Egg:setStringCount(num)
    if num < 4 then
        for i,str in ipairs(self.bg_strings) do
            if num == 0 then
                str.visible = false
            else
                str.visible = i == 9
            end
        end
    else
        for _,str in ipairs(self.bg_strings) do
            str.visible = true
        end
    end
    local keep = Utils.pickMultiple(self.fg_strings, num)
    for i=1,6 do
        local str = self.fg_strings[i]
        if Utils.containsValue(keep, str) then
            str.visible = true
        else
            str.visible = false
        end
    end
end

function Egg:snapString(index, remove)
    local str
    if index then
        str = self.fg_strings[index]
    else
        str = Utils.pick(self.fg_strings, function(v) return v.visible and v.alpha == 1 end)
    end
    if remove then
        str:remove()
        Utils.removeFromTable(self.fg_strings, str)
    else
        str.alpha = 0
        self.timer:after(1, function()
            str:fadeTo(1, 0.05)
        end)
    end
    local snap = self:addChild(SpamtonSnap(str.x + math.sin(str.siner/30)*2, str.y, str.top_x))
    self.timer:after(2, function()
        snap:remove()
    end)
end

function Egg:snapStrings(count, remove)
    for i=1,count do
        self:snapString(nil, remove)
    end
end

function Egg:resetPart(name, full)
    local part = self:getPart(name)
    part:reset(full, self:getPartIndex(part))
end

function Egg:resetParts(full)
    self.swing_speed = 1
    for i,part in ipairs(self.parts) do
        part:reset(full, i)
    end
end

return Egg