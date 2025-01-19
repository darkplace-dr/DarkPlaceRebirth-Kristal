local LightBattleMenuSelectItem, super = Class(Object, "LightBattleMenuSelectItem")

function LightBattleMenuSelectItem:init(x, y, options)
    super.init(self, x, y)

    options = options or {}

    self.selectable = options["selectable"] or true

    self.name = ""

    self.name_text = Text("", 0, 0, {font = options["font"] or "main_mono"})
    self.name_text.debug_rect = {0, 0, 0, 0}
    self:addChild(self.name_text)

    self.shake = options["shake"] or MagicalGlass.light_battle_text_shake
    self.shake_power = options["shake_power"] or 1

    self.party = {}
    self.icons = {}

    self.party_offset = 0
    self.icon_offset = 0
end

function LightBattleMenuSelectItem:getDebugRectangle()
    return {0, 0, 230, 32}
end

function LightBattleMenuSelectItem:setName(name)
    self.name = name

    if name ~= "" then
        -- this refused to work if i just directly set self.name_text's state
        local power = "[ut_shake:"..self.shake_power.."]"
        if (#self.party == 0 and #self.icons == 0) then
            if self.shake then
                name = power .. "* " .. name
            else
                name = "* " .. name
            end
        else
            if self.shake then
                name = power .. name
            end 
        end
    end

    self.name_text:setText(name)
end

function LightBattleMenuSelectItem:setNameColor(r, g, b, a)
    self.name_text:setColor(r, g, b, a)
end

function LightBattleMenuSelectItem:setParty(members)
    self.party = {}
    self.party_offset = 0
    for _,member in ipairs(members) do
        local chara = Game:getPartyMember(member)
        local ox, oy = chara:getHeadIconOffset()
    
        local icon = {
            ["texture"] = Assets.getTexture(chara:getHeadIcons() .. "/head"),
            ["offset_x"] = ox,
            ["offset_y"] = oy
        }
        table.insert(self.party, icon)
    end
    for _,icon in ipairs(self.party) do
        self.party_offset = self.party_offset + icon.texture:getWidth()
    end

    self:refresh()
end

function LightBattleMenuSelectItem:setIcons(icons)
    self.icons = {}
    self.icon_offset = 0
    for _,icon in ipairs(icons) do
        local icon = {
            ["texture"] = Assets.getTexture(icon.tex),
            ["offset_x"] = icon.off_x or 0,
            ["offset_y"] = icon.off_y or 0,
            ["spacing"] = icon.space or 0
        }
        table.insert(self.icons, icon)
    end
    for _,icon in ipairs(self.icons) do
        self.icon_offset = self.icon_offset + icon.texture:getWidth() + icon.spacing + 2
    end

    self:refresh()
end

function LightBattleMenuSelectItem:refresh()
    local total_icons = #self.party + #self.icons
    self.name_text.x = 0
    if total_icons > 0 then
        self.name_text.x = self.name_text.x + self.party_offset + self.icon_offset
    end
end

function LightBattleMenuSelectItem:clear()
    self.name = ""
    self.name_text:setText("")
    self.name_text:setColor(COLORS.white)

    self.party = {}
    self.icons = {}

    self:refresh()
end

function LightBattleMenuSelectItem:drawParty()
    local offset = 0
    for i, icon in ipairs(self.party) do
        local x = (((i - 1) * offset) + icon.offset_x) - 8
        local y = 5 + icon.offset_y
        Draw.draw(icon.texture, x, y)
        offset = offset + icon.texture:getWidth() + 2
    end
end

function LightBattleMenuSelectItem:drawIcons()
    local offset = 0
    for i, icon in ipairs(self.icons) do
        local x = self.party_offset + (((i - 1) * offset) + icon.spacing) - 8
              x = x + icon.offset_x
        local y = 5 + icon.offset_y
        Draw.draw(icon.texture, x, y)
        offset = offset + icon.texture:getWidth() + 2
    end
end


function LightBattleMenuSelectItem:draw()
    super.draw(self)

    Draw.setColor(COLORS.white)
    if #self.party > 0 then
        self:drawParty()
    end
    if #self.icons > 0 then
        self:drawIcons()
    end
end

return LightBattleMenuSelectItem