local PointsChest, super = Class(Event, "pointschest")

function PointsChest:init(data)
    super.init(self, data)

    properties = data and data.properties or {}

    self:setOrigin(0.5, 0.5)
    self:setScale(2)

    self.sprite = Sprite("world/events/treasure_chest")
    self:addChild(self.sprite)

    self:setSize(self.sprite:getSize())
    self:setHitbox(0, 8, 20, 12)

    self.points = properties["points"]

    self.set_flag = properties["setflag"]
    self.set_value = properties["setvalue"]

    self.solid = true
end

function PointsChest:getDebugInfo()
    local info = super.getDebugInfo(self)
	if self.points then
		table.insert(info, "POINTs: " .. self.points)
	end
    table.insert(info, "Opened: " .. (self:getFlag("opened") and "True" or "False"))
    return info
end

--- Handles making the chest remain appearing open when re-entering the room
function PointsChest:onAdd(parent)
    super.onAdd(self, parent)

    if self:getFlag("opened") then
        self.sprite:setFrame(2)
    end
end

--- Handles opening the chest and giving the player their items
function PointsChest:onInteract(player, dir)
    if self:getFlag("opened") then
        self.world:showText("* (It's pointless.)")
    else
        Assets.playSound("locker")
        self.sprite:setFrame(2)
        self:setFlag("opened", true)

		Game.world:startCutscene(function(cutscene)
			cutscene:text("* You opened the chest.")
			cutscene:showPointsAdd(self.points)
			cutscene:text("* Inside was " .. self.points .. " POINTs!")
			Assets.playSound("item")
			cutscene:countPointsAdd()
			cutscene:text("* " .. self.points .. " POINTs was added to your SCORE.")
			cutscene:hidePointsAdd()
		end)
		
        if self.set_flag then
            Game:setFlag(self.set_flag, (self.set_value == nil and true) or self.set_value)
        end
    end

    return true
end

return PointsChest