---@class CharacterDoor : Event
---@overload fun(...) : CharacterDoor
local CharacterDoor, super = Class(Event, "characterdoor")

function CharacterDoor:init(data)
    super.init(self, data)

    self.chain_sprite = Assets.getFramesOrTexture("world/events/character_door/chain")
    self.chain_broken_sprite = Assets.getFramesOrTexture("world/events/character_door/chain_broken")
    self.star_sprite = Assets.getFramesOrTexture("world/events/character_door/star")
    self.star_half_sprite = Assets.getFramesOrTexture("world/events/character_door/star_half")

    self:updateSize()

    local properties = data and data.properties or {}

    self.chara = properties["chara"]
    self.keep_open = properties["keepopen"]

    self.set_flag = properties["setflag"]
    self.set_value = properties["setvalue"]

    self.solid = true
end

function CharacterDoor:updateSize()
    if self.width == self.height or (self.width < 40 and self.height < 40) then
        self.dir = "none"

        self.start_x = self.width / 2
        self.start_y = self.height / 2

        self.end_x = self.start_x
        self.end_y = self.start_y
    elseif self.width > self.height then
        self.dir = "right"

        self.start_x = math.min(20, self.width / 2)
        self.start_y = self.height / 2

        self.end_x = self.width - self.start_x
        self.end_y = self.start_y
    elseif self.height > self.width then
        self.dir = "down"

        self.start_x = self.width / 2
        self.start_y = math.min(20, self.height / 2)

        self.end_x = self.start_x
        self.end_y = self.height - self.start_y
    end
end

--- Handles making the door remain appearing open when re-entering the room
function CharacterDoor:onAdd(parent)
    super.onAdd(self, parent)

    if self.keep_open == false then
        self:setFlag("opened", false)
    end

    if self:getFlag("opened") then
        self.solid = false
    end
end

function CharacterDoor:onInteract(player, dir)
    if self:getFlag("opened") then return end
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* (It appears to be one of these specific character doors.)")
        if self.chara then
            local chara = cutscene:getCharacter(self.chara)
            if chara then
                Assets.playSound("item")
                self:setFlag("opened", true)
                self.solid = false

                if self.set_flag then
                    Game:setFlag(self.set_flag, (self.set_value == nil and true) or self.set_value)
                end

                return true
            else
                cutscene:text("* (...[wait:5]It doesn't look like you met the requiriments.)")
            end
        end
    end)
end

function CharacterDoor:updateColor()
    if self.chara then
        ---@type PartyMember
        local party = Game.party_data[self.chara]
        if party then
            local actor = party.actor
            if actor then
                local color = actor.color
                if color then
                    self.color = color
                end
            end
        end
    end
end

function CharacterDoor:update()
    super.update(self)
    self:updateColor()
end

function CharacterDoor:draw()
    local color = self.color or {1, 1, 1, 1}
    love.graphics.setColor(color)
    if self.dir == "none" then
        local sprite = self.star_sprite[1]
        Draw.draw(sprite, self.start_x, self.start_y, 0, 2, 2, sprite:getWidth() / 2, sprite:getHeight() / 2)
    else
        local end_sprite = self.chain_sprite[1]
        local rot = (self.dir == "down") and math.rad(90) or 0
        if self:getFlag("opened") then
            end_sprite = self.chain_broken_sprite[1]
            Draw.draw(end_sprite, self.start_x, self.start_y, rot, 2, 2, end_sprite:getWidth() / 2, end_sprite:getHeight() / 2)
            Draw.draw(end_sprite, self.end_x, self.end_y, rot + math.rad(180), 2, 2, end_sprite:getWidth() / 2, end_sprite:getHeight() / 2)
        else
            local w = end_sprite:getWidth() * 3 + math.abs(self.start_x - self.end_x)
            local h = end_sprite:getHeight() * 2 + math.abs(self.start_y - self.end_y)
            Draw.scissor(self.start_x - end_sprite:getWidth() * 2, self.start_y, w, h)
            Draw.drawWrapped(end_sprite, true, true, self.start_x, self.start_y, rot, 2, 2)

            local middle_sprite = self.star_sprite[1]

            local mid_size = (self.dir == "down") and (self.end_y - self.start_y) or (self.end_x - self.start_x)
            mid_size = mid_size - 40

            local mid_count = math.ceil(mid_size / 40)
            local mid_scale = (mid_size / mid_count) / 40

            for i = 1, mid_count do
                local mid_x, mid_y = self.start_x, self.start_y
                local sx, sy = 2 * mid_scale, 2
                if self.dir == "right" then
                    mid_x = self.start_x + 20 + (20 * mid_scale) + ((i - 1) * 40 * mid_scale)
                elseif self.dir == "down" then
                    mid_y = self.start_y + 20 + (20 * mid_scale) + ((i - 1) * 40 * mid_scale)
                end
                Draw.draw(middle_sprite, mid_x, mid_y, rot, sx, sy, middle_sprite:getWidth() / 2, middle_sprite:getHeight() / 2)
                Draw.draw(middle_sprite, mid_x, mid_y, rot + math.rad(180), sx, sy, middle_sprite:getWidth() / 2, middle_sprite:getHeight() / 2)
            end
        end
    end

    super.draw(self)
end

return CharacterDoor
