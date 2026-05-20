local ActionBox, super = HookSystem.hookScript(ActionBox)

function ActionBox:init(x, y, index, battler)
    super.init(self, x, y, index, battler)

    self.name_offset_x, self.name_offset_y = battler.chara:getNameOffset()

    if self.name_sprite then
        self.name_sprite:setPosition(51 + self.name_offset_x, 14 + self.name_offset_y)
    end

    self.main_font = Assets.getFont("main")

    self.reaction_text = ""
    self.reaction_alpha = 0

    if Game:getFlag("SHINY", {})[battler.actor:getShinyID()] and not (Game.world and Game.world.map.dont_load_shiny) then
        self.name_sprite:addFX(GradientFX(COLORS.white, { 235 / 255, 235 / 255, 130 / 255 }, 1, math.pi / 2))
    end
end

function ActionBox:createButtons()
    for _, button in ipairs(self.buttons or {}) do
        button:remove()
    end

    self.buttons = {}

    local btn_types = { "fight", "act", "magic", "item", "spare", "defend" }

    if self.battler.chara.set_buttons then
        btn_types = self.battler.chara.set_buttons
    elseif self.battler.chara:hasSkills() then
        btn_types = { "fight", "skill", "item", "spare", "defend" }
    else
        if not self.battler.chara:hasAct() then TableUtils.removeValue(btn_types, "act") end
        if not self.battler.chara:hasSpells() then TableUtils.removeValue(btn_types, "magic") end
    end

    for lib_id, _ in Kristal.iterLibraries() do
        btn_types = Kristal.libCall(lib_id, "getActionButtons", self.battler, btn_types) or btn_types
    end
    btn_types = Kristal.modCall("getActionButtons", self.battler, btn_types) or btn_types

    local start_x = (213 / 2) - ((#btn_types - 1) * 35 / 2) - 1

    if (#btn_types <= 5) and Game:getConfig("oldUIPositions") then
        start_x = start_x - 5.5
    end

    if (#btn_types <= 6) and Game:getConfig("oldUIPositions") then
        start_x = 30
    end

    for i, btn in ipairs(btn_types) do
        if type(btn) == "string" then
            local button = ActionButton(btn, self.battler, math.floor(start_x + ((i - 1) * 35)) + 0.5, 21)
            button.actbox = self
            table.insert(self.buttons, button)
            self:addChild(button)
        elseif type(btn) ~= "boolean" then -- nothing if a boolean value, used to create an empty space
            btn:setPosition(math.floor(start_x + ((i - 1) * 35)) + 0.5, 21)
            btn.battler = self.battler
            btn.actbox = self
            table.insert(self.buttons, btn)
            self:addChild(btn)
        end
    end

    self.selected_button = MathUtils.clamp(self.selected_button, 1, #self:getSelectableButtons())
end

function ActionBox:setHeadIcon(icon)
    self.force_head_sprite = true

    self.head_sprite:setColor(1, 1, 1)

    local full_icon = self.battler.chara:getHeadIcons() .. "/" .. icon
    if self.head_sprite:hasSprite(full_icon) then
        self.head_sprite:setSprite(full_icon)
    else
        self.head_sprite:setSprite(self.battler.chara:getHeadIcons() .. "/head")
    end
end

function ActionBox:resetHeadIcon()
    self.force_head_sprite = false

    self.head_sprite:setColor(1, 1, 1)

    local full_icon = self.battler.chara:getHeadIcons() .. "/" .. self.battler:getHeadIcon()
    if Assets.hasSprite(full_icon) then
        self.head_sprite:setSprite(full_icon)
    else
        self.head_sprite:setSprite(self.battler.chara:getHeadIcons() .. "/head")
    end
end

function ActionBox:react(text, display_time)
    self.reaction_alpha = display_time and (display_time * 30) or 50
    self.reaction_text = text
end

function ActionBox:update()
    self.selection_siner = self.selection_siner + 2 * DTMULT

    self:animateBox()

    self.head_sprite.y = 11 - self.data_offset + self.head_offset_y
    if self.name_sprite then
        self.name_sprite.y = 14 - self.data_offset + self.name_offset_y
    end
    self.hp_sprite.y = 22 - self.data_offset

    if not self.force_head_sprite then

        --its a bit messy but i dont have the willpower to clean it

        local current_head = self.battler.chara:getHeadIcons() .. "/" .. self.battler:getHeadIcon()
        local head_has_icons = true
        if not Assets.hasSprite(current_head) then
            current_head = "ui/battle/icon/" .. self.battler:getHeadIcon()
            head_has_icons = false
            local exceptions = {"autoattack", "combo", "skip", "swap", "tension"}
            if TableUtils.contains(exceptions, self.battler:getHeadIcon()) or not self.head_sprite:hasSprite(current_head) then
                current_head = self.battler.chara:getHeadIcons() .. "/head"
            end
        end

        if not self.head_sprite:isSprite(current_head) then
            local color = { 1, 1, 1 }
            self.head_sprite:setColor(self.battler.chara.icon_color or color)
            local dont_set_color = {"head", "head_hurt", "head_low", "autoattack", "combo", "skip", "swap", "tension"}
            if TableUtils.contains(dont_set_color, self.battler:getHeadIcon()) or head_has_icons == true then
                -- These icons are already colored and don't play nice with the coloring system.
                self.head_sprite:setColor(color)
            end
            self.head_sprite:setSprite(current_head)
        end
    end

    for i, button in ipairs(self:getSelectableButtons()) do
        if (Game.battle.current_selecting == self.index) then
            button.selectable = true
            button.hovered = (self.selected_button == i)
        else
            button.selectable = false
            button.hovered = false
        end
    end

    self.reaction_alpha = self.reaction_alpha - DTMULT

    super.super.update(self)
end

function ActionBox:draw()
    -- basically uhh it starts moving up when the alpha gets below 1
    local y_offset = self.reaction_alpha / 6
    y_offset = math.min(y_offset, 1)
    y_offset = y_offset * 20

	love.graphics.setFont(self.main_font)
	Draw.setColor(1, 1, 1, self.reaction_alpha / 6)
	love.graphics.print(self.reaction_text, 106 - self.main_font:getWidth(self.reaction_text)*0.5/2, -36 + y_offset, 0, 0.5, 0.5)

    super.draw(self)
end

return ActionBox