extern vec2 size;            // vector containing image size, like shader:send('size', {img:getWidth(), img:getHeight()})
extern number factor;        // number contains sample size, like shader:send('factor', 2), must be divisible by 2

vec4 effect(vec4 color, Image img, vec2 texture_coords, vec2 pixel_coords) {
    vec2 tc = floor(texture_coords * size / factor) * factor / size;
    return Texel(img, tc) * color;  // Multiplying by 'color' preserves the full RGBA information
}