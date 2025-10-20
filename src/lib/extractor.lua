-- https://love2d.org/forums/viewtopic.php?t=78293
local lfs = love.filesystem

local extractor = {}

local function enu(folder, saveDir)
    local filesTable = lfs.getDirectoryItems(folder)
	if saveDir ~= "" and not lfs.getInfo(saveDir, "directory") then lfs.createDirectory(saveDir) end
   
    for i,v in ipairs(filesTable) do
		local file = folder.."/"..v
		local saveFile = saveDir.."/"..v
		if saveDir == "" then saveFile = v end
      
        if lfs.isDirectory(file) then
			lfs.createDirectory(saveFile)
            enu(file, saveFile)
        else
			lfs.write(saveFile, tostring(lfs.read(file)))
		end
    end
end

function extractor.extractZIP(file, dir, delete, callback)
	local dir = dir or ""
	local temp = tostring(math.random(1000, 2000))
	success = lfs.mount(file, temp)
    if success then enu(temp, dir) end
	lfs.unmount(file)
	if delete then lfs.remove(file) end
	if callback then callback() end
end

return extractor