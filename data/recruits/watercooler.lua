local Watercooler, super = Class(Recruit)

function Watercooler:init()
    super.init(self)

    -- Display Name
    self.name = "Watercooler"

    -- Organize the order that recruits show up in the recruit menu
    self.index = 23

    -- Selection Display
    self.description = "The chatty office star.\nObviously quite a looker\ndespite her prudish wear."
    self.chapter = 3
    self.level = 24
    self.attack = 20
    self.defense = 12
    self.element = "WATER"
    self.like = "Small talk"
    self.dislike = "Feeling contained"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,128/255,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/watercooler/idle", -3, 27}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Watercooler