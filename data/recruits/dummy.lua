local Dummy, super = Class(Recruit)

function Dummy:init()
    super.init(self)

    -- Display Name
    self.name = "Dummy"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 35

    -- Selection Display
    self.description = "A training dummy made by Ralsei.\nHow did it get here...?"
    self.chapter = 99
    self.level = 1
    self.attack = 4
    self.defense = 0
    self.element = "FIGHT"
    self.like = "People being nice"
    self.dislike = "Violence"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {68/255,41/255,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/dummy/idle", 0, 0}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Dummy