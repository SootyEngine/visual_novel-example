shader_type canvas_item;
render_mode blend_premul_alpha;

uniform float size : hint_range(0.0, 3.0) = 1.0;
uniform float amount : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	vec4 bloom = max(textureLod(SCREEN_TEXTURE, SCREEN_UV, size) - mix(1.0, -1.0, amount), vec4(0.0));
	vec4 screen = texture(SCREEN_TEXTURE, SCREEN_UV);
	COLOR.rgb = screen.rgb + bloom.rgb;
}
