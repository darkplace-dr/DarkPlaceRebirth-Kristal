return {
    enemy_dialogue = function(cutscene, battler, enemy)
		local enc = Game.battle.encounter
		local mike = Game.battle.enemies[1]
		enc.hand.juggle = true
		cutscene:battlerText(mike, {
			"[speed:3]Hey, nice to\nmeetcha!",
			"[speed:3]It's me, Motormouth Mike!\nThe Micro Phone who\ncroons and groans!",
			"[speed:3]Nice of you to drop by...\nNOT! NOT AT ALL,\nNO no no!",
			"[speed:3]Look with your private\neyes! This is a private\nroom, a private room,\nsee!?",
			"[speed:3]We are live, we are on \nair, we are recording,\nYOU are background\nnoise! Get out!",
			"[speed:3]... Or these 48 volts\nain't gonna be just\nfor show!"
		})
		enc.hand.juggle = false
		Game.battle:setState("DEFENDINGBEGIN")
		cutscene:endCutscene()
	end,
}