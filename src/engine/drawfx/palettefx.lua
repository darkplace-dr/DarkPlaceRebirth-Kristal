---@class PaletteFX : FXBase
---@field base_pal number[][]
---@field live_pal number[][]
local PaletteFX, super = Class(FXBase)

---@param imagedata love.ImageData
---@param line integer
---@overload fun(self:PaletteFX, base_pal: number[][], live_pal:number[][], transformed, priority)
function PaletteFX:init(imagedata, line, transformed, priority)
    super.init(self, priority or 0)

    self.shader = Assets.getShader("palette")

    if type(imagedata) == "userdata" then
        ---@cast imagedata love.ImageData
        self.base_pal = {}
        
        self.live_pal = {}
        local r,g,b,a
        for x = 1, imagedata:getWidth() do
            r,g,b,a = imagedata:getPixel(x - 1, 0)
            table.insert(self.base_pal, {r,g,b,a})
            r,g,b,a = imagedata:getPixel(x - 1, line)
            table.insert(self.live_pal, {r,g,b,a})
        end
    else
        ---@cast imagedata -love.ImageData
        ---@cast line -integer
        self.base_pal = imagedata
        self.live_pal = line
    end

    self.transformed = transformed or false

    self.vars = vars or {}
end

function PaletteFX:draw(texture)
    local last_shader = love.graphics.getShader()
    love.graphics.setShader(self.shader)
	self.shader:send("base_palette", unpack(self.base_pal))
	self.shader:send("live_palette", unpack(self.live_pal))
    Draw.drawCanvas(texture)
    love.graphics.setShader(last_shader)
end

return PaletteFX