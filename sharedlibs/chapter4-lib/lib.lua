local lib = {}

Registry.registerGlobal("Ch4Lib", lib)
Ch4Lib = lib

function lib:init()
    Utils.merge(MUSIC_VOLUMES, {
        ch4_battle = 0.7
    })
	self.invert_alpha = love.graphics.newShader[[
		vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
        {
			vec4 col = texture2D( texture, texture_coords );
			return vec4(col.r,col.g,col.b,1-col.a);
        }
	]]
end

function Ch4Lib.scr_wave(arg0, arg1, speed_seconds, phase)
    local a4 = (arg1 - arg0) * 0.5;
    return arg0 + a4 + (math.sin((((Kristal.getTime()) + (speed_seconds * phase)) / speed_seconds) * (2 * math.pi)) * a4);
end

return lib