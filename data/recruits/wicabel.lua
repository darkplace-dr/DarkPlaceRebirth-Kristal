local Wicabel, super = Class(Recruit)

function Wicabel:init()
    super.init(self)

    -- Display Name
    self.name = "Wicabel"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 2

    -- Organize the order that recruits show up in the recruit menu
    self.index = 31

    -- Selection Display
    self.description = "A witch who engages in musical\nrituals. Each song she plays is\na magical charm that can change\none's mood... though, isn't\nthat all music?"
    self.chapter = 4
    self.level = 33
    self.attack = 14
    self.defense = 28
    self.element = "STEEL:MUSIC"
    self.like = "Zen Bells"
    self.dislike = "Sightreading"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,0,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/wicabel/npc", -3, 10}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Wicabel