--- A custom event that resets a pushblock puzzle when stepped on by the player
---@class ResetButton : Event
local ResetButton, super = Class(Event)

---Creates a reset button event
---@param x number The x position of the button
---@param y number The y position of the button
---@overload fun(x : number, y: number) : ResetButton
function ResetButton:init(x, y)
    
    super.init(self, x, y, 40, 40)

    self.idle_sprite = "world/events/glowtile/idle"
    self.pressed_sprite = "world/events/glowtile/pressed"

    self:setSprite(self.idle_sprite, 1/8)
end

---Called whenever the player enters this event
---@param player Player The character that enters the event
function ResetButton:onEnter(player)
    --- This makes sure that the event only reacts to the Player (Kris)
    if player.is_player then
        self:setSprite(self.pressed_sprite)
        Assets.playSound("noise")
        Assets.playSound("him_quick")



        -- Get every PushBlock in the current scene and reset it
        for _, pushblock in ipairs(Game.stage:getObjects(PushBlock)) do
            pushblock:reset()
        end
        for _, iblock in ipairs(Game.stage:getObjects(Inverse_block)) do
            iblock.reset = 10
            iblock.particle = true
        end
                for _, cblock in ipairs(Game.stage:getObjects(Copy_block)) do
            cblock.reset = 10
            cblock.particle = true
        end
        -- Prevents the player from moving while the blocks are resetting,
        -- if you don't do this, the player
        -- can step where the blocks are supposed to go and get stuck
        -- in the collision.
        Game.lock_movement = true
        Game.world.timer:after(.4, function ()
            Game.lock_movement = false
        end)

    end
end

---Called whenever the player leaves this event
---@param player Player The character that leaves the event
function ResetButton:onExit(player)
    --- This makes sure that the event only reacts to the Player (Kris)
    if player.is_player then
        self:setSprite(self.idle_sprite, 1/8)
    end
end
return ResetButton