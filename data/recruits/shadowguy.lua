local Shadowguy, super = Class(Recruit)

function Shadowguy:init()
    super.init(self)

    -- Display Name
    self.name = "Shadowguy"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 25

    -- Organize the order that recruits show up in the recruit menu
    self.index = 19

    -- Selection Display
    self.description = "Passionate about music, but\noften taken advantage of by\nsinister types."
    self.chapter = 3
    self.level = 18
    self.attack = 13
    self.defense = 13
    self.element = "CHAOS:MUSIC"
    self.like = "Creative"
    self.dislike = "Business"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,128/255,0,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/shadowguy/idle_a", -3, 11, 1/10}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Shadowguy