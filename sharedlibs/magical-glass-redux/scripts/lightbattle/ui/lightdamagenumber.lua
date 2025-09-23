local LightDamageNumber, super = Class(Object)

function LightDamageNumber:init(msg_type, arg, x, y, color, enemy)
    super.init(self, x, y)
    
    self.font = Assets.getFont("lwdmg")

    self:setOrigin(0.5)

    self.physics.speed_y = -4
    self.physics.gravity = 0.5
    self.physics.gravity_direction = math.rad(90)
    
    self.enemy = enemy

    self.layer = LIGHT_BATTLE_LAYERS["damage_numbers"]

    self.type = msg_type or "text"
    
    self.color = color or (self.type == "damage" and COLORS.red or COLORS.silver)

    if self.type == "text" then
        self.text = arg or "MISSING"
    elseif self.type == "special" then
        if type(arg) == "table" then
            self.special_messages = arg
        elseif arg then
            self.special_messages = {arg}
        elseif arg == false then
            self.special_messages = false
        end
    elseif self.type == "msg" then
        self.message = arg
    elseif self.type == "damage" and Utils.sub(tostring(arg or 0), 1, 1) == "+" and self.enemy.health + tonumber(arg) >= self.enemy.max_health then
        self.type = "text"
        self.text = "MAX"
    else
        self.amount = arg or 0
        if self.type == "mercy" then
            if self.amount == 100 then
                self.color = COLORS.lime
            else
                self.color = COLORS.yellow
            end
            if self.amount >= 0 then
                self.text = "+"..self.amount.."%"
            else
                self.text = self.amount.."%"
            end
        else
            self.text = tostring(self.amount)
        end
        self.text = self.text:upper()
    end

    if self.type ~= "special" then
        if self.message then
            self.texture = Assets.getTexture("ui/lightbattle/msg/"..self.message)
            self.width = self.texture:getWidth()
            self.height = self.texture:getHeight()
        elseif self.text then
            self.width = self.font:getWidth(self.text)
            self.height = self.font:getHeight()
        end
    end

    self.timer = 0
    self.special_timer = 0
    
    self.special_messages = self.special_messages or self.special_messages ~= false and type(self.enemy.special_messages) == "table" and self.enemy.special_messages or {
        "Don't worry about it.",
        "Absorbed",
        "I'm lovin' it.",
        "But it didn't work.",
        "nope",
        "FAILURE"
    }
    
    self.special_message = Utils.pick(self.special_messages)

    self.start_x = nil
    self.start_y = nil

    self.kill_timer = 0
    self.do_once = false
    self.kill_others = false
    self.kill_condition = function ()
        return true
    end
    self.kill_condition_succeed = false
    self.gauge = nil
end

function LightDamageNumber:onAdd(parent)
    self.parent = parent
    for _,v in ipairs(parent.children) do
        if isClass(v) and (v:includes(LightDamageNumber)) then
            if self.kill_others then
                if (v.timer >= 1) then
                    v.killing = true
                end
            else
                v.kill_timer = 0
            end
        end
    end
    self.killing = false
end

function LightDamageNumber:update()
    if not self.start_x then
        self.start_x = self.x
    end
    if not self.start_y then
        self.start_y = self.y
    end

    super.update(self)

    self.timer = self.timer + DTMULT

    if not self.do_once then
        self.do_once = true
        self.start_speed_y = self.physics.speed_y
    end

    if self.y - 7 >= self.start_y then
        self:resetPhysics()
        self.y = self.start_y
    end

    self.kill_timer = self.kill_timer + DTMULT
    if self.kill_timer >= 48 then
        for _,obj in ipairs(self.parent.children) do
            if isClass(obj) and obj:includes(LightGauge) then
                obj:remove()
            end
        end
        self:remove()
        self.enemy.active_msg = self.enemy.active_msg - 1
        return
    end
    
    if self.kill_condition_succeed or self.kill_condition() then
        self.kill_condition_succeed = true
    end
end

function LightDamageNumber:draw()
    super.draw(self)

    if self.type == "special" then
        self.width = 100
        self.special_timer = self.special_timer + DTMULT
        Draw.setColor(self:getDrawColor())
        love.graphics.setFont(Assets.getFont("main"))
        if self.special_timer >= 1 then
            self.special_message = Utils.pick(self.special_messages)
            self.special_timer = 0
        end
        love.graphics.print(self.special_message)
    else
        Draw.setColor(self:getDrawColor())
        if self.texture then
            Draw.draw(self.texture, 0, 0)
        elseif self.text then
            love.graphics.setFont(self.font)
            love.graphics.print(self.text, 0, 0)
        end
    end
end

return LightDamageNumber