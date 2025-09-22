local Poseur, super = Class(Recruit)

function Poseur:init()
    super.init(self)

    -- Display Name
    self.name = "Poseur"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 36

    -- Selection Display
    self.description = "Recruit description text\ngoes here."
    self.chapter = 99
    self.level = 1
    self.attack = 4
    self.defense = 1
    self.element = "TEST"
    self.like = "Testing"
    self.dislike = "Not testing"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {68/255,41/255,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/poseur/idle", 0, 0, 1/4}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Poseur