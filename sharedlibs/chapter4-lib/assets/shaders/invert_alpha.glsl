vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {
    vec4 col = texture2D(texture, texture_coords);
    return vec4(col.r,col.g,col.b,1.0-col.a);
}
