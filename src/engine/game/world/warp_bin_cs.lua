-- ┌───────────────────────┐ \
-- │     The Warp Bin      │ \
-- └───────────────────────┘ \
-- or: the feature creep bin    - dobby
---@param cutscene WorldCutscene
---@param event Event
return function(cutscene, event)
    cutscene:text("* It's the warp bin.")
    cutscene:text("* Would you like to warp?[wait:10]\n* You only need the code.")

    if cutscene:choicer({"Sure", "Nope"}) == 2 then
        return
    end

    local action_raw = cutscene:getUserText(8, "warpbin", nil, nil, {
        ---@type fun(text:string,key:string,object:WarpBinInputMenu|GonerKeyboard)
        key_callback = function (text, key, object, fade_rect)
            -- Kristal.Console.log(text..key)
            local code = Kristal:getBinCode(text..key)
            if code and code.instant then
                if object.__includes_all[GonerKeyboard] then
                    object.callback(text..key)
                else
                    object:finish_cb(text..key)
                end
                fade_rect:remove()
                object:remove()
            end
        end
    })
    ---@type WarpBinCodeInfo
    local action = Kristal:getBinCode(action_raw)

    if not action_raw then
        -- user changed their mind
        return
    elseif not action then
        Kristal.callEvent(KRISTAL_EVENT.onDPWarpBinUsed, action_raw)
        if event then
            if event.foolproof_counter == nil then event.foolproof_counter = 0 end
            event.foolproof_counter = event.foolproof_counter + 1
            if event.foolproof_counter == 10 then
                cutscene:text("* For some reason,[wait:5] the lid opened...")
                cutscene:text("* All you see inside is an unfinished void...")
                cutscene:text("* Check back later, perhaps?[wait:5]\n* But why would you?")
				return
                -- action = { result = "backrooms/gramophone" }
            else
                cutscene:text("* That doesn't seem to work.")
                if event.foolproof_counter >= 3 and event.foolproof_counter < 10 then
                    cutscene:text("* You're reminded of the fact that you can put in \"FLOORONE\" when you're stuck.")
                    if event.foolproof_counter >= 5 then
                        cutscene:text("* Seriously, you're not getting anywhere with this.")
                    end
                end
                return
            end
        else
            cutscene:text("* That doesn't seem to work.")
            return
        end
    end

    local warpable = GeneralUtils:evaluateCond(action)

    local result = action.result or action[1]
    local marker = action.marker or action[2]
    local mod = action.mod or action[3]
    local silence_system_messages = action.silence_system_messages
    if silence_system_messages == nil then
        silence_system_messages = false
    end

    if type(result) == "function" then
        result = result(cutscene)
        if not result then return end
        if type(result) == "table" then
            marker = result.marker or result[2]
            result = result.result or result[1]
        end
    elseif not warpable then
        if action.on_fail then
            action.on_fail(cutscene)
        elseif not silence_system_messages then
            cutscene:text("* That doesn't seem to work.")
        end
        return
    end

    assert(type(result) == "string", "result should be the id of a map or a function (got a "..type(result)..")")

    local dest_map
    pcall(function() dest_map = Registry.createMap(result, Game.world) end)
    if not dest_map and not mod then
        if not silence_system_messages then
            cutscene:text("* Where are you warping to?")
        end
        return
    end
    if (not mod or (mod == Mod.info.id)) and Game.world.map.id == dest_map.id  then
        if not silence_system_messages then
            cutscene:text("* But you're already there.")
        end
        return
    end

    if mod and mod ~= Mod.info.id then
        local has_dess = cutscene:getCharacter("dess") ~= nil

        if Kristal.Mods.data[mod] == nil then
            cutscene:text("* But no connection could be formed.")
            cutscene:text(string.format("* (Are you missing the %q DLC?)", mod))
            return
        end
        cutscene:text("* Your "
            .. (has_dess and "desstination" or "destination")
            .." is "
            ..(has_dess and "in another castle" or "infinitely far away")
            ..".\n* Leave this "
            .. (has_dess and "Dark " or "")
            .."Place?")
        local enter = cutscene:choicer({"Yes", "No"})

        if enter == 1 then
            cutscene:after(function()
                Game:swapIntoMod(mod, false, result)
            end)
            cutscene:wait(0.2)
            Game.world.music:fade(0, 80/30)
            cutscene:wait(cutscene:fadeOut(0, {color = {0, 0, 0}}))
            for i = 0,5 do
                cutscene:playSound("impact", (1 - (i/10)) ^ (4) )
                cutscene:wait(0.2)
            end
            cutscene:wait(1/4)
        else
            cutscene:text("* You bin't.")
        end
    else
        cutscene:wait(0.2)
        Game.world.music:stop()
        -- Hell naw is this the only way to stop all sounds?
        for key,_ in pairs(Assets.sound_instances) do
            Assets.stopSound(key, true)
        end
        cutscene:fadeOut(0)
        cutscene:playSound("impact")

        cutscene:wait(1)
        Kristal.callEvent(KRISTAL_EVENT.onDPWarpBinUsed, action_raw, action)
        cutscene:loadMap(dest_map, marker, "down")
        cutscene:fadeIn(0.25)
    end
end