---@class Map.hub_tutorialmasters : Map
local TutorialMastersRoom, super = Class(Map)

function TutorialMastersRoom:onEnter()
    super.onEnter(self)

    for i, partymember in ipairs(Game.party) do
        local id = partymember.id
        local ok, actor = pcall(Registry.createActor, "tutorialmaster/"..id)
        if not ok then actor = Registry.createActor("tutorialmaster/bepis"); id = "bepis" end
        local master = self.world:spawnObject(NPC(actor, 90 + (i * 80), 390, {
            cutscene = "tutorialmaster."..id
        }))
        -- needed for master:setFlag() to work
        master.unique_id = self:getUniqueID()..":"..id.."_master"
    end
end

return TutorialMastersRoom
