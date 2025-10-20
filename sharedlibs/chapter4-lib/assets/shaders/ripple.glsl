// #version 120
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

#define _YY_GLSL_ 1
#ifdef GL_NV_desktop_lowp_mediump
	precision highp float; 
	precision highp int;
#endif
varying vec4 v_vColour;
uniform vec2 rippleCenter;
uniform vec3 rippleRad; //current/max/thickness

vec4 effect(vec4 drawcolor, Image gm_BaseTexture, vec2 texture_coords, vec2 screen_coords)
{
	float _dist = distance(screen_coords.xy, rippleCenter.xy);
	float _edge = max(0.0, _dist - (rippleRad.x-rippleRad.z));
	float _perc = _dist / rippleRad.x;
	float _alph = _perc;
	float _rimthickness = rippleRad.z / 3.0;
	float _fadestart = rippleRad.y / 3.0;
	//if (_perc > 0.85) _alph = 0.85;
	//if (_perc > 0.90) _alph = 0.9;
	//if (_perc > 0.95) _alph = 1.0;
	if (_edge > 0.0) _alph = 0.6;
	if (_edge > _rimthickness) _alph = 0.8;
	if (_edge > _rimthickness * 2.0) _alph = 1.0;
	_edge = min(_edge, 1.0);
	if (_perc > 1.0) _alph = 0.0;
    vec4 outcolor = drawcolor; //* texture2D( gm_BaseTexture, v_vTexcoord );
    outcolor.a =  _edge * _alph * min(1.0,(1.0 - ((rippleRad.x-_fadestart)/(rippleRad.y-_fadestart))));
    return outcolor;
}
