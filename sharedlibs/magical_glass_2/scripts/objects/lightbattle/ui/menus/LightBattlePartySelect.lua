local LightBattlePartySelect, super = Class(Object, "LightBattlePartySelect")

function LightBattlePartySelect:init(x, y, cursor_memory)
    super.init(self, x, y)

    self.active = false
    self.visible = false

    self.members = {}

    self.current_member = 1

    self.cursor_memory = cursor_memory

    self.text = {}
    self:createText()

    self.select_callback = nil
    self.cancel_callback = nil
end

function LightBattlePartySelect:onActivated()
    self.active = true
    self.visible = true
end

function LightBattlePartySelect:onDeactivated()
    self.active = false
    self.visible = false
end

function LightBattlePartySelect:getCurrentMember()
    return self.members[self.current_member]
end

function LightBattlePartySelect:getCurrentText()
    return self.text[self.current_member]
end

function LightBattlePartySelect:createText()
    for i = 0, 2 do
        local text = LightBattlePartySelectItem(0, i * 32)
        table.insert(self.text, text)
        self:addChild(text)
    end
end

function LightBattlePartySelect:setup(party)
    self:clear()

    self.visible = true

    for _,member in ipairs(party) do
        self:addMember(member)
    end

    if not self.cursor_memory then
        self.current_member = 1
    end

    self:refresh()
end

function LightBattlePartySelect:refresh()
    for i, text in ipairs(self.text) do
        local member = self.members[i]

        if member then
            text:setName(member.name)

            text.health = member.health
            text.max_health = member.max_health
        else
            text:clear()
        end
    end
end

function LightBattlePartySelect:setCallback(callback)
    self.select_callback = callback
end

function LightBattlePartySelect:setCancelCallback(callback)
    self.cancel_callback = callback
end

function LightBattlePartySelect:addMember(member)
    if type(member) == "table" then
        member = {
            ["id"] = member.id,
            ["name"] = member.chara:getName(),
            ["health"] = member.chara:getHealth(),
            ["max_health"] = member.chara:getStat("health"),
            ["data"] = member
        }
    end
    table.insert(self.members, member)

    self:refresh()
end

function LightBattlePartySelect:onKeyPressed(key)
    if self.active then
        if Input.isConfirm(key) then
            self:select(self:getCurrentMember())
        elseif Input.isCancel(key) then
            self:cancel()
        elseif Input.is("up", key) then
            self:previousMember()
        elseif Input.is("down", key) then
            self:nextMember()
        end
    end
end

function LightBattlePartySelect:nextMember()
    if #self.members < 1 then return end

    self.current_member = self.current_member + 1

    if self.current_member > #self.members then
        self.current_member = 1
    end

    -- lmao
    if #self.members > 1 then
        Game.battle:playMoveSound()
    end

    self:refresh()
end

function LightBattlePartySelect:previousMember()
    if #self.members < 1 then return end

    self.current_member = self.current_member - 1

    if self.current_member < 1 then
        self.current_member = #self.members
    end

    if #self.members > 1 then
        Game.battle:playMoveSound()
    end

    self:refresh()
end

function LightBattlePartySelect:select(member)
    Game.battle:playSelectSound()

    if self.select_callback then
        self.select_callback(member.data)
    end
end
    
function LightBattlePartySelect:cancel()
    if self.cancel_callback then
        self.cancel_callback()
    end

    self:clear()
end

function LightBattlePartySelect:update()
    if self.active then
        self:snapSoulToItem()
    end

    super.update(self)
end

function LightBattlePartySelect:snapSoulToItem()
    if Game.battle.soul then
        if self:getCurrentText() then
            local x, y = self:getCurrentText():getRelativePosFor(Game.battle)
            Game.battle.soul:setPosition(x - 27, y + 16)
        else
            Game.battle.soul:setPosition(0, 0)
        end
    end
end

function LightBattlePartySelect:clear()
    self.visible = false

    self.members = {}

    self.select_callback = nil
    self.cancel_callback = nil

    for _,text in ipairs(self.text) do
        text:clear()
    end
end

return LightBattlePartySelect