---@class CodeBlock.spell_party : CodeBlock
local block, super = Class(CodeBlock, "spell_party")

function block:init()
    super.init(self)
    self.target = DP:createCodeblock("literal")
    self.target.value = 1
    self.spell = DP:createCodeblock("literal")
    self.spell.value = 1
    self.text = "Use spell #[expr:item] on party #[expr:target]"
end

function block:run(scope)
    local target_n = self.target:run(scope)
    local target = assert(Game.battle.party[target_n], "Party battler " .. target_n .. " not found.")
    local spell_n = self.spell:run(scope)
    local spell = assert(Game:getPartyMember("apm"):getSpells()[spell_n], "Spell " .. spell_n .. " not found.")
    assert(Game.tension >= spell:getTPCost(Game:getPartyMember("apm")), "Not enough tension to cast spell " .. spell_n .. ".")
    assert(spell.target == "ally" or spell.target == "party", "Spell " .. spell_n .. " unable to be used on party.")
	if spell.target == "party" then
		target = Game.battle.party
	end
    return {"SPELL", target, {data = spell, tp = spell:getTPCost(Game:getPartyMember("apm"))}, nil}
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