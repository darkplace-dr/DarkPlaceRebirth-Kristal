--- A Treasure Chest that can contain either an Item or some money. \
--- `TreasureChest` is an [`Event`](lua://Event.init) - naming an object `chest` on an `objects` layer in a map creates this object. \
--- See this object's Fields for the configurable properties on this object.
---
---@class GlowItem : Event
---
---@field sprite    Sprite
---@field solid     boolean
---
---@field item      string      *[Property `item`]* The name of the item contianed in this treasure chest - cannot be used in conjunction with `money`
---@field money     number      *[Property `money`]* The amount of money contained in this treasure chest - cannot be used in conjunction with `item`
---
---@field set_flag  string      *[Property `setflag`]* An optional flag to set when the treasure chest is opened
---@field set_value any         *[Property `setvalue`]* The value to set on the flag specified by `setflag` (Defaults to `true`)
---
---@overload fun(...) : GlowItem
local GlowItem, super = Class(Event, "glowitem")

function GlowItem:init(x, y, properties)
    super.init(self, x, y)

    properties = properties or {}

    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    self.sprite = Sprite("effects/criticalswing/sparkle")
    self.sprite:play(1/6)
    self:addChild(self.sprite)

    self:setSize(self.sprite:getSize())
    self:setHitbox(2, 2, 4, 4)

    self.sound = properties["sound"] or "item"
    self.item = properties["item"]
    self.money = properties["money"]
    self.testing = properties["test"]

    self.set_flag = properties["setflag"]
    self.set_value = properties["setvalue"]

    if self.testing and self:getFlag("grabbed") == true then
        self:setFlag("grabbed", false)
    end
end

function GlowItem:getDebugInfo()
    local info = super.getDebugInfo(self)
    if self.item then
        table.insert(info, "Item: " .. self.item)
    end
    if self.money then
        if not Game:isLight() then
            table.insert(info, "Money: " .. Game:getConfig("darkCurrencyShort") .. " " .. self.money)
        else
            table.insert(info, Game:getConfig("lightCurrency").. ": " .. Game:getConfig("lightCurrencyShort") .. " " .. self.money)
        end
    end
    table.insert(info, "Grabbed: " .. (self:getFlag("grabbed") and "True" or "False"))
    return info
end

--- Handles making the chest remain appearing open when re-entering the room
function GlowItem:onAdd(parent)
    super.onAdd(self, parent)

    if self:getFlag("grabbed") then
        self.sprite.alpha = 0
    end
end

--- Handles opening the chest and giving the player their items
function GlowItem:onInteract(player, dir)
    if self:getFlag("grabbed") == true then return end

    local name, success, result_text
    self.sprite.alpha = 0
    self:setFlag("grabbed", true)
    if self.item then
        local item = self.item
        if type(item) == "string" then
            item = Registry.createItem(self.item)
        end
        success, result_text = Game.inventory:tryGiveItem(item)
        if success then
            Assets.playSound(self.sound)
        end
        name = item:getName()
    elseif self.money then
        name = self.money.." "..Game:getConfig("darkCurrency")
        success = true
        result_text = "* ([color:yellow]"..name.."[color:reset] was added to your [color:yellow]MONEY HOLE[color:reset].)"
        Game.money = Game.money + self.money
    end

    print("Name = " .. tostring(name))
    if name then
        if not success then
            self.sprite.alpha = 1
            self:setFlag("grabbed", false)
        end
        self.world:showText({
            "* (You picked the glowing\nitem.)[wait:5]\n* ([color:yellow]"..name.."[color:reset] was added to your ITEMS.)",
            result_text})
    else
        local flavourtext = {
            {"* (The glow dissipates and dies.\ntaking its contents with it.)",
            function() Assets.playSound("crowd_gasp") end},
            {"* (The item ran away.)",
            function() local snds = {"defeatrun","him_quick","hypnosis"} Assets.playSound(snds[love.math.random(1,#snds)]) end},
            {"* (There's a fading note here:\n\"The item was the friends you made along the way.\")",
            function() Assets.playSound("crowd_crickets") end},
            {"* (You sneeze, [sound:]the item flies away.)",
            function() Assets.playSound("jackolantern_dizzy") end},
            {"* You close your eyes...\nand when you open them again\n* What?!! the item its gone!",
            function() Assets.playSound("board_text_end") end},
            {"* (The item cried away.)",
            function() Assets.playSound("closet_fall") end}
        }
        local text = {"* (The glow dissipates on contact.)",
        function() Assets.playSound("hypnosis") end}
        local rng = love.math.random(1,40)
        if rng >= 4 and rng < 7 then
            text = flavourtext[1]
        elseif rng >= 12 and rng < 15 then
            text = flavourtext[2]
        elseif rng >= 23 and rng < 27 then
            text = flavourtext[3]
        elseif rng >= 32 and rng < 35 then
            text = flavourtext[4]
        elseif rng >= 36 and rng < 38 then
            text = flavourtext[5]
        elseif rng > 38 then
            text = flavourtext[6]
        end
        if type(text) == "table" then
            text[2]()
            text = text[1]
        end
        self.world:showText(text)
        success = true
    end

    if success and self.set_flag then
        Game:setFlag(self.set_flag, (self.set_value == nil and true) or self.set_value)
    end

    return true
end

return GlowItem