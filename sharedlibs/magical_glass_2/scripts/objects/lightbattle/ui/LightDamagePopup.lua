local LightDamagePopup, super = Class(Object, "LightDamagePopup")

-- Types: "mercy", "damage", "msg", "special"
-- arg:
--    "mercy"/"damage": amount
--    "msg": message sprite name ("down", "frozen", "lost", "max", "mercy", "miss", "recruit", and "up")
--    "special": ??????

function LightDamagePopup:init(popup_type, arg, enemy, x, y, options)
    super.init(self, x, y)
    options = options or {}

    self:setOrigin(0.5, 1)

    self.layer = BATTLE_LAYERS["damage_numbers"]

    self.type = popup_type or "msg"
    self.enemy = enemy

    self.arg = arg or 0

    self.physics.gravity_direction = math.rad(90)

    -- The texture of the message if type is "msg."
    self.texture = nil
    -- The numbers displayed if type is "damage" or "mercy."
    self.text = nil

    self.font = nil

    self.color = options["color"]

    self.remove_others = options["remove_others"] or false
    self.remove_with_others = options["remove_with_others"] or true

    self.dont_animate = options["dont_animate"] or false
    self.start_speed_y = -4
    self.start_gravity = 0.6

    self.remove_timer = options["remove_after"] or 40
    self.special_messages = options["special_messages"]

    self.timer = 0
    self.delay = options["delay"] or 2

    self.started = false

    self:setup()
end

function LightDamagePopup:onAdd(parent)
    if self.remove_with_others then
        for _,child in ipairs(parent.children) do
            if isClass(child) and child:includes(LightDamagePopup) then
                child.remove_timer = self.remove_timer + 5
            end
        end
    end

    if self.enemy then
        table.insert(self.enemy.popups, self)
    end
end

function LightDamagePopup:onRemove()
    if self.enemy then
        Utils.removeFromTable(self.enemy.popups, self)

        if self.enemy.gauge and #self.enemy.popups == 0 then
            self.enemy.gauge:remove()
            self.enemy.gauge = nil
        end
    end
end

function LightDamagePopup:setup()
    if self.type == "msg" then
        self:setupMessage()
    elseif self.type == "damage" then
        self:setupDamage()
    elseif self.type == "heal" then
        self:setupHeal()
    elseif self.type == "mercy" then
        self:setupMercy()
    elseif self.type == "special" then
        self:setupSpecial()
    end
end

function LightDamagePopup:setupMessage()
    if not self.arg or type(self.arg) ~= "string" then
        self.arg = "miss"
    end

    self.texture = Assets.getTexture("ui/lightbattle/msg/" .. self.arg)
    self.width = self.texture:getWidth()
    self.height = self.texture:getHeight()

    if not self.color then
        if self.arg == "miss" then
            self.color = COLORS.silver
        else
            self.color = COLORS.white
        end
    end
end

function LightDamagePopup:setupDamage()
    self.font = Assets.getFont("lwdmg")

    self.text = tostring(self.arg)

    self.width = self.font:getWidth(self.text)
    self.height = self.font:getHeight()

    if not self.color then
        self.color = COLORS.red
    end
end

function LightDamagePopup:setupHeal()
    self.font = Assets.getFont("lwdmg")

    self.text = "+" .. self.arg

    self.width = self.font:getWidth(self.text)
    self.height = self.font:getHeight()

    if not self.color then
        self.color = COLORS.lime
    end
end

function LightDamagePopup:setupMercy()
    self.font = Assets.getFont("lwdmg")

    if self.arg == 100 then
        self.color = COLORS.lime
    elseif self.arg < 0 then
        self.color = {191/255, 181/255, 0, 1}
    else
        self.color = COLORS.yellow
    end

    self.text = tostring(self.arg)

    if self.arg > 0 then
        self.text = "+" .. self.arg .. "%"
    else
        self.text = self.arg .. "%"
    end

    self.width = self.font:getWidth(self.text)
    self.height = self.font:getHeight()
end

function LightDamagePopup:setupSpecial()
    self.width = 100

    self.font = Assets.getFont("main")

    if not self.color then
        self.color = COLORS.red
    end
    
    if not self.special_messages then
        self.special_messages = {
            "Don't worry about it.",
            "Absorbed",
            "I'm lovin' it.",
            "But it didn't work.",
            "nope",
            "FAILURE"
        }
    end
end

function LightDamagePopup:update()
    self.timer = self.timer + DTMULT

    if not self.started and (self.timer >= self.delay) then
        if not self.dont_animate then
            self.physics.speed_y = self.start_speed_y
            self.physics.gravity = self.start_gravity
        end
        self.started = true
    else
        -- In UNDERTALE, the numbers are set to stop once they reach their
        -- initial y position, but they still occasionally go over
        if self.y - 5 > self.init_y then
            self:resetPhysics()
            self.y = self.init_y
        end

        self.remove_timer = self.remove_timer - DTMULT
        if self.remove_timer < 0 then
            self:remove()
            return
        end
    end

    super.update(self)
end

function LightDamagePopup:drawMessage()
    Draw.draw(self.texture, 0, 0)
end

function LightDamagePopup:drawNumbers()
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, 0, 0)
end

function LightDamagePopup:drawSpecial()
    love.graphics.setFont(self.font)
    love.graphics.print(Utils.pick(self.special_messages), 20, 20)
end

function LightDamagePopup:draw()
    if self.started then
        Draw.setColor(self.color)
        if self.type == "special" then
            self:drawSpecial()
        elseif self.type == "msg" then
            self:drawMessage()
        elseif self.type == "damage" or self.type == "heal" or self.type == "mercy" then
            self:drawNumbers()
        end
    end

    super.draw(self)
end

return LightDamagePopup