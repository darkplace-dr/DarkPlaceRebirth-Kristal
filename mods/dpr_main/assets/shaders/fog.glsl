#ifdef GL_ES
precision mediump float;
#endif

uniform float iTime;
uniform vec2 screenSize; // Or replace with `love_love_ScreenSize` if you're using LÖVE's built-in uniforms.

const vec3 COLOR = vec3(0.42, 0.40, 0.87);
const vec3 BG = vec3(0.0, 0.0, 0.0);
const float ZOOM = 3.0;
const int OCTAVES = 4;
const float INTENSITY = 2.0;

float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9818, 79.279))) * 43758.5453123);
}

vec2 random2(vec2 st) {
    st = vec2(dot(st, vec2(127.1, 311.7)), dot(st, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(st) * 7.0);
}

float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(
        mix(dot(random2(i + vec2(0.0, 0.0)), f - vec2(0.0, 0.0)),
            dot(random2(i + vec2(1.0, 0.0)), f - vec2(1.0, 0.0)), u.x),
        mix(dot(random2(i + vec2(0.0, 1.0)), f - vec2(0.0, 1.0)),
            dot(random2(i + vec2(1.0, 1.0)), f - vec2(1.0, 1.0)), u.x), u.y);
}

float fractal_brownian_motion(vec2 coord) {
    float value = 0.0;
    float scale = 0.2;
    for (int i = 0; i < OCTAVES; i++) {
        value += noise(coord) * scale;
        coord *= 2.0;
        scale *= 0.5;
    }
    return value + 0.2;
}

vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
    vec2 st = texture_coords;
    st *= vec2(love_ScreenSize.x / love_ScreenSize.y, 1.0); // Adjust for aspect ratio
    vec2 pos = vec2(st * ZOOM);
    vec2 motion = vec2(fractal_brownian_motion(pos + vec2(iTime * -0.5, iTime * -0.3)));
    float final = fractal_brownian_motion(pos + motion) * INTENSITY;
    return vec4(mix(BG, COLOR, final), Texel(tex, texture_coords).a);
}