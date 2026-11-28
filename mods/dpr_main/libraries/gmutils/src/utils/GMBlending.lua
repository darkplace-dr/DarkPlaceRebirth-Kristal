local GMBlending = {}
local _, FFI = pcall(require, "ffi")

---@enum (key) BlendOperation
GMBlending.BLEND_OPERATIONS = {
    add = 0x8006,             -- GL_FUNC_ADD
    subtract = 0x800A,        -- GL_FUNC_SUBTRACT
    reversesubtract = 0x800B, -- GL_FUNC_REVERSE_SUBTRACT
    min = 0x8007,             -- GL_MIN
    max = 0x8008,             -- GL_MAX
}

---@enum (key) BlendFactor
GMBlending.BLEND_FACTORS = {
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

function GMBlending.canUseFFIBlending()
    return FFI ~= nil and GMBlending.accurate_blending
end

function GMBlending.init()
	GMBlending.accurate_blending = false

    if Kristal.getLibConfig("gmutils", "use_ffi_blending") then
		local major, minor, revision = love.getVersion()
		if major < 12 and FFI then
            print("Trying to set up blending with ffi")
            GMBlending.accurate_blending = true
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

			GMBlending._glBlendEquationSeparate = gl_func("glBlendEquationSeparate", glBlendEquationSeparateSignature)
			GMBlending._glBlendFuncSeparate = gl_func("glBlendFuncSeparate", glBlendFuncSeparateSignature)
			if GMBlending._glBlendEquationSeparate == nil or GMBlending._glBlendFuncSeparate == nil then
				print("WARN: setBlendState implementation is not available on this system. Disabling...")
				GMBlending.accurate_blending = false
			end
            print("Done set up blenmbd")
		end
    end
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
function GMBlending.setBlendState(operationRGB, operationAlpha, srcRGB, srcAlpha, dstRGB, dstAlpha)
	if not GMBlending.accurate_blending then
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

    if GMBlending._glBlendEquationSeparate == nil or GMBlending._glBlendFuncSeparate == nil then
        error("setBlendState implementation is not available on this system.")
    end

    love.graphics.flushBatch()
	
    GMBlending.assertOperationArgument(operationRGB)
    GMBlending.assertOperationArgument(operationAlpha)
    GMBlending.assertFactorArgument(srcRGB)
    GMBlending.assertFactorArgument(srcAlpha)
    GMBlending.assertFactorArgument(dstRGB)
    GMBlending.assertFactorArgument(dstAlpha)

    GMBlending._glBlendEquationSeparate(
        GMBlending.BLEND_OPERATIONS[operationRGB],
        GMBlending.BLEND_OPERATIONS[operationAlpha]
    )

    GMBlending._glBlendFuncSeparate(
        GMBlending.BLEND_FACTORS[srcRGB],
        GMBlending.BLEND_FACTORS[dstRGB],
        GMBlending.BLEND_FACTORS[srcAlpha],
        GMBlending.BLEND_FACTORS[dstAlpha]
    )
end

function GMBlending.assertOperationArgument(arg)
	if not GMBlending.accurate_blending then
		return
	end
    if GMBlending.BLEND_OPERATIONS[arg] == nil then
        error(
            string.format(
                "Invalid blend operation '%s', expected one of: 'add', 'subtract', 'reversesubtract', 'min', 'max'",
                arg
            )
        )
    end
end

function GMBlending.assertFactorArgument(arg)
	if not GMBlending.accurate_blending then
		return
	end
    if GMBlending.BLEND_FACTORS[arg] == nil then
        error(
            string.format(
                "Invalid blend factor '%s', expected one of: 'zero', 'one', 'srccolor', 'oneminussrccolor', 'srcalpha', 'oneminussrcalpha', 'dstcolor', 'oneminusdstcolor', 'dstalpha', 'oneminusdstalpha', 'srcalphasaturated'",
                arg
            )
        )
    end
end

return GMBlending
