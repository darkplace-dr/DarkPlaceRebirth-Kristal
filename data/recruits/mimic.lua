local Mimic, super = Class(Recruit)

function Mimic:init()
    super.init(self)

    -- Display Name
    self.name = "Mimic"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 39

    -- Selection Display
    self.description = "A shapeshifter that loves to say\n\"Happy New Year 1998!\"."
    self.chapter = 99
    self.level = 9
    self.attack = 10
    self.defense = 2
    self.element = "COPY"
    self.like = "1998"
    self.dislike = "Being a boss"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {1,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/ufoofdoom/idle", 0, 0, (75/120)/4}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Mimic