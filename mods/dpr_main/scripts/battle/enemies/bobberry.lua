local Bobberry, super = Class(EnemyBattler)

function Bobberry:init()
    super.init(self)

    self.name = "Bobberry"
    self:setActor("bobberry")

    self.max_health = 400
    self.health = 400
    self.attack = 8
    self.defense = 0
    self.money = 80
    self.experience = 12

    self.spare_points = 25

    self.waves = {
        "bobberry1",
        "bobberry1",
        "bobberry2"
    }

    self.dialogue = {
        "Hello yes\nI am Bobberry",
		"Don't make me use\nmy Bobberry Beam",
		"Please don't kill me"
    }

    self.check = "AT 8 DF 0\n* It's fucking Bobberry."

    self.text = {
        "* Bobberry is clutching very hard to his berry.",
        "* Gaming.",
        "* It would be really funny if you hit Bobberry lmao.",
    }
    self.low_health_text = "* Bobberry's not clutching so hard to his berry anymore."

    self:registerAct("Orbulate", "???")
    self:registerAct("Take Berry", "Steal\nITEM", {"susie"})

    self.killable = true
    self.took_berry = false
end

function Bobberry:onAct(battler, name)
    if name == "Orbulate" then
        self:addMercy(50)
        self.dialogue_override = "god I fucking love orbs"
        return "* What the hell does \"orbulate\" mean?[wait:10]\n* It doesn't really matter."

    elseif name == "Take Berry" then
		if self.took_berry then
			return "* Haven't you already taken enough?"
		else
			if self.health <= self.max_health * self.low_health_percentage then
                if Game.inventory:getFreeSpace("items", false) > 0 then
                    self:setActor("bob")
                    self.name = "Bob"
                    self.took_berry = true
                    Game.inventory:addItem("berry")
                    self.check = "AT 5 DF -5\n* It's Bob."
                    self.attack = 5
                    self.defense = -5
                    self.dialogue = { "..." }
                    self.text = { "* Bob." }
                    self.waves = {}
                    self.low_health_text = "* Bob."
                    return "* You took Bobberry's [color:yellow]BERRY[color:reset].[wait:15]\n* Now he's just \"Bob\"."
                else
                    return "* But you had no space to take a [color:yellow]BERRY[color:reset]..."
                end
			else
				return "* You can't take his Berry!\n* He's not at low enough HP!"
			end
		end

    elseif name == "Standard" then
        if battler.chara.id == "susie" then
            self:addMercy(35)
            return "* Susie shook a tree really hard and a bunch of berries came down."
        elseif battler.chara.id == "berdly" then
            self:addMercy(35)
            return "* Berdly did original and in character for him!"
        elseif battler.chara.id == "dess" then
            self:addMercy(50)
            return "* Dess swings her bat menacingly![wait:10]\n* "..self.name.." feels threatend."
        else
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    return super.onAct(self, battler, name)
end

return Bobberry
