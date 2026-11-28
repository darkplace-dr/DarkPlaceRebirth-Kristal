---@class LOVEBlendMode: Class
---@field blend_mode love.BlendMode
---@field blend_alpha_mode love.BlendAlphaMode
---@overload fun(mode: love.BlendMode, alpha_mode: love.BlendAlphaMode): LOVEBlendMode
local LOVEBlendMode= Class(nil, "LOVEBlendMode")

---@param mode love.BlendMode
---@param alpha_mode love.BlendAlphaMode
function LOVEBlendMode:init(mode, alpha_mode)
    self.blend_mode = mode
    self.blend_alpha_mode = alpha_mode
end

return LOVEBlendMode
