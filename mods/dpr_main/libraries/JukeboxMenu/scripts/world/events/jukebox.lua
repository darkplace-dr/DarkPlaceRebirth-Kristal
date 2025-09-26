local Jukebox, super = Class(Event)

function Jukebox:init(data)
    super.init(self, data.x, data.y, data.width, data.height)

	self.solid = true

    self:setSprite("world/events/jukebox")
    self:setOrigin(0.3, 0.5)
end

function Jukebox:onInteract(chara, dir)
    Game.world:startCutscene(function(cutscene, event)
        cutscene:text("* A working jukebox.")
        cutscene:text("* Would you like to play a song?")

        if cutscene:choicer({"Yes", "No"}) == 2 then
            cutscene:text("* You decided to leave the jukebox in its undamaged state.")
        end

        Assets.stopAndPlaySound("ui_select")
        cutscene:after(function()
            Game.world:openMenu(JukeboxMenu())
        end)
    end)

    return true
end

return Jukebox
