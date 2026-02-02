local tasquemanager, super = Class(Recruit)

function tasquemanager:init()
    super.init(self)

    -- Display Name
    self.name = "Tasque Manager"

    -- How many times an enemy needs to be spared to be recruited
    self.recruit_amount = 1

    -- Organize the order that recruits show up in the recruit menu
    self.index = 17

    -- Selection Display
    self.description = "Loves to coordinate outfits.\nStrongly dislikes clowns."
    self.chapter = 2
    self.level = 10
    self.attack = 10
    self.defense = 7
    self.element = "CAT:ORDER"
    self.like = "New Wave Synth Pop"
    self.dislike = "Mismatched Socks"

    -- Controls the type of the box gradient
    -- Available options: dark, bright
    self.box_gradient_type = "bright"

    -- Dyes the box gradient
    self.box_gradient_color = {0,1,1,1}

    -- Sets the animated sprite in the box
    -- Syntax: Sprite/Animation path, offset_x, offset_y, animation_speed
    self.box_sprite = {"recruits/tasquemanager/npc", -3, 1, 4/30}

    -- Recruit Status (saved to the save file)
    -- Number: Recruit Progress
    -- Boolean: True = Recruited | False = Lost Forever
    self.recruited = 0
end

return tasquemanager