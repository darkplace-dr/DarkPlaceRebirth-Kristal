local Guei, super = Class(Recruit)

function Guei:init()
    super.init(self)

    -- Display Name
    self.name = "Guei"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 3

    -- Organize the order that recruits show up in the recruit menu
    self.index = 27

    -- Selection Display
    self.description = "A waxy spirit that generates\nghastly flames. Though, not a\n\"real\" ghost per se, it has an\naversion to whips, water, and\nthe like."
    self.chapter = 4
    self.level = 26
    self.attack = 20
    self.defense = 14
    self.element = "SPIRIT:FIRE"
    self.like = "Pot Roast"
    self.dislike = "Holywater"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,0,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/guei/npc", -3, 6, 1/10}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Guei