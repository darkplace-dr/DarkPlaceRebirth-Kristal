---@enum LoadingMode
local LoadingMode = {
    -- Assets that are needed immediately are loaded on-demand, while unrelated assets are loaded in the background.
    -- This is the default.
    SEMI_LAZY = 0,
    -- All assets are loaded before gameplay starts.
    FULL = 1,
    -- Assets are not loaded until they are needed.
    LAZY = 2,
}

return LoadingMode
