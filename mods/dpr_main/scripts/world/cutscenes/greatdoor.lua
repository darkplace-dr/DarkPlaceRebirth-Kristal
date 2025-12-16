---@param cutscene WorldCutscene
return function(cutscene)
    local door = Game.world:getEvent("greatdoor")
    cutscene:text("* Do you want to go to the Light World?")
    cutscene:text("* (Note: Your items may disappear after re-entering the Dark World.)")
    local choice = cutscene:choicer({"Yes", "No"})
    if choice == 1 then
        door:open()
        cutscene:wait(1)
        cutscene:detachFollowers()
        for _,pm in ipairs(Game.party) do
            local chara = Game.world:getCharacter(pm.actor.id)
            if chara then
                cutscene:wait(cutscene:walkToSpeed(chara, 320, 300, 6, "up"))
                cutscene:walkToSpeed(chara, 320, 240, 4, "up")
                chara:fadeTo(0, 0.5)
                cutscene:wait(1)
            end
        end
        cutscene:wait(0.5)
        door:close()
        cutscene:wait(1)
        cutscene:playSound("revival")
        local flash_parts = {}
        local flash_part_total = 12
        local flash_part_grow_factor = 0.5
        for i = 1, flash_part_total - 1 do
            -- width is 1px for better scaling
            local part = Rectangle(SCREEN_WIDTH / 2, 0, 1, SCREEN_HEIGHT)
            part:setOrigin(0.5, 0)
            part.layer = WORLD_LAYERS["below_ui"] - i
            part:setColor(1, 1, 1, -(i / flash_part_total))
            part.graphics.fade = flash_part_grow_factor / 16
            part.graphics.fade_to = math.huge
            part.scale_x = i*i * 2
            part.graphics.grow_x = flash_part_grow_factor*i * 2
            table.insert(flash_parts, part)
            Game.world:addChild(part)
        end

        local function fade(step, color)
            local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
            rect:setParallax(0, 0)
            rect:setColor(color)
            rect.layer = WORLD_LAYERS["below_ui"] + 1
            rect.alpha = 0
            rect.graphics.fade = step
            rect.graphics.fade_to = 1
            Game.world:addChild(rect)
            cutscene:wait(1 / step / 30)
        end

        cutscene:wait(50/30)
        fade(0.02, {1, 1, 1})
        cutscene:wait(20/30)
        cutscene:wait(cutscene:fadeOut(100/30, {color = {0, 0, 0}}))
        cutscene:wait(1)

        cutscene:fadeIn(1, {color = {1, 1, 1}})
        cutscene:after(Game:swapIntoMod("dpr_light"))
    end
end