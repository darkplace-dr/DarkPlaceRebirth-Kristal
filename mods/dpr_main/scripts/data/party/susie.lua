local character, super = HookSystem.hookScript("susie")

function character:init()
    super.init(self)

    self.health = 110

    self.stats = {
        health = 110,
        attack = 14,
        defense = 2,
        magic = 1
    }

    self:setWeapon("old_ax")
    self:setArmor(1, nil)
    self:setArmor(2, nil)
end

return character