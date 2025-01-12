Utils.hook(Battler, "lightStatusMessage", function(orig, self, x, y, msg_type, arg, options)
    options = options or {}

    x, y = self:getRelativePos(x, 0)

    local offset_x, offset_y = self:getDamageOffset()

    local height_offset = 30
    local number_x, number_y = (x + offset_x), ((y - (height_offset * #self.popups)) + offset_y)

    -- optionify this
    if #self.popups >= 3 then
        number_y = number_y + 150
    end

    local show_mercy = MagicalGlass.light_battle_mercy_messages and self.show_mercy_gauge

    local number
    if (msg_type == "mercy" and show_mercy) then
        number = LightDamagePopup(msg_type, arg, self, number_x, number_y,
                 {remove_with_others = options["remove_with_others"], dont_animate = options["dont_animate"]})
    elseif msg_type == "damage" or msg_type == "heal" or msg_type == "msg" then
        number = LightDamagePopup(msg_type, arg, self, number_x, number_y, 
                 {color = options["color"], remove_with_others = options["remove_with_others"], dont_animate = options["dont_animate"]})
    end

    if number then
        self.parent:addChild(number)
    end

    if options["show_gauge"] or true then
        if (msg_type == "mercy" and show_mercy) or msg_type == "damage" or msg_type == "heal" then
            if self.gauge then
                if msg_type == "mercy" or msg_type == "heal" then 
                    self.gauge.gauge_target = self.gauge.gauge_target + arg
                elseif msg_type == "damage" then
                    self.gauge.gauge_target = self.gauge.gauge_target - arg
                end
                return
            end

            local gauge
            if msg_type == "mercy" then 
                gauge = LightEnemyGauge(msg_type, arg, self.mercy, 100, number_x, y + offset_y,
                                        {width = options["width"] or self:getGaugeWidth()})
            elseif msg_type == "damage" or msg_type == "heal" then
                gauge = LightEnemyGauge(msg_type, arg, self.health, self.max_health, number_x, y + offset_y,
                                        {width = options["width"] or self:getGaugeWidth()})
            end

            self.gauge = gauge
            self.parent:addChild(gauge)
        end
    end

    return number
end)