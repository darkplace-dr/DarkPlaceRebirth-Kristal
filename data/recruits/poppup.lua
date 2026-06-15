local poppup, super = Class(Recruit)

function poppup:init()
    super.init(self)

    -- Display Name
    self.name = "Poppup"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 3

    -- Organize the order that recruits show up in the recruit menu
    self.index = 10

    -- Selection Display
    self.description = "Known to say ASOBOH,\nwhich means 'Lets Play!'\n... does it know that?"
    self.chapter = 2
    self.level = 8
    self.attack = 9
    self.defense = 3
    self.element = "VIRUS"
    self.like = "LEEMO FRUIT"
    self.dislike = "ADBLOCK"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/poppup/idle", -3, 12, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return poppup