shader_type canvas_item;

uniform vec4 colour_a: source_color = vec4(1.0);
uniform vec4 colour_b: source_color = vec4(1.0);
uniform float threshhold = .08;
uniform float progress: hint_range(0.0, 1.0, 0.01) = 0.5;

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
	vec4 colour = colour_a;
	if (progress > 0.5)
	{
		colour = colour_b;
	}
	float v = base_color.r * base_color.a;
	float t = max(progress, 0.33);
	if (v > t - threshhold && v < t + threshhold)
	{
		COLOR.rgb = colour.rgb;
		COLOR.a = base_color.a;
	}
	else
	{
		discard;
	}
		
}
