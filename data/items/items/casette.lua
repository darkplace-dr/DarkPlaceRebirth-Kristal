local item, super = Class(Item, "casette")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Casette"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"
    -- Item icon (for equipment)
    self.icon = nil

    -- Battle description
    self.effect = "Play\nMusic"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "Changes the current music, has two sides:\nOne for in and one for outside battle."

    -- Default shop price (sell price is halved)
    self.price = 400
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {}
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = nil
    self.bonus_icon = nil

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {}

    -- Character reactions
    self.reactions = {}
end

function item:onWorldUse(target)
    if Game.world.map.last_music == nil then
        Game.world.map.last_music = Game.world.music:isPlaying() and Game.world.music.current or false
        Game.world.music:play("whereverwearenow")
    elseif Game.world.map.last_music then
        Game.world.music:play(Game.world.map.last_music)
        Game.world.map.last_music = nil
    else
        Game.world.music:stop()
    end
    return false
end

function item:onBattleSelect(user, target)
    if Game.battle.last_music == nil then
        Game.battle.last_music = Game.battle.music:isPlaying() and Game.battle.music.current or false
        Game.battle.music:play("facedown")
    elseif Game.battle.last_music then
        Game.battle.music:play(Game.battle.last_music)
        Game.battle.last_music = nil
    else
        Game.battle.music:stop()
    end
    return false
end

function item:onBattleDeselect(user, target)
    self:onBattleSelect(user,target)
end

function item:getBattleText(user, target)
    if Game.battle.encounter.onCasetteUse then
        return Game.battle.encounter:onCasetteUse(self, user)
    end
    return "* "..user.chara:getName().." changes the beat with "..self:getUseName().."!"
end

return item