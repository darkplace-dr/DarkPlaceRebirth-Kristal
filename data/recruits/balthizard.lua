local Balthizard, super = Class(Recruit)

function Balthizard:init()
    super.init(self)

    -- Display Name
    self.name = "Balthizard"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 5

    -- Organize the order that recruits show up in the recruit menu
    self.index = 28

    -- Selection Display
    self.description = "An ancient aromancer, it\ngenerates magic incense and\nstores it in its steel shell.\nEasygoing, it gets along well\nwith Guei."
    self.chapter = 4
    self.level = 28
    self.attack = 14
    self.defense = 30
    self.element = "STEEL:SMELL"
    self.like = "Scent Candle"
    self.dislike = "Spinning fast"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,0,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/balthizard/spared", -3, 26}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Balthizard