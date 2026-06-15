---@class RecruitMenu : RecruitMenu
local RecruitMenu, super = HookSystem.hookScript(RecruitMenu)

function RecruitMenu:init()
    super.init(self)

    self.heart:setSprite("player/"..Game:getSoulPartyMember():getSoulFacing().."/heart")
end

return RecruitMenu