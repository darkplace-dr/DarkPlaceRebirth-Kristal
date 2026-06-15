uniform float minvalue;
uniform float maxvalue;

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec4 pix = Texel(tex, texture_coords);
    float luma = (pix.r + pix.g + pix.b)/3.0;
    if (pix.a == 0.0) {
        // a discarded pixel wont be applied as the stencil.
        discard;
    }
    if (luma < minvalue) {
        discard;
    }
    if (luma > maxvalue) {
        discard;
    }
    return vec4(1.0);
}
