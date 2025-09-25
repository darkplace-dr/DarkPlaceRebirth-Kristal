local MissMizzle, super = Class(Recruit)

function MissMizzle:init()
    super.init(self)

    -- Display Name
    self.name = "Miss Mizzle"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 34

    -- Selection Display
    self.description = "A regular \"Mizzle\" who, after\nages of worship, falsely\nbelieves herself to be of great\nroyalty. Isn't even \"HOLY\"\nelemental."
    self.chapter = 4
    self.level = 38
    self.attack = 28
    self.defense = 28
    self.element = "WATER"
    self.like = "Reverence"
    self.dislike = "Brutishness"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,0,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/missmizzle/idle", -3, -4, 1/10}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return MissMizzle