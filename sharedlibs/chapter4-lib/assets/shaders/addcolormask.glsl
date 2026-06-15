extern vec3 inputcolor;
extern float amount;

vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
{   
    if (Texel(tex, texture_coords).a == 0.0) {
        // a discarded pixel wont be applied as the stencil.
        discard;
    }
    vec4 outputcolor = Texel(tex, texture_coords) * color;
    outputcolor.rgb += (inputcolor.rgb - outputcolor.rgb) * amount;
    return outputcolor;
}