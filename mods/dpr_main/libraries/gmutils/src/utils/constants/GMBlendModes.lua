local BlendMode = modRequire("libraries.gmutils.src.utils.BlendMode")
local LOVEBlendMode = modRequire("libraries.gmutils.src.utils.LOVEBlendMode")

-- Default blend mode for ones that really don't have a close enough equivalent
local placeholder_blend_mode = LOVEBlendMode("alpha", "alphamultiply")

--- A list of the blend modes present in GameMaker, recreated to make porting easier.
---@class GMBlendModes
local GMBlendModes = {
    -- Normal blending (the default blend mode).
    NORMAL = BlendMode("add", "srcalpha", "oneminussrcalpha", LOVEBlendMode("alpha", "alphamultiply")),

    -- Additive blending. Luminosity values of light areas are added.
    ADD = BlendMode("add", "srcalpha", "one", LOVEBlendMode("add", "premultiplied")),

    -- Subtractive blending. Source is subtracted from the destination.
    SUBTRACT = BlendMode("add",  "zero", "oneminussrccolor", LOVEBlendMode("subtract", "premultiplied")),

    -- Reverse subtractive blending. Destination is subtracted from the source.
    REVERSE_SUBTRACT = BlendMode("reversesubtract", "srcalpha", "one", placeholder_blend_mode),

    -- Smaller value from source and destination is selected.
    MIN = BlendMode("min", "one", "one", placeholder_blend_mode),

    -- Max blending. Similar to additive blending.
    MAX = BlendMode("max", "srcalpha", "oneminussrccolor", placeholder_blend_mode),

    -- "Custom" modes:

    -- Blend "masking", the same as GameMaker's `gpu_set_blendmode_ext(bm_dest_alpha, bm_inv_dest_alpha);`
    DEST_ALPHA_MASK = BlendMode("add", "dstalpha", "oneminusdstalpha", placeholder_blend_mode),

    -- Variant of SUBTRACT that may be needed when combined with LÖVE blend modes(?)
    -- TODO: Find out exactly _why_ we need this.
    SUBTRACT_ALT = BlendMode("add", "add",  "zero", "one", "oneminussrccolor", "oneminussrccolor", LOVEBlendMode("subtract", "premultiplied")),
}

return GMBlendModes
