shader_type canvas_item;

uniform float rotate_degree : hint_range(0.0, 360.0, 0.1) = 0;
uniform float move_degree :  hint_range(0.0, 360.0, 0.1) = 0;
uniform float speed : hint_range(0.0, 100.0) = 1;
uniform float scale : hint_range(0.01, 100.0, 0.01) = 0.2;
uniform vec2 gap = vec2(0.5, 0.5);
uniform vec2 node_scale = vec2(1.0);

vec2 rotate(vec2 uv, float local_angle) {
	mat2 rotation = mat2(vec2(sin(local_angle), -cos(local_angle)),
			vec2(cos(local_angle), sin(local_angle)));

    uv = uv * rotation;
    return uv;
}

void fragment() {
	vec2 scaled_uv = UV*node_scale / scale;
	float rotate_radians = radians(rotate_degree+90.0);
	float move_radians = radians(move_degree+180.0)-rotate_radians;
	vec2 normilazed_vector = vec2(cos(move_radians), sin(move_radians));
	vec2 rotated_uv = rotate(scaled_uv, rotate_radians);
	vec2 scrolled_uv = rotated_uv + normilazed_vector * speed * TIME;

	vec2 period = 1.0 + max(gap, vec2(0,0));
	vec2 cell_idx = floor(scrolled_uv / period);
	vec2 pos = scrolled_uv - cell_idx * period;

	float alpha = step(max(pos.x, pos.y), 1.0);
	vec4 tex = texture(TEXTURE, pos);

	COLOR = vec4(vec3(tex.rgb), alpha);
}