local lib = {}
Registry.registerGlobal("LightnersLiveLib", lib)
LightnersLiveLib = lib

function lib:init()
    
end

function lib:onRegistered()
    self.songs = {}
    self.song_data = {}

    for _,path,data in Registry.iterScripts("data/songs") do
        local split_path = StringUtils.split(path, "/", true)
        if isClass(data) then
            if split_path[#split_path] == "song" then
                self.songs[table.concat(split_path, "/", 1, #split_path-1)] = data
            else
                self.songs[path] = data
            end
        else
            if split_path[#split_path] == "data" then
                data.id = table.concat(split_path, "/", 1, #split_path-1)
                self.song_data[data.id] = data
            else
                data.id = path
                self.song_data[path] = data
            end
        end
    end
	__lastBPMChange = nil
	__lastTimeSignature = nil
end

function lib:createSong(id, ...)
    if self.songs[id] then
        local map = self.songs[id](self.song_data[id], ...)
        map.id = id
        return map
    elseif self.song_data[id] then
        local map = RhythmGameSong(self.song_data[id], ...)
        map.id = id
        return map
    else
        error("Attempt to create non existent song \"" .. tostring(id) .. "\"")
    end
end

return lib