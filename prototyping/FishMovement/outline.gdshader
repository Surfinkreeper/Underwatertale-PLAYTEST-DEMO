shader_type spatial;
render_mode cull_front, unshaded;

uniform vec4 outline_color : source_color;
uniform float outline_width = 1.0;

uniform float time_scale = 2.0f;
uniform float side_to_side = 0.1f;
uniform float pivot = 0.5f;
uniform float wave = 0.1f;
uniform float twist = 0.1f;

void vertex() {
	//time_scale is a uniform float
	float time = TIME * time_scale;

	VERTEX.x += cos(time) * side_to_side;

	//angle is scaled by 0.1 so that the fish only pivots and doesn't rotate all the way around
	//pivot is a uniform float
	float pivot_angle = cos(time) * 0.1 * pivot;
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));

	VERTEX.xz = rotation_matrix * VERTEX.xz;

	float body = (VERTEX.z + 1.0) / 2.0; //for a fish centered at (0, 0) with a length of 2

	//wave is a uniform float
	VERTEX.x += cos(time + body) * wave;

	//twist is a uniform float
	float twist_angle = cos(time + body) * 0.3 * twist;
	mat2 twist_matrix = mat2(vec2(cos(twist_angle), -sin(twist_angle)), vec2(sin(twist_angle), cos(twist_angle)));

	VERTEX.xy = twist_matrix * VERTEX.xy;

    vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0));
    vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);

    vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width * 2.0;

    clip_position.xy += offset;

    POSITION = clip_position;


}

void fragment() {
    ALBEDO = outline_color.rgb;
    if (outline_color.a < 1.0) {
        ALPHA = outline_color.a;
    }
}