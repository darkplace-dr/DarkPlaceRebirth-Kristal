local Zapper, super = Class(Recruit)

function Zapper:init()
    super.init(self)

    -- Display Name
    self.name = "Zapper"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 2

    -- Organize the order that recruits show up in the recruit menu
    self.index = 21

    -- Selection Display
    self.description = "A bouncer that favors brute\nforce over beauty. Gets lost\neasily."
    self.chapter = 3
    self.level = 19
    self.attack = 16
    self.defense = 18
    self.element = "ORDER:ELEC"
    self.like = "Laser Tag"
    self.dislike = "Buttons Pushed"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,128/255,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/zapper/npc", -3, -4}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Zapper