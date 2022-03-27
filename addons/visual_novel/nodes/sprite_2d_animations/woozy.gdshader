shader_type canvas_item;

uniform sampler2D noise_texture : hint_white;
uniform float noise_scale = 16.0;

void fragment() {
	float noise = texture(noise_texture, fract(UV + vec2(TIME, -TIME) * .125)).r;
	noise = noise * 2.0 - 1.0;
	vec2 uv = UV + vec2(noise) * TEXTURE_PIXEL_SIZE * noise_scale;
	if (uv.x >= 0.0 && uv.y >= 0.0 && uv.x <= 1.0 && uv.y <= 1.0)
		COLOR = texture(TEXTURE, uv);
}
