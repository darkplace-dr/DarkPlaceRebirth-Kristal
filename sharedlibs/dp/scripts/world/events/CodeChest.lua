--- A Code Chest that can contain code blocks for APM. \
--- `CodeChest` is an [`Event`](lua://Event.init) - naming an object `chest` on an `objects` layer in a map creates this object. \
--- See this object's Fields for the configurable properties on this object.
---
---@class CodeChest : Event
---
---@field sprite    Sprite
---@field solid     boolean
---
---@field code      string      *[Property `item`]* The ID of the code block contianed in this treasure chest
---
---@field set_flag  string      *[Property `setflag`]* An optional flag to set when the treasure chest is opened
---@field set_value any         *[Property `setvalue`]* The value to set on the flag specified by `setflag` (Defaults to `true`)
---
---@overload fun(...) : CodeChest
local CodeChest, super = Class(Event, "codechest")

function CodeChest:init(data)
    super.init(self, data.x, data.y)

    properties = data.properties or {}

    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    self.sprite = Sprite("world/events/code_chest")
    self:addChild(self.sprite)

    self:setSize(self.sprite:getSize())
    self:setHitbox(0, 8, 20, 12)

    self.codeblock = properties["code"]
    
    assert(self.codeblock ~= nil, "Every CodeChest must have a code block.")

    self.set_flag = properties["setflag"]
    self.set_value = properties["setvalue"]

    self.solid = true
end

function CodeChest:getDebugInfo()
    local info = super.getDebugInfo(self)
    table.insert(info, "Code Block: " .. self.codeblock)
    table.insert(info, "Opened: " .. (Utils.containsValue(Game:getFlag("unlocked_codeblocks"), self.codeblock) and "True" or "False"))
    return info
end

--- Handles making the chest remain appearing open when re-entering the room
function CodeChest:onAdd(parent)
    super.onAdd(self, parent)

    if Utils.containsValue(Game:getFlag("unlocked_codeblocks"), self.codeblock) then
        self.sprite:setFrame(2)
    end
    
    if not Game:hasUnlockedPartyMember("apm") then
        self:remove()
    end
end

--- Handles opening the chest and giving the player their items
function CodeChest:onInteract(player, dir)
    if Utils.containsValue(Game:getFlag("unlocked_codeblocks"), self.codeblock) then
        self.world:showText("* (The chest is empty.)")
    else
        Assets.playSound("locker")
        self.sprite:setFrame(2)
        table.insert(Game:getFlag("unlocked_codeblocks"), self.codeblock)

        local name = self.codeblock
        local result_text = "* ([color:yellow]"..name.."[color:reset] was added to your [color:yellow]CODE BLOCKS[color:reset].)"

        self.world:showText({
            "* (You opened the code chest.)[wait:5]\n* (Inside was [color:yellow]"..name.."[color:reset].)",
            result_text
        })

        if self.set_flag then
            Game:setFlag(self.set_flag, (self.set_value == nil and true) or self.set_value)
        end
    end

    return true
end

return CodeChest
