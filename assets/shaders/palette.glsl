#define MAX_PALETTE_ENTRIES 16
uniform vec4 base_palette[MAX_PALETTE_ENTRIES];
uniform vec4 live_palette[MAX_PALETTE_ENTRIES];

vec4 effect(vec4 color, Image image, vec2 uvs, vec2 screen_coords) {
    vec4 pixel = Texel(image, uvs);
    for(int i = 0; i < MAX_PALETTE_ENTRIES; ++i){
        vec4 color = base_palette[i];
        if(all(lessThan(abs(pixel - color), vec4(0.001))))
            return live_palette[i];
    }
    return pixel;
}