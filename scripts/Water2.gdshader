shader_type spatial;
render_mode blend_mix, specular_phong, cull_back;

uniform sampler2D water_tex;
uniform vec4 light : hint_color = vec4(0.0, 0.2, 1.0, 1.0);
uniform vec4 dark : hint_color = vec4(0.0, 0.2, 1.0, 1.0);
uniform float amount : hint_range(0.01, 1.5) = 0.8;
uniform float speed : hint_range(0.1, 10.0) = 1.0;
uniform float beer_factor = 0.2;
uniform float displ_amount = 0.02;
uniform float UV_scale_x : hint_range(1f, 100f) = 1;
uniform float UV_scale_y : hint_range(1f, 100f) = 1;
uniform float water_speed : hint_range(1f, 100f) = 1;


float generateOffset(float x, float z, float val1, float val2, float time){
	
	float radiansX = ((mod(x + z * x * val1, amount) / amount) + (time * speed) * mod(x * 0.8 + z, 1.5)) * 2.0 * 3.14;
	float radiansZ = ((mod(val2 * (z * x + x * z), amount) / amount) + (time * speed) * 2.0 * mod(x, 2.0)) * 2.0 * 3.14;
	
	return amount * 0.5 * (sin(radiansZ) + cos(radiansX));
}


vec3 applyDistortion(vec3 vertex, float time){
	float xd = generateOffset(vertex.x, vertex.z, 0.2, 0.1, time);
	float yd = generateOffset(vertex.x, vertex.z, 0.2, 0.1, time);
	float zd = generateOffset(vertex.x, vertex.z, 0.2, 0.1, time);
	return vertex + vec3(xd, yd, zd);
}

void vertex(){
	VERTEX = applyDistortion(VERTEX, TIME * 0.1);
}

void fragment(){
	NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));
	METALLIC = 0.6;
	SPECULAR = 0.5;
	ROUGHNESS = 0.0;
	
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
	
	vec2 displ = texture(water_tex, UV - TIME/water_speed).xy;
	displ = (displ*2f - 1f) * displ_amount;
	
	float noise = texture(water_tex, vec2((UV.x*UV_scale_x), (UV.y*UV_scale_y) - TIME/water_speed) + displ).x;
	noise = floor(noise * 4f) / 4f;
	
	vec4 col = mix(light, dark, noise);
	
	ALBEDO = col.rgb;
	
	depth = depth * 2.0 - 1.0;
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]);
	depth = depth + VERTEX.z;
	
	depth = exp(-depth * beer_factor);
	ALPHA = clamp(1.0 - depth, 0.0, 1.0);
}