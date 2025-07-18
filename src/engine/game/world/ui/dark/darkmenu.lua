---@class DarkMenu : Object
---@overload fun(...) : DarkMenu
local DarkMenu, super = Class(Object)

function DarkMenu:init()
    super.init(self, 0, -80)

    self.layer = WORLD_LAYERS["ui"]

    self.parallax_x = 0
    self.parallax_y = 0

    self.animation_done = false
    self.animation_timer = 0
    self.animate_out = false

    self.selected_submenu = 1

    self.previous_selected = 5

    self.item_header_selected = 1
    self.equip_selected = 1
    self.power_selected = 1

    self.item_selected_x = 1
    self.item_selected_y = 1

    self.selected_party = 1
    self.party_select_mode = "SINGLE" -- SINGLE, ALL
    self.after_party_select = nil

    self.selected_item = 1

    self.state = "MAIN"
    self.state_reason = nil
    self.heart_sprite = Assets.getTexture("player/heart_menu_small")

    self.ui_move = Assets.newSound("ui_move")
    self.ui_select = Assets.newSound("ui_select")
    self.ui_cant_select = Assets.newSound("ui_cant_select")
    self.ui_cancel_small = Assets.newSound("ui_cancel_small")

    self.font = Assets.getFont("main")

    self.description_box = Rectangle(0, 0, SCREEN_WIDTH, 80)
    self.description_box:setColor(0, 0, 0)
    self.description_box.visible = false
    self.description_box.layer = 10
    self:addChild(self.description_box)

    self.description = Text("", 20, 10, SCREEN_WIDTH - 20, 80 - 16)
    self.description_box:addChild(self.description)

    self.buttons = {}
    self:addButtons()
    self.buttons = Kristal.callEvent(KRISTAL_EVENT.getDarkMenuButtons, self.buttons, self) or self.buttons

    self.box = nil
    self.box_offset_x = 0
    self.box_offset_y = 0
end

function DarkMenu:getButtonSpacing()
    if #self.buttons <= 4 then
        return 100
    else
        return 75
    end
end

function DarkMenu:getDotSpacing()
    if #self.buttons <= 8 then
        return 50
    else
        return 50 - Utils.round((#self.buttons/3*#self.buttons/3))
    end
end

function DarkMenu:addButton(button, index)
    index = index or #self.buttons + 1
    table.insert(self.buttons, index, button)
    return index
end

function DarkMenu:addButtons()
    if Game.tutorial then
        self:addButton({
            ["state"]          = "",
            ["sprite"]         = Assets.getTexture("ui/menu/btn/talk"),
            ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/talk_h"),
            ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/talk"),
            ["callback"]       = function()
                Game.world:startCutscene("_talk", "main", Game.world.map.id, Game.party[1].id)

                self.ui_select:stop()
                self.ui_select:play()
            end
        })
        return
    end
    -- ITEM
    self:addButton({
        ["state"]          = "ITEMMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/item"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/item_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/item"),
        ["callback"]       = function()
            self.box = DarkItemMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })

    -- EQUIP
    self:addButton({
        ["state"]          = "EQUIPMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/equip"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/equip_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/equip"),
        ["callback"]       = function()
            self.box = DarkEquipMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })

    -- POWER
    self:addButton({
        ["state"]          = "POWERMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/power"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/power_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/power"),
        ["callback"]       = function()
            self.box = DarkPowerMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })

    -- TALK
    self:addButton({
        ["state"]          = "",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/talk"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/talk_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/talk"),
        ["callback"]       = function()
            Game.world:startCutscene("_talk", "main", Game.world.map.id, Game.party[1].id)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })

    -- APM
	if Game:hasPartyMember("apm") then
		self:addButton({
			["state"]          = "APMMENU",
			["sprite"]         = Assets.getTexture("ui/menu/btn/apm"),
			["hovered_sprite"] = Assets.getTexture("ui/menu/btn/apm_h"),
			["desc_sprite"]    = Assets.getTexture("ui/menu/desc/apm"),
			["callback"]       = function()
				self.box = DarkAPMMenu()
				self.box.layer = -1
				self:addChild(self.box)

				self.ui_select:stop()
				self.ui_select:play()
			end
		})
	end

    -- BADGES
    if #Game.inventory:getStorage("badges") > 0 then
        self:addButton({
            ["state"]          = "BADGEMENU",
            ["sprite"]         = Assets.getTexture("ui/menu/btn/badge"),
            ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/badge_h"),
            ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/badge"),
            ["callback"]       = function()
                self.box = DarkBadgeMenu()
                self.box.layer = -1
                self:addChild(self.box)

                self.ui_select:stop()
                self.ui_select:play()
            end
        })
    end

    -- CONFIG
    self:addButton({
        ["state"]          = "CONFIGMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/config"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/config_h"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/config"),
        ["callback"]       = function()
            self.box = DarkConfigMenu()
            self.box.layer = -1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end
    })
end

function DarkMenu:getButton(id)
    for _,button in ipairs(self.buttons) do
        if button.id == id then
            return button
        end
    end
end

function DarkMenu:onAdd(parent)
    super.onAdd(self, parent)
    Game.world:showHealthBars()
    Kristal.callEvent(KRISTAL_EVENT.onDarkMenuOpen, self)
end

function DarkMenu:transitionOut()
    if Game.world.menu == self then
        Game.world.menu = nil
    end
    self.animate_out = true
    self.animation_timer = 0
    self.animation_done = false

    self.state = "MAIN"
    if self.box then
        self.box:remove()
    end
end

function DarkMenu:closeBox()
    self.state = "MAIN"
    if self.box then
        self.box:remove()
        self.box = nil
    end
end

function DarkMenu:setDescription(text, visible)
    self.description:setText(text)
    if visible ~= nil then
        self.description_box.visible = visible
    end
end

function DarkMenu:partySelect(mode, after)
    self.state_reason = self.state
    self.state = "PARTYSELECT"

    self.party_select_mode = mode or "SINGLE"
    self.after_party_select = after

    self:updateSelectedBoxes()
end

function DarkMenu:onKeyPressed(key)
    if self.box then
        if self.box.onKeyPressed then
            self.box:onKeyPressed(key)
        end
    end

    if (Input.isMenu(key) or Input.isCancel(key)) and self.state == "MAIN" then
        Game.world:closeMenu()
        return
    end

    if not self.animation_done then return end

    if self.state == "MAIN" then
        local old_selected = self.selected_submenu
        if Input.is("left", key)  then self.selected_submenu = self.selected_submenu - 1 end
        if Input.is("right", key) then self.selected_submenu = self.selected_submenu + 1 end
        if self.selected_submenu < 1             then self.selected_submenu = #self.buttons end
        if self.selected_submenu > #self.buttons then self.selected_submenu = 1             end
        if old_selected ~= self.selected_submenu then
            self.ui_move:stop()
            self.ui_move:play()
        end
        if Input.isConfirm(key) then
            self:onButtonSelect(self.selected_submenu)
        end
    elseif self.state == "PARTYSELECT" then
        if Input.isCancel(key) then
            Input.clear("cancel")
            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()

            self.state = self.state_reason
            if self.after_party_select then
                self.after_party_select(false)
            end

            self:updateSelectedBoxes()
            return
        end
        local old_selected = self.selected_party
        if self.party_select_mode == "SINGLE" then
            if Input.is("left", key) then
                self.selected_party = self.selected_party - 1
                self.ui_move:stop()
                self.ui_move:play()
            end
            if Input.is("right", key) then
                self.selected_party = self.selected_party + 1
                self.ui_move:stop()
                self.ui_move:play()
            end
        end
        if self.selected_party < 1 then self.selected_party = #Game.party end
        if self.selected_party > #Game.party then self.selected_party = 1 end
        if old_selected ~= self.selected_party then
            self:updateSelectedBoxes()
        end
        if Input.isConfirm(key) then
            Input.clear("confirm")
            self.state = self.state_reason
            self.state_reason = nil
            if self.after_party_select then
                if self.party_select_mode == "SINGLE" then
                    self.after_party_select(true, Game.party[self.selected_party])
                else
                    self.after_party_select(true, Game.party)
                end
            end
            self:updateSelectedBoxes()
        end
    end
end

function DarkMenu:onButtonSelect(button_index)
    if self.buttons[button_index].callback then
        self.state = self.buttons[button_index].state
        Input.clear("confirm")
        self.buttons[button_index].callback()

        if self.box then
            self.box.x = self.box.x + self.box_offset_x
            self.box.y = self.box.y + self.box_offset_y
        end
    end
end

function DarkMenu:updateSelectedBoxes()
    for _, actionbox in ipairs(Game.world.healthbar.action_boxes) do
        if self.state == "PARTYSELECT" and self.party_select_mode == "ALL" then
            actionbox.selected = true
            actionbox:setHeadIcon("heart")
        else
            actionbox.selected = false
            actionbox:setHeadIcon("head")
        end
    end
    if self.state == "PARTYSELECT" then
        Game.world.healthbar.action_boxes[self.selected_party].selected = true
        Game.world.healthbar.action_boxes[self.selected_party]:setHeadIcon("heart")
    end
end

function DarkMenu:update()
    self.animation_timer = self.animation_timer + DTMULT

    local max_time = self.animate_out and 3 or 8

    if self.animation_timer > max_time + 1 then
        self.animation_done = true
        self.animation_timer = max_time + 1
        if self.animate_out then
            self:remove()
            return
        end
    end

    if not self.animate_out then
        if self.y < 0 then
            if self.y > -40 then
                self.y = self.y + math.ceil(-self.y / 2.5) * DTMULT
            else
                self.y = self.y + 30 * DTMULT
            end
        else
            self.y = 0
        end
    else
        if self.y > -80 then
            if self.y > 0 then
                self.y = self.y - math.floor(self.y / 2.5) * DTMULT
            else
                self.y = self.y - 30 * DTMULT
            end
        else
            self.y = -80
        end
    end

    super.update(self)
end

function DarkMenu:draw()
    Draw.setColor(PALETTE["world_fill"])
    love.graphics.rectangle("fill", 0, 0, 640, 80)

    Draw.setColor(1, 1, 1, 1)
    if self.buttons[self.selected_submenu].desc_sprite then
        Draw.draw(self.buttons[self.selected_submenu].desc_sprite, 20, (#self.buttons > 5 and 20) or 24, 0, 2, 2)
    end

    for i = 1, #self.buttons do
        self:drawButton(i, 120 + ((i - 1) * self:getButtonSpacing()), ((#self.buttons > 5 and 14) or 20))
    end
    Draw.setColor(1, 1, 1)

    love.graphics.setFont(self.font)
    love.graphics.print(Game:getConfig("darkCurrencyShort") .. " " .. Game.money, 520, (#self.buttons > 5 and 20) or 26)

    super.draw(self)
end

function DarkMenu:drawButton(index, x, y)
    local button = self.buttons[index]
    local sprite = button.sprite
    if index == self.selected_submenu then
        sprite = button.hovered_sprite
    end

    local x_offset = 0
    if self.selected_submenu > self.previous_selected then
        self.previous_selected = self.selected_submenu
    end

    if self.selected_submenu < self.previous_selected - 4 then
        self.previous_selected = self.selected_submenu + 4
    end

    x_offset = ((self.previous_selected - 5) * 75)

    Draw.pushScissor()
    Draw.scissor(120, y, 366, 48)

    Draw.setColor(1, 1, 1)
    Draw.draw(sprite, x - x_offset, y, 0, 2, 2)
    if index == self.selected_submenu and self.state == "MAIN" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, x + 15 - x_offset, y + 25, 0, 2, 2, self.heart_sprite:getWidth() / 2, self.heart_sprite:getHeight() / 2)
    end

    Draw.popScissor()

    if #self.buttons > 5 then
        Draw.setColor(1, 1, 1)
        if Game:getConfig("darkMenuScroller") == "side" then
            Draw.rectangle("fill", 129 + (self.selected_submenu - 1) * ((472-132)/(#self.buttons-1)), 65, 10, 10)
            for index = 1, #self.buttons do
                Draw.rectangle("fill", 132 + (index - 1) * ((472-132)/(#self.buttons-1)), 68, 4, 4)
            end
        else
            Draw.setColor(1, 1, 1)
            Draw.rectangle("fill", (SCREEN_WIDTH/2 + 3) - ((#self.buttons/2 - (self.selected_submenu - 1)) * self:getDotSpacing()), 65, 10, 10)
            for index = 1, #self.buttons do
                Draw.rectangle("fill", (SCREEN_WIDTH/2 + 6) - ((#self.buttons/2 - (index - 1)) * self:getDotSpacing()), 68, 4, 4)
            end
        end
    end
end

return DarkMenu
