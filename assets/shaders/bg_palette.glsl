// Should always be the same as the value in src/engine/drawfx/palettefx.lua
#define MAX_PALETTE_ENTRIES 384
uniform vec4 base_palette[MAX_PALETTE_ENTRIES];
uniform vec4 live_palette[MAX_PALETTE_ENTRIES];
uniform bool debug;

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    vec4 pixel = Texel(image, uvs);
    if ((pixel * color).w < 1.0) {
        discard;
    }
    for(int i = 0; i < MAX_PALETTE_ENTRIES; ++i){
        vec4 check_color = base_palette[i];
        if(all(lessThan(abs(pixel - check_color), vec4(0.001))))
            return live_palette[i];
    }
    if(debug) return vec4(1,0,0,pixel.a);
    return pixel*color;
}