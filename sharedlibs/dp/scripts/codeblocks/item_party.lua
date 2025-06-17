---@class CodeBlock.item_party : CodeBlock
local block, super = Class(CodeBlock, "item_party")

function block:init()
    super.init(self)
    self.target = DP:createCodeblock("literal")
    self.target.value = 1
    self.item = DP:createCodeblock("literal")
    self.item.value = 1
    self.text = "Use item #[expr:item] on party member #[expr:target]"
end

function block:run(scope)
    local target_n = self.target:run(scope)
    local target = assert(Game.battle.party[target_n], "Party battler " .. target_n .. " not found.")
    local item_n = self.item:run(scope)
    local item = assert(Game.inventory:getItem("items",item_n), "Item " .. item_n .. " not found.")
    assert(item.usable_in == "all" or item.usable_in == "battle", "Item " .. item_n .. " unable to be used in battle.")
    assert(item.target == "ally" or item.target == "party", "Item " .. item_n .. " unable to be used on party.")
	if item.target == "party" then
		target = Game.battle.party
	end
    return {"ITEM", target, {data = item}, nil}
end

function block:onSave(data)
    data.target = self.target and self.target:save() or nil
    data.item = self.item and self.item:save() or nil
end

function block:onLoad(data)
    if data.target then
        self.target = DP:createCodeblock(data.target.id, data.target)
    end
    if data.item then
        self.item = DP:createCodeblock(data.item.id, data.item)
    end
end

return block