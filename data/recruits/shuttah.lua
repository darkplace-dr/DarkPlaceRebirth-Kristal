local Shuttah, super = Class(Recruit)

function Shuttah:init()
    super.init(self)

    -- Display Name
    self.name = "Shuttah"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 2

    -- Organize the order that recruits show up in the recruit menu
    self.index = 20

    -- Selection Display
    self.description = "Don't scream...! It's not the\nreal monster, just the Darkner.\nOoo la la."
    self.chapter = 3
    self.level = 20
    self.attack = 14
    self.defense = 20
    self.element = "COPY"
    self.like = "Fashion Shoot"
    self.dislike = "The word \"ugly\""

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,128/255,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/shuttah/idle", -3, 2, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Shuttah