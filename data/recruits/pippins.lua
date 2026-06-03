local Pippins, super = Class(Recruit)

function Pippins:init()
    super.init(self)

    -- Display Name
    self.name = "Pippins"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 5

    -- Organize the order that recruits show up in the recruit menu
    self.index = 24

    -- Selection Display
    self.description = "A sly customer that takes risk\nuntil luck strikes. ...\ncheating also works."
    self.chapter = 3
    self.level = 17
    self.attack = 14
    self.defense = 10
    self.element = "CHAOS:LUCK"
    self.like = "Gacha Game"
    self.dislike = "Consequences"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,128/255,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/pippins/idle", -3, 25, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Pippins