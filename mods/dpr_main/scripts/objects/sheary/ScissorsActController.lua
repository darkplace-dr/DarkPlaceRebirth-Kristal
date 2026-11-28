local ScissorsActController, super = HookSystem.hookScript("ScissorsActController")

function ScissorsActController:setActSprites()
    for _, battler in ipairs(Game.battle.party) do
        if battler.chara.id == "jamm" then
            battler:setActSprite("party/jamm/dark/papersnow_done", -5, 0)
        end
    end
    super.setActSprites(self)
end

return ScissorsActController
