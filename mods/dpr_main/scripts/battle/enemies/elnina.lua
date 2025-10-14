local Elnina, super = Class(EnemyBattler)

function Elnina:init()
    super.init(self)

    self.name = "Elnina"
    self:setActor("elnina")

    self.max_health = 4440
    self.health = 4440
    self.attack = 16
    self.defense = 0
    self.money = 0
    self.experience = 0
	self.service_mercy = 0

	self.boss = true

    self.spare_points = 0

    self.waves = {}

    self.text = {"* Elnina."}

    self.tired_percentage = 0

    self:registerAct("Umbrella", "Blocks\nbullets")
    self:registerAct("WarmHat", "Blocks\nbullets")

    self.used_umbrella = false
    self.used_warmhat = false
end

function Elnina:shouldDisplayTiredMessage()
    return false
end

function Elnina:isXActionShort(battler)
    return true
end

function Elnina:onAct(battler, name)
    if name == "Check" then
        return "* ELNINA - She's just over the moon for Lanino."
    elseif name == "Umbrella" then
		local text = {"* Took an umbrella to block rain!"}
        if not self.used_umbrella then
            self.used_umbrella = true
            text = {
                "* You looked at the sky and took...\n* An umbrella!",
                "* Blocking rain shows your care for the weather report!"
            }
        end
		return text
    elseif name == "WarmHat" then
		local text = {"* Took a warm hat to block snow!"}
        if not self.used_warmhat then
            self.used_warmhat = true
            text = {
                "* You looked at the sky and took...\n* A warm hat!",
                "* Blocking snow shows your care for the weather report!"
            }
        end
		return text
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(8)
            Game.battle:getEnemyBattler("lanino"):addMercy(8)
            return "* Susie dreamed of sunny days!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(8)
            Game.battle:getEnemyBattler("lanino"):addMercy(8)
            return "* Ralsei hoped for starry nights!"
        else
            self:addMercy(8)
            Game.battle:getEnemyBattler("lanino"):addMercy(8)
            return "* "..battler.chara:getName().." checked the weather report."
        end
    end

    return super.onAct(self, battler, name)
end

function Elnina:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(8)
            Game.battle:getEnemyBattler("lanino"):addMercy(8)
            return "* Susie dreamed of sunny days!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(8)
            Game.battle:getEnemyBattler("lanino"):addMercy(8)
            return "* Ralsei hoped for starry nights!"
        else
            self:addMercy(8)
            Game.battle:getEnemyBattler("lanino"):addMercy(8)
            return "* "..battler.chara:getName().." checked the weather report."
        end
    end

    return super.onShortAct(self, battler, name)
end

function Elnina:addMercy(amount, goespastlimit)
    if goespastlimit ~= true then
        if (self.mercy + amount) > 90 then
            while (self.mercy + amount) > 90 do
                amount = amount - 1
            end
        end
    end

    super.addMercy(self, amount)
end

function Elnina:onSpared()
    self:setAnimation("transition")
end

function Elnina:onSpareable() end -- we don wanna set animation to spared

return Elnina