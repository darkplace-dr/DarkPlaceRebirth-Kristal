extern vec2 center;
extern float radius;
extern vec4 startColor;
extern vec4 endColor;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    float dist = distance(screen_coords, center);
    float factor = clamp(dist / radius, 0.0, 1.0);
    vec4 gradientColor = mix(startColor, endColor, factor);
    return gradientColor * color;
}