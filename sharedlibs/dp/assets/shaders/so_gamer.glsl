// TODO: Document what the hell an octave is in this context. What are we reducing?!!? 
#define OCTAVES 4  // Reduced number of octaves

extern vec2 iResolution;
extern float iTime;

float random (in vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(3.1, 6.1))) * 30.1);
}

float noise (in vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float fbm (in vec2 uv) {
    float value = 0.0;
    float amplitude = 0.5;
    float frequency = 1.0;  // Initialize frequency to 1.0

    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(uv * frequency);  // Apply frequency scaling here
        frequency *= 2.0;  // Double the frequency each octave
        amplitude *= 0.5;
    }
    return value;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec2 uv = screen_coords / iResolution;

    uv.x *= iResolution.x / iResolution.y;

    vec3 col = 2.3 * 0.5 + cos(iTime * 8.0 + 10.0 * fbm(uv * 3.14159) + vec3(0, 23, 21));  // Use a constant for pi
    col += fbm(uv * 6.0);

    return Texel(tex, texture_coords) * vec4(col, 1.0) * color;
}