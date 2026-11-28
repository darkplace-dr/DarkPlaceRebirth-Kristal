local TextAlign = modRequire('libraries.gmutils.src.utils.constants.TextAlign')
local GMBlending = modRequire("libraries.gmutils.src.utils.GMBlending")
---@namespace JTestProj
---@class GMGraphics
---@field private text_align_horizontal TextAlign
---@field private text_align_vertical TextAlign
--- A module containing recreations of various GameMaker graphics functions. Useful for porting the niche.
local GMGraphics = {}

function GMGraphics.init()
    GMGraphics.rect_mesh = love.graphics.newMesh(
        {
            {"VertexPosition", "float", 2},
            {"VertexColor", "float", 3}
        },
        {
            {0,0,1,1,1},
            {1,0,1,1,1},
            {1,1,1,1,1},
            {0,1,1,1,1},
        },
        "fan"
    )
end

function GMGraphics.reset()
    GMGraphics.text_align_vertical = TextAlign.START
    GMGraphics.text_align_horizontal = TextAlign.START
end

---@param vertical TextAlign
---@param horizontal TextAlign
function GMGraphics.setTextAlign(horizontal, vertical)
    GMGraphics.text_align_horizontal = horizontal
    GMGraphics.text_align_vertical = vertical
end

---@param x number
---@param y number
---@param text string
---@param xscale number
---@param yscale number
---@param angle number
function GMGraphics.drawTransformedText(x, y, text, xscale, yscale, angle)
    local font = love.graphics.getFont()
    love.graphics.print(text, x, y, -math.rad(angle), xscale, yscale, (font:getWidth(text) * (GMGraphics.text_align_horizontal or TextAlign.START)), (font:getHeight() * (GMGraphics.text_align_vertical or TextAlign.START)))
end

---@param x number
---@param y number
---@param text string
---@param xscale number
---@param yscale number
---@param outline_color [number,number,number]
---@param arg6 boolean?
function GMGraphics.drawTransformedTextOutline(x, y, text, xscale, yscale, outline_color, arg6)
    outline_color = outline_color or COLORS.black
    arg6 = arg6 ~= false
    local _oldcolor = {love.graphics.getColor()}
    Draw.setColor(outline_color)
    GMGraphics.drawTransformedText(x - xscale, y, text, xscale, yscale, 0)
    GMGraphics.drawTransformedText(x + xscale, y, text, xscale, yscale, 0)
    GMGraphics.drawTransformedText(x, y + yscale, text, xscale, yscale, 0)
    GMGraphics.drawTransformedText(x, y - yscale, text, xscale, yscale, 0)
    
    if (arg6) then
        GMGraphics.drawTransformedText(x - xscale, y - yscale, text, xscale, yscale, 0)
        GMGraphics.drawTransformedText(x + xscale, y + yscale, text, xscale, yscale, 0)
        GMGraphics.drawTransformedText(x - xscale, y + yscale, text, xscale, yscale, 0)
        GMGraphics.drawTransformedText(x + xscale, y - yscale, text, xscale, yscale, 0)
    end
    
    Draw.setColor(_oldcolor)
    GMGraphics.drawTransformedText(x, y, text, xscale, yscale, 0)
end

---@param sprite love.Image[]
---@param frame number
---@return love.Image
function GMGraphics.getFrame(sprite, frame)
    return assert(sprite[MathUtils.wrapIndex(math.floor(frame+1), #sprite)])
end

---@param sprite love.Image[]
function GMGraphics.drawSpriteExt(sprite, subimg, x, y, xscale, yscale, rot, color, alpha)
    local old_color = {love.graphics.getColor()}
    Draw.setColor(color, alpha)
    Draw.draw(GMGraphics.getFrame(sprite, subimg), x, y, math.rad(rot), xscale, yscale)
    Draw.setColor(old_color)
end

---@param sprite love.Image[]
function GMGraphics.drawSpriteStretchedExt(sprite, subimg, x, y, width, height, color, alpha)
    local old_color = {love.graphics.getColor()}
    Draw.setColor(color, alpha)
    local tex = GMGraphics.getFrame(sprite, subimg)
    Draw.draw(tex, x, y, 0, width / tex:getWidth(), height / tex:getHeight())
    Draw.setColor(old_color)
end

---@param sprite love.Image[]
function GMGraphics.drawSpriteTiledExt(sprite, subimg, x, y, xscale, yscale, color, alpha)
    local old_color = {love.graphics.getColor()}
    Draw.setColor(color, alpha)
    Draw.drawWrapped(GMGraphics.getFrame(sprite, subimg), true, true, x, y, math.rad(0), xscale, yscale)
    Draw.setColor(old_color)
end

function GMGraphics.drawSpriteTiledArea(sprite, subimg, xx, yy, x1, y1, x2, y2, xscale, yscale, color, alpha)
    local texture = GMGraphics.getFrame(sprite, subimg)
    local sw, sh = texture:getWidth() * xscale, texture:getHeight() * yscale
    local i = x1 - ((x1 % sw) - (xx % sw)) - (sw * ((x1 % sw) < (xx % sw) and 1 or 0))
    local j = y1 - ((y1 % sh) - (yy % sh)) - (sh * ((y1 % sh) < (yy % sh) and 1 or 0))
    local jj = j
    
    while (i <= x2) do
        while (j <= y2) do
            local left
            if (i <= x1) then
                left = x1 - i
            else
                left = 0
            end

            local _x = i + left
            local top
            if (j <= y1) then
                top = y1 - j
            else
                top = 0
            end

            local _y = j + top
            local width
            if (x2 <= (i + sw)) then
                width = ((sw - ((i + sw) - x2)) + 1) - left
            else
                width = sw - left
            end

            local height
            if (y2 <= (j + sh)) then
                height = ((sh - ((j + sh) - y2)) + 1) - top
            else
                height = sh - top
            end

            local old_color = {love.graphics.getColor()}
            Draw.setColor(color, alpha)
            Draw.drawPart(GMGraphics.getFrame(sprite, subimg), _x, _y, left, top, width, height, math.rad(0), xscale, yscale)
            Draw.setColor(old_color)

            j = j + sh
        end

        j = jj
        i = i + sw
    end

    return 0
end

---@param outline false?
function GMGraphics.drawRectColored(x,y,x2,y2, color_topleft, color_topright, color_btmleft, color_btmright, outline)
    assert(not outline, "outline is not yet implemented! If you're getting this error it means you gotta implement it, sorry")
    GMGraphics.rect_mesh:setVertices(
        {
            { 0, 0, unpack(color_topleft, 1, 3) },
            { 1, 0, unpack(color_topright, 1, 3) },
            { 1, 1, unpack(color_btmleft, 1, 3) },
            { 0, 1, unpack(color_btmright, 1, 3) },
        }
    )
    -- love.graphics.setWireframe(true)
    love.graphics.draw(GMGraphics.rect_mesh, x, y, 0, x2 - x + 1, y2 - y + 1)
    -- love.graphics.setWireframe(false)
end

---@param mode BlendMode
function GMGraphics.setBlendMode(mode)
    if love.getVersion() >= 12 then
        love.graphics.setBlendState(mode.operationRGB, mode.operationA, mode.srcFactorRGB, mode.srcFactorA, mode.dstFactorRGB, mode.dstFactorA)
    elseif GMBlending.canUseFFIBlending() then
        GMBlending.setBlendState(mode.operationRGB, mode.operationA, mode.srcFactorRGB, mode.srcFactorA, mode.dstFactorRGB, mode.dstFactorA)
    else
        love.graphics.setBlendMode(mode.love_mode.blend_mode, mode.love_mode.blend_alpha_mode)
    end
end

return GMGraphics
