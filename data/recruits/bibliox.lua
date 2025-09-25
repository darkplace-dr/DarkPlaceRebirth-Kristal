local Bibliox, super = Class(Recruit)

function Bibliox:init()
    super.init(self)

    -- Display Name
    self.name = "Bibliox"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 3

    -- Organize the order that recruits show up in the recruit menu
    self.index = 29

    -- Selection Display
    self.description = "An old sage who can't help but\nmumble. It is rumored that 1000\nspells are kept within his\nbeard."
    self.chapter = 4
    self.level = 20
    self.attack = 14
    self.defense = 14
    self.element = "MAGIC"
    self.like = "Ancient Text"
    self.dislike = "Autocorrect"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,0,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/bibliox/spare", -3, 22}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Bibliox