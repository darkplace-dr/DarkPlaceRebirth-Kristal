varying vec3 normals;

#ifdef VERTEX

attribute vec3 VertexNormal;

vec4 position(mat4 clipSpaceFromLocal, vec4 localPosition)
{
    normals = VertexNormal;
	vec4 clipSpace = clipSpaceFromLocal * localPosition;
	clipSpace.xyz /= clipSpace.w;
	clipSpace.z = (1.0 - pow(1.005, -abs(clipSpace.z))) * sign(clipSpace.z);
	clipSpace.z /= 40.;
	clipSpace.w = 1.;
	return clipSpace;
}
#endif

#ifdef PIXEL
vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 texturecolor = Texel(tex, texture_coords);
    vec3 normaldisplay = normals;
    normaldisplay += vec3(1.0);
    normaldisplay *= 0.5;
    return texturecolor * color;
}
#endif

