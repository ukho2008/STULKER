shader_type spatial;
render_mode cull_disabled, blend_mix, depth_draw_alpha_prepass;

uniform float force;
uniform float radius;
uniform vec3 player_pos;
uniform vec4 ColorUniform : hint_color;
uniform sampler2D tex_frg_2;



void vertex() {
// Input:11
	vec3 n_out11p0 = VERTEX;

// ScalarUniform:21
	float n_out21p0 = force;

// ScalarUniform:20
	float n_out20p0 = radius;

// Input:6
	mat4 n_out6p0 = WORLD_MATRIX;

// Input:3
	vec3 n_out3p0 = VERTEX;

// TransformVectorMult:5
	vec3 n_out5p0 = (n_out6p0 * vec4(n_out3p0, 1.0)).xyz;

// VectorUniform:2
	vec3 n_out2p0 = player_pos;

// VectorOp:4
	vec3 n_out4p0 = n_out5p0 - n_out2p0;

// VectorLen:17
	float n_out17p0 = length(n_out4p0);

// ScalarSmoothStep:18
	float n_in18p1 = 0.00000;
	float n_out18p0 = smoothstep(n_out20p0, n_in18p1, n_out17p0);

// Input:10
	mat4 n_out10p0 = WORLD_MATRIX;

// VectorOp:7
	vec3 n_in7p1 = vec3(1.00000, 0.00000, 1.00000);
	vec3 n_out7p0 = n_out4p0 * n_in7p1;

// VectorFunc:8
	vec3 n_out8p0 = normalize(n_out7p0);

// TransformVectorMult:9
	vec3 n_out9p0 = (vec4(n_out8p0, 1.0) * n_out10p0).xyz;

// Input:13
	vec3 n_out13p0 = vec3(UV, 0.0);

// VectorDecompose:14
	float n_out14p0 = n_out13p0.x;
	float n_out14p1 = n_out13p0.y;
	float n_out14p2 = n_out13p0.z;

// ScalarFunc:16
	float n_out16p0 = 1.0 - n_out14p1;

// VectorOp:15
	vec3 n_out15p0 = n_out9p0 * vec3(n_out16p0);

// VectorOp:19
	vec3 n_out19p0 = vec3(n_out18p0) * n_out15p0;

// VectorOp:22
	vec3 n_out22p0 = vec3(n_out21p0) * n_out19p0;

// VectorOp:12
	vec3 n_out12p0 = n_out11p0 + n_out22p0;

// Output:0
	VERTEX = n_out12p0;

}

void fragment() {
	vec3 n_out3p0 = vec3(UV, 0.0);
	vec3 n_out4p0 = -(n_out3p0);
// ColorUniform:2
	vec4 tex_frg_2_read = texture(tex_frg_2, n_out4p0.xy);
	vec3 n_out2p0 = tex_frg_2_read.rgb;
	float n_out2p1 = tex_frg_2_read.a;

// Output:0
	ALBEDO = n_out2p0;
	ALPHA = n_out2p1;


}
