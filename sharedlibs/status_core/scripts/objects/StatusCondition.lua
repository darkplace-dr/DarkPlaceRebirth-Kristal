--- StatusConditions are statuses that affect single battlers and do things. \
--- Status files should be placed inside `scripts/battle/statuses/`.
---
---@class StatusCondition : Class
---
---@field name                  string
---@field desc                  string
---@field default_turns         number

---@class StatusCondition : Object
---@overload fun(...) : StatusCondition
local StatusCondition, super = Class(Object)

function StatusCondition:init()
	-- The name of the status.
	self.name = "DefaultStatusName"

    -- A small description of the status.
	-- TODO: Find a good place to display this.
    self.desc = "* The base status condition. Has no effects."
	
	-- Default turn counter.
	self.default_turns = 3
	
	-- Default amplifier. If greater than zero, will display.
	self.amplifier = 0
	
	-- The icon of the effect.
	self.icon = "ui/status/burn"
	
	-- Does the status effect hide itself from the status overlay and StatusView menu?
	self.hidden = false
end

-- *(Override)* Called when the status effect is applied.
function StatusCondition:onStatus(battler) end

-- *(Override)* Called every frame.
function StatusCondition:onUpdate(battler) end

-- *(Override)* Called when your turn starts, before you select all of your actions.
function StatusCondition:onTurnStart(battler) end

-- *(Override)* Called after all actions have been finished.
function StatusCondition:onActionsEnd(battler) end

-- *(Override)* Called when defense starts.
function StatusCondition:onDefenseStart(battler) end

-- *(Override)* Called when the battler gets damaged.
---@return number new_amount -- The new attack damage
function StatusCondition:onHurt(battler, amount) return amount end

-- *(Override)* Called when other battlers gets damaged.
function StatusCondition:onOtherHurt(battler, other, amount) end

-- *(Override)* Called when the status effect is cured.
function StatusCondition:onCure(battler) end

-- *(Override)* Called when a stat is gotten from a PartyMember.
---@return number new_value -- The new value of the stat
function StatusCondition:applyStatModifier(stat, value) return value end

function StatusCondition:__tostring()
	if self.amplifier > 0 then
		return "StatusCondition(" .. self.id .. ", amp " .. tostring(self.amplifier) .. ")"
	end
	return "StatusCondition(" .. self.id .. ")"
end

return StatusCondition