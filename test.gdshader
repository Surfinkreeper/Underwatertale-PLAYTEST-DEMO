shader_type spatial;

uniform sampler2D texture : source_color;

void vertex() {
	// Billboard effect
	VERTEX = (vec4(VERTEX,1.0)*MODELVIEW_MATRIX).xyz;
}

void fragment() {
	// Sampling texture inside shader
	ALBEDO = texture(texture, UV).rgb;
}