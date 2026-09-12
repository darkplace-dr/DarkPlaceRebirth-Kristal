---@class SkillButton : ActionButton
---@overload fun(...) : SkillButton
local SkillButton, super = Class(ActionButton)

---@param battler PartyBattler
---@param x number
---@param y number
function SkillButton:init(battler, x, y)
    super.init(self, battler, x, y)
end

function SkillButton:getTexture()
    return Assets.getTexture("ui/battle/btn/skill")
end

function SkillButton:getHoveredTexture()
    return Assets.getTexture("ui/battle/btn/skill_h")
end

function SkillButton:getSpecialTexture()
    return Assets.getTexture("ui/battle/btn/skill_a")
end

function SkillButton:getDisabledTexture()
    return Assets.getTexture("ui/battle/btn/skill_d")
end

function SkillButton:select()
    Game.battle:clearMenuItems()

    for id, action in ipairs(self.battler.chara:getSkills()) do
        Game.battle:addMenuItem({
            ["name"] = action[1],
            ["description"] = action[2],
            ["color"] = action[3],
            ["callback"] = action[4]
        })
    end

    Game.battle:setState("MENUSELECT", "SKILL")
end

function SkillButton:hasSpecial()
    if self.battler == nil then
        return
    end

    if Game.battle.encounter.unleash_threshold and Game.tension >= Game.battle.encounter.unleash_threshold then
		return true
	end

    local has_tired = false
    for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
        if enemy.tired then
            has_tired = true
            break
        end
    end

    if has_tired then
        local has_pacify = false
        for _, spell in ipairs(self.battler.chara:getSpells()) do
            if spell and spell:hasTag("spare_tired") then
                if spell:isUsable(self.battler.chara) and spell:getTPCost(self.battler.chara) <= Game:getTension() then
                    has_pacify = true
                    break
                end
            end
        end
        return has_pacify
    end

    return false
end

return SkillButton
