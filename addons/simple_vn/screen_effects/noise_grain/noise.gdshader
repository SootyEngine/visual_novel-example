shader_type canvas_item;
render_mode blend_mix;

uniform float size = 512.0;
uniform float lum_scale = 0.75;

void fragment() {
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
	float lum = dot(vec3(0.30, 0.59, 0.11), screen.rgb);
	vec2 uv = SCREEN_UV;
	uv.y *= (SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y );
	uv = round(uv * size) / size;
    float ta = TIME * 0.654321;
    float tb = TIME * (ta * 0.123456);
	float n = fract(sin(uv.x * ta + uv.y * tb) * 5678.0);
	COLOR.rgb = vec3(pow(lum, n * lum_scale)) * screen.rgb;
}
