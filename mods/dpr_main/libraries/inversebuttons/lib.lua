local lib = {}

function lib:init()
Game:registerEvent("c", function(data)
        return c(data.x, data.y, {data.width, data.height, data.polygon})
    end)
    Game:registerEvent("iblock", function(data)
        return Inverse_block(data.x, data.y, {data.width, data.height, data.polygon})
    end)
    Game:registerEvent("n", function(data)
        return n(data.x, data.y, {data.width, data.height, data.polygon})
    end)
    Game:registerEvent("poof", function(data)
        return poof(data.x, data.y, {data.width, data.height, data.polygon})
    end)
    Game:registerEvent("poofbig", function(data)
        return poofbig(data.x, data.y, {data.width, data.height, data.polygon})
    end)
    Game:registerEvent("resetbutton", function(data)
        return ResetButton(data.x, data.y, {data.width, data.height, data.polygon})
    end)
    Game:registerEvent("cblock", function(data)
        return Copy_block(data.x, data.y, {data.width, data.height, data.polygon})
    end)
        Game:registerEvent("cmaker", function(data)
        return cmaker(data.x, data.y, {data.width, data.height, data.polygon})
    end)

end

return lib