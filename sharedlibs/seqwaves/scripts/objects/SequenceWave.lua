---@class SequenceWave : Wave
local SequenceWave, super = Class(Wave)

function SequenceWave:init()
    super.init(self)
    self.time = 0
    ---@type Wave[]
    self.waves = {}
    self.waves_to_clear = {}
    self.clock = 0
    self.attackers = self:getAttackers()
end

---@generic T:Wave
---@param wave Wave | Wave.`T` | string
---@return T
function SequenceWave:addWave(wave, ...)
    for i = 1, #self.attackers do
        self.attackers[i].selected_wave = type(wave) == "string" and wave or wave.id or self.id or self.attackers[i].selected_wave
    end
    if type(wave) == "string" then
        wave = Registry.createWave(wave, ...)
    end
    ---@cast wave -string
    table.insert(self.waves, wave)
    return wave
end

function SequenceWave:addDelay(duration, blackout)
    ---@type Wave
    local wave = self:addWave(Wave())
    wave.time = duration
end

function SequenceWave:update()
    self.clock = self.clock + DT
    if self.clock > self.waves[1].time and self.waves[1]:canEnd() then
        self.clock = 0
        self.waves[1]:onEnd(false)
        -- self.waves[1]:clear()
        self.waves[1]:remove()
        table.insert(self.waves_to_clear, table.remove(self.waves, 1))
        if self.waves[1] then
            self:startNextSubwave()
        end
    end
end

function SequenceWave:startNextSubwave()
    for i = 1, #self.attackers do
        self.attackers[i].selected_wave = self.waves[1].id
    end
    self:spawnObject(self.waves[1])
    self.waves[1]:onStart()
    if self.waves[1].arena_x and self.waves[1].arena_y then
        self:setArenaPosition(self.waves[1].arena_x, self.waves[1].arena_y)
    end
    if self.waves[1].arena_width and self.waves[1].arena_height then
        self:setArenaSize(self.waves[1].arena_width, self.waves[1].arena_height)
    end
end

function SequenceWave:onStart()
    self:startNextSubwave()
    super.onStart(self)
end

function SequenceWave:clear()
    for _,wave in ipairs(self.waves_to_clear) do
        wave:clear()
    end
    super.clear(self)
end

function SequenceWave:canEnd()
    return #self.waves <= 0
end

return SequenceWave