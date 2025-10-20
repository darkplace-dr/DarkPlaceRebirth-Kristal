local hospital_room, super = Class(Map)

function hospital_room:load()
  super.load(self)
end

function hospital_room:init(world, data)
  super.init(self, world, data)
end

function hospital_room:onEnter()
  super.onEnter(self)
  if Game:getFlag("POST_SNOWGRAVE") then
    Game.world.map:getImageLayer("room").visible = false
    if Game.world:getCharacter("susie_lw") then
      Game:getPartyMember("susie"):getActor().default = "walk_unhappy"
      Game.world:getCharacter("susie_lw"):resetSprite()
    end
    if Game.world:getCharacter("noelle_lw") then
      Game:getPartyMember("noelle"):getActor().default = "walk_sad"
      Game.world:getCharacter("noelle_lw"):resetSprite()
    end
  end
end

function hospital_room:onExit()
  super.onExit(self)
  if Game:getFlag("POST_SNOWGRAVE") then
    if Game.world:getCharacter("susie_lw") then
      Game:getPartyMember("susie"):getActor().default = "walk"
    end
    if Game.world:getCharacter("noelle_lw") then
      Game:getPartyMember("noelle"):getActor().default = "walk"
    end
  end
end

return hospital_room