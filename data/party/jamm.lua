local character, super = Class(PartyMember, "jamm")

function character:init()
    super.init(self)

    self.name = "Jamm"

    self:setActor("jamm")
    self:setLightActor("jamm_lw")
    self:setDarkTransitionActor("jamm_dark_transition")

    if Game:getFlag("marcy_joined") then
		self:setActor("jammarcy")
		self:setLightActor("jammarcy_light")
		self:setDarkTransitionActor("jammarcy_dark_transition")
	end

    self.level = 1
    self.title = "Slingshotter\nTakes aim, then\nfires"

    self.soul_priority = 1
    self.soul_color = {1, 106/255, 0}
    self.soul_facing = "up"

    if Game:getFlag("jamm_canact") then
        self.has_act = true
		self.soul_priority = 10
    else
        self.has_act = false
    end
    self.has_spells = true

    self.has_xact = true
    self.xact_name = "J-Action"

    self.lw_portrait = "face/jamm/neutral"

    self:addSpell("supersling")
    self:addSpell("darksling")
    self:addSpell("numbshot")

    self.health = 120

    self.stats = {
        health = 120,
        attack = 10,
        defense = 2,
        magic = 3
    }

    self.weapon_icon = "ui/menu/equip/sling"

    self:setWeapon("basic_sling")

    self.lw_weapon_default = "light/rope_sling"
    self.lw_armor_default = "light/bandage"

    self.color = {1, 1, 0}
    self.dmg_color = nil
    self.attack_bar_color = {0.5, 0.5, 0}
    self.attack_box_color = {127/255, 106/255, 0}
    self.xact_color = nil

    self.menu_icon = "party/jamm/head"
    self.head_icons = "party/jamm/icon"
    self.name_sprite = "party/jamm/name"

    self.attack_sprite = "effects/attack/sling"
    self.attack_sound = "sling"
    self.attack_pitch = 1

    self.battle_offset = {2, 1}
    self.head_icon_offset = {0, -3}
    self.menu_icon_offset = nil

    self.gameover_message = nil

	self.flee_text = {
		"[voice:jamm][facec:jamm/nervous]Nope! I'm out!"
	}

	self.graduate = true
    
    self.flags = {
        ["disarmed"] = false
    }
end

function character:getName()
    if Game:getFlag("marcy_joined", false) then
        return "J&M"
    end
    return self.name
end

function character:getMenuIcon()
    if Game:getFlag("marcy_joined", false) then
        return "party/jamm/withmarcy/head"
    end
    return self.menu_icon
end

function character:getHeadIcons()
    if Game:getFlag("marcy_joined", false) then
        return "party/jamm/withmarcy/icon"
    end
    return self.head_icons
end

function character:getNameSprite()
    if Game:getFlag("marcy_joined", false) then
        return "party/jamm/withmarcy/name"
    end
    return self.name_sprite
end

function character:getStarmanTheme() return "jamm" end

function character:onTurnStart(battler)
	if self.stun then
		Game.battle:pushForcedAction(battler, "SKIP")
	end
end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
    end
end

function character:onLevelUpLVLib(level)
    self:increaseStat("health", 5)
    self:increaseStat("attack", 1)
    if level % 2 == 0 then
        self:increaseStat("defense", 1)
        self:increaseStat("magic", 1)
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1  then
        local icon = Assets.getTexture("ui/menu/icon/demon")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Skills", x, y, 0, 0.7, 1)
        love.graphics.print("Yes", x+130, y)
        return true
    elseif index == 2 then
        local icon = Assets.getTexture("ui/menu/icon/magic")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Father", x, y)
        love.graphics.print("Yes", x+130, y, 0)
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        love.graphics.draw(icon, x+90, y+6, 0, 2, 2)
        love.graphics.print("x", x+111, y)
        love.graphics.print("∞", x+122, y+3)

        return true
    end
end

function character:getFleeText()
	if Game:getFlag("marcy_joined") then
		if Game:getFlag("marcy_pirate") then
			return {
				"[voice:jamm][facec:jamm/nervous]Nope! I'm out!",
				"[voice:marcy][facec:marcy/frown_open_patch]Marcy thinks we should go!"
			}
		end
		return {
			"[voice:jamm][facec:jamm/nervous]Nope! I'm out!",
			"[voice:marcy][facec:marcy/frown_open]Marcy thinks we should go!"
		}
	end
	return self.flee_text
end

function character:getAssistID()
    if Game:getFlag("marcy_joined") then
        return "marcy"
    end
    return super.getAssistID(self)
end

function character:getAssistColor()
    if Game:getFlag("marcy_joined") then
        return Utils.unpackColor({0, 1, 1})
    end
    return super.getAssistColor(self)
end

function character:getGameOverMessage(main)
    return {
        "Hey, I believe we\ncan do this.",
        main:getName()..",[wait:5]\nlet's try again!"
    }
end

function character:getTVName()
	if Game:getFlag("marcy_joined") then return "J+M" end
	return "JAM"
end

function character:canAutohealSwoon()
    return Game:getFlag("marcy_joined", false)
end

function character:autoHealSwoonAmount()
    return 1
    -- If needed, I'll safeguard this, but I don't see that as necessary.
end

return character
