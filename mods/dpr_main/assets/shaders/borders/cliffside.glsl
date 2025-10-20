uniform float iTime;
uniform vec2 iResolution;
uniform Image iChannel0;

float rand(float seed){
	return fract(sin(dot(vec2(seed) ,vec2(12.9898,78.233))) * 143758.5453);
}

vec2 displace(vec2 co, float seed, float seed2) {
	vec2 shift = vec2(0);
	if (rand(seed) > 0.5) {
		shift += 0.1 * vec2(2. * (0.5 - rand(seed2)));
	}
	if (rand(seed2) > 0.6) {
		if (co.y > 0.5) {
			shift.x *= rand(seed2 * seed);
		}
	}
	return shift * 0.05;
}

vec4 interlace(vec2 co, vec4 col) {
	// Replace modulus with fract and division
	if (fract((co.y * iResolution.y) / 3.0) < 1.0 / iResolution.y) {
		return col * ((sin(iTime * 4.) * 0.1) + 0.75) + (rand(iTime) * 0.05);
	}
	return col;
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
	vec2 uv = texture_coords;
	vec2 rDisplace = vec2(0);
	vec2 gDisplace = vec2(0);
	vec2 bDisplace = vec2(0);

	
	if (rand(iTime) > 0.9) {
		rDisplace = displace(uv, iTime * 2., 2. + iTime);
		gDisplace = displace(uv, iTime * 3., 3. + iTime);
		bDisplace = displace(uv, iTime * 5., 5. + iTime);
	}
	
	rDisplace.x += 0.005 * (0.5 - rand(iTime * 37. * uv.y));
	gDisplace.x += 0.007 * (0.5 - rand(iTime * 41. * uv.y));
	bDisplace.x += 0.0011 * (0.5 - rand(iTime * 53. * uv.y));

	rDisplace.y += 0.001 * (0.5 - rand(iTime * 37. * uv.x));
	gDisplace.y += 0.001 * (0.5 - rand(iTime * 41. * uv.x));
	bDisplace.y += 0.001 * (0.5 - rand(iTime * 53. * uv.x));
	
	float rcolor = Texel(texture, uv + rDisplace).r;
	float gcolor = Texel(texture, uv + gDisplace).g;
	float bcolor = Texel(texture, uv + bDisplace).b;

	vec4 fragColor = interlace(screen_coords, vec4(rcolor, gcolor, bcolor, 1.0));
	if (rand(floor(iTime*4.0)) > 0.1) {
		fragColor = Texel(texture, texture_coords);
	}
	return fragColor * color;
}
