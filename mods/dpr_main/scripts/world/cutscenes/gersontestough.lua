local gersontestough = {
	animlaugh = function(cutscene)
    local gerson = cutscene:getCharacter("gerson")
    gerson:setAnimation("laugh")
	Assets.playSound("gerlaugh")
	end,
}
return gersontestough
