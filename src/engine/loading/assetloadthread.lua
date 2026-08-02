---@diagnostic disable: lowercase-global
require("love.image")
require("love.sound")
require("love.timer")

_Class = require("src.lib.hump.class")
Class = require("src.utils.class")
ClassUtils = require("src.utils.classutils")
JSON = require("src.lib.json")
TableUtils = require("src.utils.tableutils")

AssetLoader = require("src.engine.loading.AssetLoader")
AssetLoaders = require("src.engine.loading.AssetLoaders")
AssetLoaders.init()

local worker_id = ... or 0

local in_channel = love.thread.getChannel("asset_load_in")
local out_channel = love.thread.getChannel("asset_load_out")

while true do
    local message = in_channel:demand()
    if message == "stop" then break end

    local decode_started_at = love.timer.getTime()
    local success, result = xpcall(function()
        return AssetLoaders.get(message.asset_type):load(message.asset_id, message.task)
    end, debug.traceback)
    local decode_time = love.timer.getTime() - decode_started_at
    collectgarbage("step", 64)

    out_channel:push({
        bucket_id = message.bucket_id,
        generation = message.generation,
        asset_type = message.asset_type,
        asset_id = message.asset_id,
        success = success,
        result = result,
        decode_time = decode_time,
        worker_id = worker_id,
        worker_heap_kb = collectgarbage("count"),
    })
end
