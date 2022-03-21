shader_type canvas_item;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	COLOR = textureLod(SCREEN_TEXTURE, SCREEN_UV, 4.0 * UV.y) * tex * COLOR;
	COLOR.rgb *= pow(1.0 - UV.y, 0.125);
}
