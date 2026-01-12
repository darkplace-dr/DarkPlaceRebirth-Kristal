local lib = {}
local FFI = require "ffi"

Registry.registerGlobal("Ch4Lib", lib)
Ch4Lib = lib

Ch4Lib.BLEND_OPERATIONS = {
    add = 0x8006,             -- GL_FUNC_ADD
    subtract = 0x800A,        -- GL_FUNC_SUBTRACT
    reversesubtract = 0x800B, -- GL_FUNC_REVERSE_SUBTRACT
    min = 0x8007,             -- GL_MIN
    max = 0x8008,             -- GL_MAX
}

Ch4Lib.BLEND_FACTORS = {
    zero = 0,                   -- GL_ZERO
    one = 1,                    -- GL_ONE
    srccolor = 0x0300,          -- GL_SRC_COLOR
    oneminussrccolor = 0x0301,  -- GL_ONE_MINUS_SRC_COLOR
    srcalpha = 0x0302,          -- GL_SRC_ALPHA
    oneminussrcalpha = 0x0303,  -- GL_ONE_MINUS_SRC_ALPHA
    dstcolor = 0x0306,          -- GL_DST_COLOR
    oneminusdstcolor = 0x0307,  -- GL_ONE_MINUS_DST_COLOR
    dstalpha = 0x0304,          -- GL_DST_ALPHA
    oneminusdstalpha = 0x0305,  -- GL_ONE_MINUS_DST_ALPHA
    srcalphasaturated = 0x0308, -- GL_SRC_ALPHA_SATURATE
}

function lib:init()
    TableUtils.merge(MUSIC_VOLUMES, {
        ch4_battle = 0.7
    })
	self.invert_alpha = Assets.getShader("invert_alpha")
	self.accurate_blending = false
    if Kristal.getLibConfig("chapter4lib", "use_bm_subtract_blending") then
		self.accurate_blending = true
		local major, minor, revision = love.getVersion()
		if major < 12 then
			local STD = FFI.C
			if FFI.os == "Windows" then
				STD = FFI.load("SDL2")
			end

			FFI.cdef([[
				void* GL_GetProcAddress(const char *proc) asm("SDL_GL_GetProcAddress");
			]])

			local convention = (FFI.os == "Windows") and "__stdcall" or ""

			local function gl_func(name, signature)
				local proc = STD.GL_GetProcAddress(name)
				assert(proc ~= nil, "Failed to load GL function: " .. name)
				return FFI.cast(signature, proc)
			end

			local glBlendEquationSeparateSignature = ("void(%s*)(uint32_t,uint32_t)"):format(convention)
			local glBlendFuncSeparateSignature = ("void(%s*)(uint32_t,uint32_t,uint32_t,uint32_t)"):format(convention)

			Ch4Lib._glBlendEquationSeparate = gl_func("glBlendEquationSeparate", glBlendEquationSeparateSignature)
			Ch4Lib._glBlendFuncSeparate = gl_func("glBlendFuncSeparate", glBlendFuncSeparateSignature)
			if Ch4Lib._glBlendEquationSeparate == nil or Ch4Lib._glBlendFuncSeparate == nil then
				print("WARN: setBlendState implementation is not available on this system. Disabling...")
				self.accurate_blending = false
			end
		end
    end
end

function Ch4Lib.updateLightBeams(alpha)
	for index, value in ipairs(Game.world.stage:getObjects(TileObject)) do
		if value.light_area then
			value.light_amount = MathUtils.lerp(0.1, 1, alpha)
		end
	end
	for index, value in ipairs(Game.world.map:getEvents("lightbeamfx")) do
		value.alpha = MathUtils.lerp(0.1, 1, alpha)
	end
end

function Ch4Lib.scr_wave(arg0, arg1, speed_seconds, phase)
    local a4 = (arg1 - arg0) * 0.5;
    return arg0 + a4 + (math.sin((((Kristal.getTime()) + (speed_seconds * phase)) / speed_seconds) * (2 * math.pi)) * a4);
end

---@alias BlendOperation "add"|"subtract"|"reversesubtract"|"min"|"max"
---@alias BlendFactor "zero"|"one"|"srccolor"|"oneminussrccolor"|"srcalpha"|"oneminussrcalpha"|"dstcolor"|"oneminusdstcolor"|"dstalpha"|"oneminusdstalpha"|"srcalphasaturated"

--- Sets the low-level blending state.
---
---@param operationRGB BlendOperation The blend operation to use for RGB.
---@param operationAlpha BlendOperation The blend operation to use for Alpha.
---@param srcRGB BlendFactor The source blend factor to use for RGB.
---@param srcAlpha BlendFactor The source blend factor to use for Alpha.
---@param dstRGB BlendFactor The destination blend factor to use for RGB.
---@param dstAlpha BlendFactor The destination blend factor to use for Alpha.
---@return void
---@overload fun(operation: BlendOperation, srcFactor: BlendFactor, dstFactor: BlendFactor): void
function Ch4Lib.setBlendState(operationRGB, operationAlpha, srcRGB, srcAlpha, dstRGB, dstAlpha)
	if not Ch4Lib.accurate_blending then
		return
	end
    if (srcAlpha == nil and dstRGB == nil and dstAlpha == nil) then
        -- Handle 3-param overload
        local operation = operationRGB --[[@as BlendOperation]]
        local srcFactor = operationAlpha --[[@as BlendFactor]]
        local dstFactor = srcRGB --[[@as BlendFactor]]

        operationRGB, operationAlpha = operation, operation
        srcRGB, srcAlpha = srcFactor, srcFactor
        dstRGB, dstAlpha = dstFactor, dstFactor
    end

    local major, minor, revision = love.getVersion()
    if major >= 12 then
        -- Use built-in functionality in LÖVE 12+
        love.graphics.setBlendState(operationRGB, operationAlpha, srcRGB, srcAlpha, dstRGB, dstAlpha)
        return
    end

    if Ch4Lib._glBlendEquationSeparate == nil or Ch4Lib._glBlendFuncSeparate == nil then
        error("setBlendState implementation is not available on this system.")
    end

    love.graphics.flushBatch()
	
    Ch4Lib.assertOperationArgument(operationRGB)
    Ch4Lib.assertOperationArgument(operationAlpha)
    Ch4Lib.assertFactorArgument(srcRGB)
    Ch4Lib.assertFactorArgument(srcAlpha)
    Ch4Lib.assertFactorArgument(dstRGB)
    Ch4Lib.assertFactorArgument(dstAlpha)

    Ch4Lib._glBlendEquationSeparate(
        Ch4Lib.BLEND_OPERATIONS[operationRGB],
        Ch4Lib.BLEND_OPERATIONS[operationAlpha]
    )

    Ch4Lib._glBlendFuncSeparate(
        Ch4Lib.BLEND_FACTORS[srcRGB],
        Ch4Lib.BLEND_FACTORS[dstRGB],
        Ch4Lib.BLEND_FACTORS[srcAlpha],
        Ch4Lib.BLEND_FACTORS[dstAlpha]
    )
end

function Ch4Lib.assertOperationArgument(arg)
	if not Ch4Lib.accurate_blending then
		return
	end
    if Ch4Lib.BLEND_OPERATIONS[arg] == nil then
        error(
            string.format(
                "Invalid blend operation '%s', expected one of: 'add', 'subtract', 'reversesubtract', 'min', 'max'",
                arg
            )
        )
    end
end

function Ch4Lib.assertFactorArgument(arg)
	if not Ch4Lib.accurate_blending then
		return
	end
    if Ch4Lib.BLEND_FACTORS[arg] == nil then
        error(
            string.format(
                "Invalid blend factor '%s', expected one of: 'zero', 'one', 'srccolor', 'oneminussrccolor', 'srcalpha', 'oneminussrcalpha', 'dstcolor', 'oneminusdstcolor', 'dstalpha', 'oneminusdstalpha', 'srcalphasaturated'",
                arg
            )
        )
    end
end

return lib
