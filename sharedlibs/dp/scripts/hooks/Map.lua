---@class Map : Map
local Map, super = HookSystem.hookScript(Map)

function Map:init(world, data)
    super.init(self, world, data)

    -- spawns the party members at markers with the same id as them (if they're unlocked, and not already in the party)
    self.spawn_party = data and data.properties and data.properties["spawn_party"] or false
    -- if the party spawn enabled, spawn them only if THAT flagcheck is successful
    self.spawn_party_flag = data and data.properties and data.properties["spawn_party_flag"]
    -- the value for the flag to check
    self.spawn_party_flag_value = data and data.properties and data.properties["spawn_party_flag_value"]
    -- if the party spawn enabled, spawn them only if THAT condition is true
    self.spawn_party_cond = data and data.properties and data.properties["spawn_party_cond"]
end

function Map:onEnter()
    Noel:checkNoel()

	local can_kill = Game:getFlag("can_kill", false)
    if Game.world.map.id:find("floortv/") and can_kill == true then
        self.tv_snow = Game.world:spawnObject(TVSnow())
        self.tv_snow.overlay = true
    end

    if Game.world.map.serious then
        Game:setFlag("disable_spongestep", true)
    else
        Game:setFlag("disable_spongestep", false)
    end

    if self:allowsPartyNPCSpawn() then
        self:spawnPartyNPCs()
    end
end

function Map:onFootstep(char, num)
    local date = os.date("*t")
    if date.month == 3 and date.day == 14 and not Game:getFlag("disable_spongestep") then
        if num == 1 then
            Assets.playSound("spongestep_1")
        elseif num == 2 then
            Assets.playSound("spongestep_2")
        end
	end
end

function Map:allowsPartyNPCSpawn()
    if not self.spawn_party then return false end

    if self.spawn_party_cond then -- I DON'T know how ANY of this works, I just copied and re-used it
        local env = setmetatable({}, {__index = function(t, k)
            return Game:getFlag(uid .. ":" .. k) or Game:getFlag(k) or _G[k]
        end})
        local chunk, _ = assert(loadstring("return " .. data.properties["cond"]))

        if not setfenv(chunk, env)() then return true end
        return false
    elseif self.spawn_party_flag then
        local inverted, flag = StringUtils.startsWith(self.spawn_party_flag, "!")

        local result = Game:getFlag(flag)
        local value = self.spawn_party_flag_value
        local is_true
        if value ~= nil then
            is_true = result == value
        elseif type(result) == "number" then
            is_true = result > 0
        else
            is_true = result
        end

        if is_true then
            if inverted then return true end
        else
            if not inverted then return true end
        end
        return false
    end

    return true
end

function Map:spawnPartyNPCs()
    for id, _ in pairs(Registry.party_members) do
        if Registry.getPartyMember(id) then
            local pm_id = Registry.getPartyMember(id).id
            local x, y, data = self:getMarker(pm_id)
            if data ~= nil and Game:hasUnlockedPartyMember(pm_id) and not Game:hasPartyMember(pm_id) then
                local actor = Game:getPartyMember(pm_id):getActor()
                local properties = Kristal.callEvent(KRISTAL_EVENT.getPartyNPCProperties, self, pm_id) or {}
                Game.world:spawnNPC(actor, x, y, properties)
            end
        else
            error("Attempted to create non-existent member \"" .. id .. "\"")
        end
    end
end

return Map