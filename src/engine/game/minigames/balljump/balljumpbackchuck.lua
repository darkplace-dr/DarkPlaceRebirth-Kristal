---@class BallJumpBackChuck : BallJumpChuck
local BallJumpBackChucc, super = Class("BallJumpEntity")

function BallJumpBackChucc:init()
	super.init(self, -30, 266, 16, 16)

    self.sprite:set("chuck")
    self.sprite:play(1/10, true)
    self.layer = Game.minigame.ground.layer + 0.001

    self.collider = Hitbox(self, self.width/4, self.height/2, self.width, self.height)
    self.stomp_collider = Hitbox(self, self.width/4, 0, self.width, 0)

    self.move_speed = 12
    self.stomp_grace_period = 0

    self.sprite.flip_x = true

    self.collider = Hitbox(self, self.width/2, self.height/2, self.width, self.height)
    self.stomp_collider = Hitbox(self, self.width/2, 0, self.width, 0)

    self.move_speed = -2

    Assets.playSound("minigames/ball_jump/whistle")
end

function BallJumpBackChucc:updateMainCollision()
    self.stomp_grace_period = Utils.approach(self.stomp_grace_period, 0, DT)
    if self.stomp_collider and self.stomp_collider:collidesWith(Game.minigame.player.collider) then
        if self.stomp_grace_period <= 0 then
            Game.minigame.score = Game.minigame.score + 300 + 150 * Game.minigame.player.stomp_combo
            Game.minigame.player.stomp_combo = Game.minigame.player.stomp_combo + 1
            if Game.minigame.player.stomp_combo >= 8 then
                Assets.playSound("minigames/ball_jump/1up")
                Game.minigame.lives = Game.minigame.lives + 1
            end
            Assets.playSound("minigames/ball_jump/stomp")
            Game.minigame.player.velocity = -12
            self.move_speed = 6
            self.sprite:setSprite("chuck_hurt")
            self.stomp_grace_period = 5
        end
    else
        super.updateMainCollision(self)
    end
end

return BallJumpBackChucc