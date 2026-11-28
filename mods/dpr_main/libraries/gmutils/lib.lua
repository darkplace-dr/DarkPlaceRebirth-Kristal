local lib = ACTIVE_LIB
local GMGraphics = modRequire('libraries.gmutils.src.utils.GMGraphics')
local GMBlending = modRequire('libraries.gmutils.src.utils.GMBlending')

function lib:init()
    GMGraphics.init()
    GMBlending.init()
end

function lib:preDraw()
    GMGraphics.reset()
end

return lib
