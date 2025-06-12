local arlee, super = Class(EnemyBattler)

function arlee:init()
    super.init(self)

    self.name = "arlee"
    self:setActor("arlee")

    self.path = "world/npcs/arlee"
    self.sprite:set("fight")

    self.max_health = 700
    self.health = 99999999
    self.attack = 800
    self.defense = 200
    self.money = 0
    self.experience = 0
	self.service_mercy = 0
	
	self.boss = true

    self.spare_points = 0

    self.killable = true
    self.exit_on_defeat = false
    self.auto_spare = false

    self.movearound = true

    
    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }

    self.dialogue = {
        "..."
    }

    self.check = "AT 8 DF 2\n* fuck you killing you"

    self.text = {
        "* The arlee gives you a soft\nsmile.",
        "* The power of fluffy boys is\nin the air.",
        "* Smells like cardboard.",
    }
    self.low_health_text = "* The arlee looks like it's\nabout to fall over."
end

return arlee