varying vec3 normals;

#ifdef VERTEX

attribute vec3 VertexNormal;

vec4 position(mat4 transform_projection, vec4 vertex_position) {
    normals = VertexNormal;
    // The order of operations matters when doing matrix multiplication.
    return transform_projection * vertex_position;
}
#endif

uniform sampler2D depthbuffer;

#ifdef PIXEL

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 depth = Texel(depthbuffer, screen_coords / vec2(640., 480.));
    vec4 texturecolor = Texel(tex, texture_coords);
    return texturecolor * color * vec4(depth.xwx / 2., 1.0);
}
#endif

