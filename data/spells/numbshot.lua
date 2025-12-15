local spell, super = Class(Spell, "numbshot")

function spell:init()
    super.init(self)

    -- Display name
    self.name = "Numbshot"

    -- Battle description
    self.effect = "Sedative\nShot"
    -- Menu description
    self.description = "Shoots a sedative-laced shot at an enemy to induce SLEEP."
    -- Check description
    self.check = "Shoots a sedative-laced shot at an enemy to induce SLEEP."

    -- TP cost
    self.cost = 16

    -- Target mode (ally, party, enemy, enemies, or none)
    self.target = "enemy"

    -- Tags that apply to this spell
    self.tags = {"Damage", "spare_tired"}
end

function spell:getCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:getLightCastMessage(user, target)
    return "* "..user.chara:getName().." used "..self:getCastName().."!"
end

function spell:onCast(user, target)
	local damage = math.floor((((user.chara:getStat("attack") * 4)) - 3 * target.defense))

	local function generateSlash(scale_x)
		local cutAnim = Sprite("effects/attack/sling")
		Assets.playSound("scytheburst")
		Assets.playSound("criticalswing", 1.2, 1.3)
		user.overlay_sprite:setAnimation("battle/attack") -- Makes the afterimages use the first frame of the attack animation
		user:toggleOverlay(true)
		local afterimage1 = AfterImage(user, 0.5)
		local afterimage2 = AfterImage(user, 0.6)
		user:toggleOverlay(false)
		afterimage1.physics.speed_x = 2.5
		afterimage2.physics.speed_x = 5
		afterimage2:setLayer(afterimage1.layer - 1)
		user:setAnimation("battle/attack", function()
			user:setAnimation("battle/idle")
		end)
		user:flash()
		cutAnim:setOrigin(0.5, 0.5)
		cutAnim:setScale(2.5 * scale_x, 2.5)
		cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
		cutAnim.layer = target.layer + 0.01
		cutAnim:play(1/15, false, function(s) s:remove() end)
		user.parent:addChild(cutAnim)
		user.parent:addChild(afterimage1)
		user.parent:addChild(afterimage2)
	end

	generateSlash(1)
	target:hurt(damage, user)
	if target.health > 0 then
		if target.tired then
			Assets.playSound("spell_pacify")

			target:spare(true)

			local pacify_x, pacify_y = target:getRelativePos(target.width/2, target.height/2)
			local z_count = 0
			local z_parent = target.parent
			Game.battle.timer:every(1/15, function()
				z_count = z_count + 1
				local z = SpareZ(z_count * -40, pacify_x, pacify_y)
				z.layer = target.layer + 0.002
				z_parent:addChild(z)
			end, 8)
		else
			local recolor = target:addFX(RecolorFX())
			Game.battle.timer:during(8/30, function()
				recolor.color = ColorUtils.mergeColor(recolor.color, {0, 0, 1}, 0.12 * DTMULT)
			end, function()
				Game.battle.timer:during(8/30, function()
					recolor.color = ColorUtils.mergeColor(recolor.color, {1, 1, 1}, 0.16 * DTMULT)
				end, function()
					target:removeFX(recolor)
				end)
			end)
		end
	end
end

function spell:onLightCast(user, target)
	local damage = math.floor((((user.chara:getStat("attack") * 4)) - 3 * target.defense))

	local function generateSlash(scale_x)
		local cutAnim = Sprite("effects/attack/sling")
		Assets.playSound("scytheburst")
		Assets.playSound("criticalswing", 1.2, 1.3)
		cutAnim:setOrigin(0.5, 0.5)
		cutAnim:setScale(2.5 * scale_x, 2.5)
		cutAnim:setPosition(target:getRelativePos(target.width/2, target.height/2))
		cutAnim.layer = target.layer + 0.01
		cutAnim:play(1/15, false, function(s) s:remove() end)
		Game.battle:addChild(cutAnim)
	end

	generateSlash(1)
	target:hurt(damage, user)
	if target.health > 0 then
		target:spare(true)				-- Can someone do the Pacify graphics here too please? idk how to make it look UT
	end
end

function spell:isUsable(chara) return not chara.disarmed end

return spell
