shader_type canvas_item;

uniform vec4 color : source_color;

uniform sampler2D fast_noise: repeat_enable;
uniform sampler2D screen_content: hint_screen_texture;

uniform vec2 speed = vec2(0.03,0.07);

uniform float wave_strenth = 2;

uniform float transparency = 1;

void fragment() {
	// Called for every pixel the material is visible on.
	vec2 uv = UV + speed * TIME;
	vec2 noise = texture(fast_noise, uv).rg;

	COLOR = vec4(color.r,color.g,color.b, transparency) + vec4(noise.x,noise.y,1,0);
	COLOR *= texture(screen_content, SCREEN_UV + noise * (wave_strenth / 100.0));
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}