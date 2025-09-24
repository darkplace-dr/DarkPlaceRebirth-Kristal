#define LOWPREC 
#define lowp
#define mediump
#define highp
#define precision
// Uniforms look like they're shared between vertex and fragment shaders in GLSL, so we have to be careful to avoid name clashes

uniform sampler2D gm_BaseTexture;

uniform bool gm_PS_FogEnabled;
uniform vec4 gm_FogColour;
uniform bool gm_AlphaTestEnabled;
uniform float gm_AlphaRefValue;

void DoAlphaTest(vec4 SrcColour)
{
	if (gm_AlphaTestEnabled)
	{
		if (SrcColour.a <= gm_AlphaRefValue)
		{
			discard;
		}
	}
}

void DoFog(inout vec4 SrcColour, float fogval)
{
	if (gm_PS_FogEnabled)
	{
		SrcColour = mix(SrcColour, gm_FogColour, clamp(fogval, 0.0, 1.0)); 
	}
}

#define _YY_GLSL_ 1
//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 _hsv;

#define M_PI 3.14159265

vec3 TransformHSV
(
    vec3 inputCol,  // color to transform
    float h,          // hue shift (in degrees)
    float s,          // saturation multiplier (scalar)
    float v           // value multiplier (scalar)
) 
{
    float vsu = v * s * cos(h * M_PI/180.0);
    float vsw = v * s * sin(h * M_PI/180.0);
    
    vec3 ret = vec3(0.0);
    ret.r = (.299*v + .701*vsu + .168*vsw)*inputCol.r
        +   (.587*v - .587*vsu + .330*vsw)*inputCol.g
        +   (.114*v - .114*vsu - .497*vsw)*inputCol.b;
    ret.g = (.299*v - .299*vsu - .328*vsw)*inputCol.r
        +   (.587*v + .413*vsu + .035*vsw)*inputCol.g
        +   (.114*v - .114*vsu + .292*vsw)*inputCol.b;
    ret.b = (.299*v - .300*vsu + 1.25*vsw)*inputCol.r
        +   (.587*v - .588*vsu - 1.05*vsw)*inputCol.g
        +   (.114*v + .886*vsu - .203*vsw)*inputCol.b;
    
    return ret;
}


vec4 effect(vec4 drawcolor, Image tex, vec2 texture_coords, vec2 screen_coords) {
	vec4 color = drawcolor * texture2D( tex, texture_coords);
    color.rgb = TransformHSV(color.rgb, _hsv.r, _hsv.g, _hsv.b );
    return color;
}