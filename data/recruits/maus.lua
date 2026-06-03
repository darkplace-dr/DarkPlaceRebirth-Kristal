local maus, super = Class(Recruit)

function maus:init()
    super.init(self)

    -- Display Name
    self.name = "Maus"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 3

    -- Organize the order that recruits show up in the recruit menu
    self.index = 13

    -- Selection Display
    self.description = "It dreams of re-enacting\nscenes from cat\nand mouse cartoons."
    self.chapter = 2
    self.level = 6
    self.attack = 8
    self.defense = 2
    self.element = "MOUSE:ELEC"
    self.like = "Clicking"
    self.dislike = "Clicking on Poppup"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/maus/idle", -3, 52, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return maus