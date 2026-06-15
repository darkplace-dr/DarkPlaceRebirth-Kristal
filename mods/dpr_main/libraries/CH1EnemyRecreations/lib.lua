local Lib = {}

function Lib:init()
    TableUtils.merge(MUSIC_VOLUMES, {
        ch4_battle = 0.7,
        titan_spawn = 0.7
    })

    HookSystem.hook(Battle, "spawnEnemyTextbox", function(orig, self, enemy, ...)
        if enemy and (enemy.id == "hathy" or enemy.id == "headhathy") then
            local x, y = enemy.sprite:getRelativePos(0, enemy.sprite.height/2, self)
            if enemy.dialogue_offset then
                x, y = x + enemy.dialogue_offset[1], y + enemy.dialogue_offset[2]
            end
            local textbox = HathySpeechBubble(x, y, enemy.balloon_type)
            self:addChild(textbox)
            return textbox
        else
            return orig(self, enemy, ...)
        end
    end)
end

return Lib