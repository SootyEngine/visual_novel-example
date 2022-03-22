shader_type canvas_item;

uniform float saturation : hint_range(0.0, 1.0) = 1.0;

void fragment() {
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
	float lum = dot(screen.rgb, vec3(0.299, 0.587, 0.114));
	COLOR.rgb = mix(vec3(lum), screen.rgb, saturation);
}