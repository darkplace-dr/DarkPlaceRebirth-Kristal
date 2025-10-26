local Lanino, super = Class(EnemyBattler)

function Lanino:init()
    super.init(self)

    self.name = "Lanino"
    self:setActor("lanino")

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

    self.text = {"* Lanino."}

    self.tired_percentage = 0

    self:registerAct("Telescope", "Blocks\nbullets")
    self:registerAct("Sunglasses", "Blocks\nbullets")

    self.used_telescope = false
    self.used_sunglasses = false
end

function Lanino:isXActionShort(battler)
    return true
end

function Lanino:onAct(battler, name)
    if name == "Check" then
        return "* Lanino - The sight of Elnina makes him want to be singin' in the rain."
    elseif name == "Telescope" then
		local text = {"* Took a telescope to block moons!"}
        if not self.used_telescope then
            self.used_telescope = true
            text = {
                "* You looked at the sky and took...\n* A telescope!",
                "* Blocking moons shows your care for the weather report!"
            }
        end
		return text
    elseif name == "Sunglasses" then
		local text = {"* Took sunglasses to block suns!"}
        if not self.used_sunglasses then
            self.used_sunglasses = true
            text = {
                "* You looked at the sky and took...\n* Sunglasses!",
                "* Blocking suns shows your care for the weather report!"
            }
        end
		return text
    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(8)
            Game.battle:getEnemyBattler("elnina"):addMercy(8)
            return "* Susie dreamed of sunny days!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(8)
            Game.battle:getEnemyBattler("elnina"):addMercy(8)
            return "* Ralsei hoped for starry nights!"
        else
            self:addMercy(8)
            Game.battle:getEnemyBattler("elnina"):addMercy(8)
            return "* "..battler.chara:getName().." checked the weather report."
        end
    end

    return super.onAct(self, battler, name)
end

function Lanino:onShortAct(battler, name)
    if name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(8)
            Game.battle:getEnemyBattler("elnina"):addMercy(8)
            return "* Susie dreamed of sunny days!"
        elseif battler.chara.id == "ralsei" then
            self:addMercy(8)
            Game.battle:getEnemyBattler("elnina"):addMercy(8)
            return "* Ralsei hoped for starry nights!"
        else
            self:addMercy(8)
            Game.battle:getEnemyBattler("elnina"):addMercy(8)
            return "* "..battler.chara:getName().." checked the weather report."
        end
    end

    return super.onShortAct(self, battler, name)
end

function Lanino:addMercy(amount, goespastlimit)
    if goespastlimit ~= true then
        if (self.mercy + amount) > 90 then
            while (self.mercy + amount) > 90 do
                amount = amount - 1
            end
        end
    end

    super.addMercy(self, amount)
end

function Lanino:onSpared()
    self:setAnimation("transition")
end

function Lanino:onSpareable() end -- we don wanna set animation to spared

return Lanino