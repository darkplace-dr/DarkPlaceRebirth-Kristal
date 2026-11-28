local ShiIntimidate, super = HookSystem.hookScript("ShiIntimidate")

function ShiIntimidate:setPoseSprite(battler)
    if battler.chara.id == "dess" then
        battler:setSprite("t_pose")
        self:afterimageEffect(battler)
    end
    super.setPoseSprite(self, battler)
end

function ShiIntimidate:setWrongPoseSprite(battler)
    if battler.chara.id == "dess" then
        battler:setSprite("d_pose")
        self:afterimageEffect(battler)
    end
    super.setWrongPoseSprite(self, battler)
end

return ShiIntimidate
