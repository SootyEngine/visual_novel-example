shader_type canvas_item;

uniform float blend : hint_range(0.0, 1.0) = 0.0; 

void fragment() {
	vec3 rgb = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	COLOR.rgb = mix(rgb, vec3(1.0) - rgb, blend);
}
