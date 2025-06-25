uniform float squishiness;
uniform float squish_softening;
uniform float center_y;

float outCirc(float time, float start, float change, float duration)
{
    time = time / duration - 1;
    return change * sqrt(1 - pow(time, 2)) + start;
}

float outSine(float time, float start, float change, float duration)
{
    return change * sin(time / duration * (3.14 / 2)) + start;
}

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec2 warped_coords = texture_coords;

    float center_dist_x = abs( 0.5 - texture_coords.x );
    float center_disp_y = center_y - texture_coords.y;

    float squishy_percentage = min((1 + squish_softening) - (center_dist_x * 2), 1);
    float total_in_squish = 0.1 * squishiness;

    float dist_y_squish_factor = abs( center_disp_y ) * 2;

    float current_in_squish = outCirc( squishy_percentage, 0, total_in_squish * sign( center_disp_y ) * outSine( dist_y_squish_factor, 0, 1, 1 ), 1 );

    warped_coords.y = warped_coords.y - current_in_squish;

    while (warped_coords.y > 1) {
        warped_coords.y -= 1;
    }

    while (warped_coords.y < 0) {
        warped_coords.y += 1;
    }

    vec4 texturecolor = Texel(texture, warped_coords);
    return texturecolor * color;
}
