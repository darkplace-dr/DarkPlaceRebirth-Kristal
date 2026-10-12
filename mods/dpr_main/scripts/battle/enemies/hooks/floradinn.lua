local Wicabel, super = HookSystem.hookScript("floradinn")

function Wicabel:init()
    super.init(self)

    self.killable = true
end

function Wicabel:onAct(battler, name)
    if name == "FlirtS" then
        Game.battle:startActCutscene(function(cutscene)
            local susie = Game.battle:getPartyBattler("susie")
            local susie_x, susie_y = susie:getRelativePos()
            Game:addFlag("floradinn_flirts", 1)
            self.dialogue_override = "Nice impression.\nReminds me of...\nFlowers."
            if Game:getFlag("floradinn_flirts") == 1 then
                cutscene:text("* Susie gets ready to FLIRT!")
                cutscene:battlerText(susie, {
                    "Heh,[wait:5] want me\nto FLIRT?[wait:5] Watch\nthis,[wait:5] then!",
                    "AHEM."
                }, { right = true, x = susie_x + 69, y = susie_y + 39 })
                Game.battle.music:pause()
                cutscene:wait(1)
                cutscene:battlerText(susie, {
                    "You've got a\nnice,[wait:5] uh...",
                    "Butter...[wait:5] Sword."
                }, { right = true, x = susie_x + 69, y = susie_y + 39 })
                cutscene:battlerText(self, "It's not butter.")
                cutscene:battlerText(susie, "...", { right = true, x = susie_x + 69, y = susie_y + 39 })
                Game.battle.music:resume()
            else
                cutscene:text("* Susie abstains from flirting!")
            end
            self:addMercy(100)
            battler:setAnimation("flutter")
            susie:setAnimation("battle/idle_embarrassed")
            local offsets = battler:getActiveSprite():getOffset()
            local offsets_s = susie:getActiveSprite():getOffset()
            battler:actEffect(battler:getActiveSprite():getTexture(), offsets[1], offsets[2])
            susie:actEffect(susie:getActiveSprite():getTexture(), offsets_s[1], offsets_s[2])
            if Game:getFlag("floradinn_flirts") == 1 then
                cutscene:text("* Susie got psyched out![wait:5] You just did a flower impression instead!")
            else
                cutscene:text("* You did a flower impression!")
            end
        end)
        return
    end

    return super.onAct(self, battler, name)
end

return Wicabel