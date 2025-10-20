local Organikk, super = Class(Recruit)

function Organikk:init()
    super.init(self)

    -- Display Name
    self.name = "Organikk"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 3

    -- Organize the order that recruits show up in the recruit menu
    self.index = 33

    -- Selection Display
    self.description = "A philosopher who studies the\nancient words. Their\nlight-blocking mask is said to\nlet them commune deeper with\nthe truth of the dark."
    self.chapter = 4
    self.level = 32
    self.attack = 26
    self.defense = 22
    self.element = "STEEL:MUSIC"
    self.like = "Instrumentalism"
    self.dislike = "Knowing what that is"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,0,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/organikk/recruit", -3, 9}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Organikk