shader_type canvas_item;

uniform vec4 colour: source_color = vec4(1.0);
uniform float threshhold = .08;

void fragment() {
	vec4 base_color = texture(TEXTURE, UV);
	float v = base_color.r * base_color.a;
	float t = abs(cos(TIME * 1.5));
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
