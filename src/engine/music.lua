---@class Music : Class
---
---@field volume number
---@field pitch number
---@field looping boolean
---
---@field started boolean
---
---@field target_volume number
---@field fade_speed number
---@field fade_callback fun(music:Music)?
---
---@field removed boolean
---
---@field current string?
---@field private source love.Source?
---@field private decoder love.Decoder
---
---@field private samples_count integer
---@field private loop_start integer
---@field private buffer_samples_count integer[]
---@field private BUFFER_COUNT integer
---
---@overload fun() : Music
local Music = {}

Music.BUFFER_COUNT = 16

---@type Music[]
local _handlers = {}

function Music:init()
    self.volume = 1

    self.pitch = 1
    self.looping = true

    self.started = false

    self.target_volume = 0
    self.fade_speed = 0
    self.fade_callback = nil

    self.removed = false

    self.current = nil
    self.source = nil
    self.decoder = nil

    self.loop_start = 0
    self.samples_count = 0
    self.buffer_samples_count = {}
    self.builtin_pitch = 1
    self.builtin_volume = 1
    for i = 1, Music.BUFFER_COUNT do
        self.buffer_samples_count[i] = 0
    end
end

---@param to? number
---@param speed? number
---@param callback? fun(music:Music)
function Music:fade(to, speed, callback)
    self.target_volume = to or 0
    self.fade_speed = speed or (10/30)
    self.fade_callback = callback
end

---@return number
function Music:getVolume()
    return self.volume * MUSIC_VOLUME * (self.current and MUSIC_VOLUMES[self.current] or 1) * self.builtin_volume
end

---@return number
function Music:getPitch()
    return self.pitch * (self.current and MUSIC_PITCHES[self.current] or 1) * self.builtin_pitch
end

---@param music? string
---@param volume? number
---@param pitch? number
function Music:play(music, volume, pitch)
    if music then
        local path = Assets.getMusicPath(music)
        if not path then
            return
        end
        self:playFile(path, volume, pitch, music)
    else
        self:playFile(nil, volume, pitch)
    end
end

---@param decoder love.Decoder
---@private
function Music:queue(decoder)
    self.queued_decoder = decoder
    assert(
        self.decoder:getSampleRate() == self.queued_decoder:getSampleRate()
        and self.decoder:getBitDepth() == self.queued_decoder:getBitDepth()
        and self.decoder:getChannelCount() == self.queued_decoder:getChannelCount()
        , "Intro-loop format (sample rate, bit depth, channel count) mismatch"
    )
end

---@param path? string
---@param volume? number
---@param pitch? number
---@param name? string
function Music:playFile(path, volume, pitch, name)
    if self.removed then
        return
    end

    self.fade_speed = 0

    if path then
        name = name or path
        if volume then
            self.volume = volume
        end
        if self.current ~= name or not self.source or not self.source:isPlaying() then
            if self.source then
                self.source:stop()
            end
            self.current = name
            self.loop_start = 0
            self.builtin_pitch = 1
            self.builtin_volume = 1
            self.queued_decoder = nil
            self.pitch = pitch or 1
            self.decoder = love.sound.newDecoder(path)
            self.source = love.audio.newQueueableSource(self.decoder:getSampleRate(), self.decoder:getBitDepth(), self.decoder:getChannelCount(), Music.BUFFER_COUNT)
            if Assets.hasMusic(name) then
                local info = Assets.getMusic(name)
                self.loop_start = info.metadata.loop_start
                self.builtin_volume = info.metadata.volume
                self.builtin_pitch = info.metadata.pitch
                if info.loop_path then
                    self:queue(love.sound.newDecoder(info.loop_path))
                end
            end
            self.source:setVolume(self:getVolume())
            self.source:setPitch(self:getPitch())
            self:resume()
            self.started = true
        else
            if volume then
                self.source:setVolume(self:getVolume())
            end
            if pitch then
                self.pitch = pitch
                self.source:setPitch(self:getPitch())
            end
        end
    elseif self.source then
        if volume then
            self.volume = volume
            self.source:setVolume(self:getVolume())
        end
        if pitch then
            self.pitch = pitch
            self.source:setPitch(self:getPitch())
        end
        self.source:play()
        self.started = true
    end
end

---@param volume number
function Music:setVolume(volume)
    self.volume = volume
    if self.source then
        self.source:setVolume(self:getVolume())
    end
end

---@param pitch number
function Music:setPitch(pitch)
    self.pitch = pitch
    if self.source then
        self.source:setPitch(self:getPitch())
    end
end

---@param loop boolean
function Music:setLooping(loop)
    self.looping = loop
    if self.source then
    end
end

---@param time number
function Music:seek(time)
    self.samples_count = math.floor(time * self.decoder:getSampleRate())
    self.decoder:seek(self.samples_count / self.decoder:getSampleRate())
    for i = 1, Music.BUFFER_COUNT do
        self.buffer_samples_count[i] = 0
    end
    local was_playing = self.source:isPlaying()
    self.source:stop()
    self.source:release()
    self.source = love.audio.newQueueableSource(self.decoder:getSampleRate(), self.decoder:getBitDepth(), self.decoder:getChannelCount(), Music.BUFFER_COUNT)
    self.source:setPitch(self:getPitch())
    self.source:setVolume(self:getVolume())
    if was_playing then
        self:resume()
    end
    self:updateBuffer()
end

---@return number
function Music:tell()
    self:updateBuffer()
    assert(self.source)
    return self.source:tell() + (self.samples_count / self.decoder:getSampleRate())
end

function Music:stop()
    self.fade_speed = 0
    if self.source then
        self.source:stop()
        self:seek(0)
    end
    self.started = false
end

function Music:updateBuffer()
    if not self.decoder or not self.source then
        return false
    end
    local freeBufferCount = self.source:getFreeBufferCount()
    for i = 1, freeBufferCount do
        local loop_sample_amount = 0
        local looped = false
        local soundData = self.decoder:decode()
        if not soundData then
            if self.queued_decoder then
                self.decoder = self.queued_decoder
                self.queued_decoder = nil
                return self:updateBuffer()
            end
            -- The decoder reached the end of the file! Don't need to do anything else.
            if not self.looping then
                break
            end
            loop_sample_amount = self.samples_count

            for buffer_n = 1, i do
                loop_sample_amount = loop_sample_amount + assert(self.buffer_samples_count[buffer_n])
            end
            loop_sample_amount = loop_sample_amount - self.loop_start

            -- Reset the decoder to the start and decode from the start
            self.decoder:seek(math.max(0, self.samples_count - loop_sample_amount) / self.decoder:getSampleRate())
            soundData = self.decoder:decode()
            if not soundData then
                break
            end
        end
        self.samples_count = self.samples_count + self.buffer_samples_count[1]--[[@as -nil]]
        table.remove(self.buffer_samples_count, 1)
        self.buffer_samples_count[Music.BUFFER_COUNT] = soundData:getSampleCount()--[[@as integer]]
        self.source:queue(soundData)
        if loop_sample_amount ~= 0 then
            local buf_index = Music.BUFFER_COUNT - i - 1
            if buf_index > 0 then
                self.buffer_samples_count[buf_index]
                = math.floor(self.buffer_samples_count[buf_index]--[[@as -nil]] ) - loop_sample_amount
            else
                self.samples_count = self.samples_count - loop_sample_amount
            end
        end
    end
end

function Music:pause()
    if self.source then
        self.source:pause()
    end
    self.started = false
end

function Music:resume()
    self:updateBuffer()
    if self.source then
        self.source:play()
    end
    self.started = true
end

---@return boolean
function Music:isPlaying()
    return self.started
end

---@return boolean
function Music:canResume()
    return self.source ~= nil and not self.source:isPlaying()
end

function Music:remove()
    TableUtils.removeValue(_handlers, self)
    if self.source then
        self.source:stop()
        self.source = nil
    end
    self.started = false
    self.removed = true
end

-- Static Functions

local function getAll()
    return _handlers
end

local function getPlaying()
    local result = {}
    for _,handler in ipairs(_handlers) do
        if handler.source and handler.source:isPlaying() then
            table.insert(result, handler)
        end
    end
    return result
end

local function stop()
    for _,handler in ipairs(_handlers) do
        if handler.source and handler.source:isPlaying() then
            handler.source:stop()
        end
    end
end

local function clear()
    for _,handler in ipairs(_handlers) do
        if handler.source then
            handler.source:stop()
        end
    end
    _handlers = {}
end

local function update()
    for _,handler in ipairs(_handlers) do
        if handler.fade_speed ~= 0 and handler.volume ~= handler.target_volume then
            handler.volume = MathUtils.approach(handler.volume, handler.target_volume, DT / handler.fade_speed)

            if handler.volume == handler.target_volume then
                handler.fade_speed = 0

                if handler.fade_callback then
                    handler:fade_callback()
                end
            end
        end

        if handler.source then
            if handler.started and not handler.source:isPlaying() then
                handler:resume()
            end
            handler:updateBuffer()
            local volume = handler:getVolume()
            if handler.source:getVolume() ~= volume then
                handler.source:setVolume(volume)
            end
            local pitch = handler:getPitch()
            if handler.source:getPitch() ~= pitch then
                handler.source:setPitch(pitch)
            end
        end
    end
end

local function new(music, volume, pitch)
    local handler = setmetatable({}, {__index = Music})

    table.insert(_handlers, handler)
    handler:init()

    if music then
        handler.current = music
        handler.volume = volume or 1
        handler.pitch = pitch or 1
        handler:play(music, volume, pitch)
    end

    return handler
end

local module = {
    new = new,
    update = update,
    clear = clear,
    stop = stop,
    getAll = getAll,
    getPlaying = getPlaying,
    lib = Music,
}

return setmetatable(module, {__call = function(t, ...) return new(...) end})
