local DessGuitar, super = Class(Event)

function DessGuitar:init(data)
    super.init(self, data)

    self:setOrigin(0, 0)
    self:setSprite("world/events/dess_guitar")
    self.solid = true
end

function DessGuitar:onInteract(player, dir)
    Game.world:startCutscene(function(cutscene)
        cutscene:text("* (It's a red guitar.)")
        if cutscene:getCharacter("dess") then
            cutscene:text("* ohhhh hey look it's my guitar", "condescending", "dess")
            if Game.inventory:tryGiveItem("dess_guitar") then
                Assets.playSound("grab")
                self:remove()
                cutscene:text("* (Dess stole the guitar.)")
                if cutscene:getCharacter("susie_lw") then
                    cutscene:text("* Wh-[wait:5]\n[face:teeth]* HEY!!![wait:5] That's not yours!!!", "shock", "susie")
                    cutscene:text("* uhhhh so what", "neutral_b", "dess")
                    cutscene:text("* you're saying that like you never stole before", "neutral", "dess")
                    cutscene:text("* Noelle's mom gonna kill us if we don't put it back!", "teeth", "susie")
                    cutscene:text("* who says she'll know that it disappeared", "neutral", "dess")
                    cutscene:text("* we just won't tell anybody", "condescending", "dess")
                    cutscene:text("* ...", "annoyed", "susie")
                end
                --Game:setFlag("dess_guitar_stolen", true)
            else
                cutscene:text("* uh hey guys can we please free some space in our inventory", "neutral", "dess")
                cutscene:text("* trust me on this one", "condescending", "dess")
            end
        end
    end)
    return true
end

return DessGuitar