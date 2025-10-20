local spell, super = Class(Spell, "chainslash")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Chain Slash"
    -- Name displayed when cast (optional)
    self.cast_name = "CHAIN SLASH"

    -- Battle description
    self.effect = "Not Power\nBounce"
    -- Menu description
    self.description = "Deals physical damage to 1 enemy until you miss the action command."
    -- Check description
    self.check = "Deals physical damage to 1 enemy until you\nmiss the action command."

    -- TP cost
    self.cost = 60

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"Damage"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
	local damage = ((((user.chara:getStat("attack") * 150) / 20) - 3 * (target.defense)) * 1.3)
    damage = damage / 2

	---@type XSlashSpell
	local spellobj = XSlashSpell(user,target)
    spellobj.slashes_count = 1
    spellobj.clock = -0.5
    spellobj.damage_delay = 1/30
    local chain = 0
	Game.battle:addChild(spellobj):setLayer(BATTLE_LAYERS["above_battlers"])

    Assets.playSound("back_attack")
	spellobj.damage_callback = function(spellf, hit_action_command)
        damage = math.max(user.chara:getStat("attack"), damage - 5)
        local strikedmg = damage
		if hit_action_command then
			Assets.playSound("bell", 1, Utils.clampMap(chain, 0, 10, 0.5, 0.8))
            chain = chain + 1
            spellf.slashes_count = spellf.slashes_count + 1
        else
            strikedmg = 0
            -- stat tracking? oh god it really is power bounce
            local flag = "spell#"..self.id..":".."max_combo"
            Game:setFlag(flag, math.max(chain, Game:getFlag(flag,0)))
		end
        spellf.action_command_threshold = math.max(1/15, spellf.action_command_threshold * 0.95)
        if spellf.target.parent then
            target:hurt(math.floor(strikedmg), user)
            target.hit_count = 0
        end
	end
    return false
end

return spell
