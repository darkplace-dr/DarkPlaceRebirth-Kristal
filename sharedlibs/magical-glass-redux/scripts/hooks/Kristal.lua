local Kristal, super = HookSystem.hookScript(Kristal)

function Kristal.quickReload(mode)
    if mode == "temp" then
        for _, party in ipairs(Game.party) do
            if party.temp then
                Game:removePartyMember(party)
            else
                if party:getHealth() <= 0 then
                    party:setHealth(1)
                end
            end
        end
        MG_GAMEOVERS_TEMP = Mod.libs["magical-glass"].game_overs
    else
        MG_GAMEOVERS_TEMP = nil
    end

    super.quickReload(mode)
end

function Kristal.returnToMenu()
    MG_GAMEOVERS_TEMP = nil

    super.returnToMenu()
end

return Kristal