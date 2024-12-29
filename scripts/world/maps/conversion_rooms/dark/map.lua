local DarkConversion, super = Class(Map)

-- DO NOT TOUCH THIS, THEY ARE HELD TOGETHER WITH WHAT LITTLE HOPES AND DREAMS I HAVE LEFT.
-- I have tried SO HARD to get inventory conversions between light and dark to work seamlessly when swapping mods.
-- But no matter WHAT I do, there's always SOMETHING that breaks.
-- Whoops, I duplicated my items. Whoops, I DELETED my items. WHOOPS, I caused an INFINITE LOOP in my save file and can NO LONGER SAVE!
-- So I give up! We're doing this the ugly hacky way. When you use swapIntoMod from a dark world map, you're brought to this map and then sent to your destination.
-- This allows inventory conversion to CORRECTLY happen when necessary, as, map transitions handle inventory conversion just fine.
-- Please do not alter this or its light counterpart unless you are 100% certain you have a better way to do this.
--    -Agent 7

function DarkConversion:onEnter()
    if Kristal.modswap_destination then
        Game.world.timer:after(1/30, function() 
            if Kristal.modswap_destination[1] == nil then Kristal.modswap_destination[1] = Mod.info.map end
            Game.world:loadMap(unpack(Kristal.modswap_destination))
            Kristal.modswap_destination = nil
        end)
    end
end



return DarkConversion