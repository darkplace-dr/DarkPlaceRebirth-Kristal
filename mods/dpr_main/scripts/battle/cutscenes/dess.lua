return {
    dies = function(cutscene, battler, enemy)
        enemy:setSprite("hurt_defeat")
        Game.battle.music:fade(0, 1)
        cutscene:wait(1)
        -- TODO: Make this text use the speech bubbles
        cutscene:text("* so...", nil, "dess")
        enemy:setSprite("defeat")
        Assets.playSound("wing")
        enemy:shake(5)
        cutscene:wait(1)
        cutscene:text("* guess this is the end of the line for me", nil, "dess")
        cutscene:text("* well susie...", nil, "dess")
        cutscene:text("* you won", nil, "dess")
        enemy:setSprite("defeat_smirk")
        cutscene:text("* im off to go smoke that ciggie outside that 7/11 now", nil, "dess")
        Assets.playSound("vaporized", 1.2)
    
        local sprite = enemy:getActiveSprite()
    
        sprite.visible = false
        sprite:stopShake()
    
        local death_x, death_y = sprite:getRelativePos(0, 0, enemy)
        local death
        death = DustEffect(sprite:getTexture(), death_x, death_y, function() enemy:remove() end)
         
        death:setColor(sprite:getDrawColor())
        death:setScale(sprite:getScale())
        enemy:addChild(death)
        Game:setFlag("dessfight_end", true)
        Game.world:getCharacter("dess"):remove()
    end
}