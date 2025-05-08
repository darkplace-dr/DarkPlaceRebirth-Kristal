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
	
	-- The icon of the effect.
	self.icon = "ui/status/burn"
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
function StatusCondition:onHurt(battler, amount) return amount end

-- *(Override)* Called when the status effect is cured.
function StatusCondition:onCure(battler) end

return StatusCondition