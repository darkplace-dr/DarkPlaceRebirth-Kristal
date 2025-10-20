local Winglade, super = Class(Recruit)

function Winglade:init()
    super.init(self)

    -- Display Name
    self.name = "Winglade"

    -- How many times an enemy needs to be spared to be recruited.
    self.recruit_amount = 2

    -- Organize the order that recruits show up in the recruit menu
    self.index = 32

    -- Selection Display
    self.description = "The witch's familiar, a living\nsword. Its greatest delight is\nbeing asked to carve graffiti."
    self.chapter = 4
    self.level = 32
    self.attack = 28
    self.defense = 12
    self.element = "BLADE"
    self.like = "Calligraphy"
    self.dislike = "Authoritarianism"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,0,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y
    self.box_sprite = {"recruits/winglade/npc", -3, 7}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return Winglade