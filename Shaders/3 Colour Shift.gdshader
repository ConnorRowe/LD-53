shader_type canvas_item;

uniform vec4 colour_a: source_color;
uniform vec4 colour_b: source_color;
uniform vec4 colour_c: source_color;

void fragment() {
	float c = sin(TIME) * 3.0;
	float b = clamp(c - 2.0, 0.0, 1.0);
	float a = clamp(c - 1.0, 0.0, 1.0);
	
	vec3 mix_a = mix(colour_a.rgb, colour_b.rgb, a);
	vec3 mix_b = mix(mix_a.rgb, colour_c.rgb, b);
	
	COLOR.rgb = mix_b;
}
