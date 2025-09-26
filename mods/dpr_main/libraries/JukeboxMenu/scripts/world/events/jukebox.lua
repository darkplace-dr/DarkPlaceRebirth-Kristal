local Jukebox, super = Class(Event)

function Jukebox:init(data)
    super.init(self, data.x, data.y, data.width, data.height)

	self.solid = true

    self:setSprite("world/events/jukebox")
    self:setOrigin(0.3, 0.5)

    self.menu = JukeboxMenu()
end

function Jukebox:openMenu()
    self.menu = JukeboxMenu()
    Game.world:openMenu(self.menu)
end

function Jukebox:onInteract(chara, dir)
    Game.world:startCutscene(function(cutscene, event)
        cutscene:text("* A working jukebox.")
        cutscene:text("* Would you like to play a song?")

        if cutscene:choicer({"Yes", "No"}) == 2 then
            cutscene:text("* You decided to leave the jukebox in its undamaged state.")
            return
        end

        Assets.stopAndPlaySound("ui_select")
        cutscene:after(function()
            self:openMenu()
        end)
    end)

    return true
end

return Jukebox
