return {
    dies = function(cutscene, battler, enemy)
        enemy:setSprite("hurt_defeat")
        Game.battle.music:fade(0, 1)
        cutscene:wait(1)
        cutscene:battlerText(enemy, "so...")
        enemy:setSprite("defeat")
        Assets.playSound("wing")
        enemy:shake(5)
        cutscene:wait(1)
        cutscene:battlerText(enemy, "guess this is\nthe end of the\nline for me")
        cutscene:battlerText(enemy, "well susie...")
        cutscene:battlerText(enemy, "you won")
        enemy:setSprite("defeat_smirk")
        cutscene:battlerText(enemy, "im off to go\nsmoke that ciggie\noutside that 7/11 now")
        Assets.playSound("vaporized", 1.2)
    
        local sprite = enemy:getActiveSprite()
    
        sprite.visible = false
        sprite:stopShake()
    
        local death_x, death_y = sprite:getRelativePos(0, 0, enemy)
        local death
        death = DustEffect(sprite:getTexture(), death_x, death_y, true, function() enemy:remove() end)
         
        death:setColor(sprite:getDrawColor())
        death:setScale(sprite:getScale())
        enemy:addChild(death)
        Game:setFlag("dessfight_end", true)
        Game.world:getCharacter("dess"):remove()
    end
}