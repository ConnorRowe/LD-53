shader_type canvas_item;

uniform float progress: hint_range(0.0, 1.0, 0.01) = 0;
const vec3 fill_colour = vec3(0.058823, 0.05098, 0.066667);

void fragment() {
	float base = texture(TEXTURE, UV).r;
	if (progress >= base)
	{
		COLOR = vec4(fill_colour, 1.0);
	}
	else
	{
		discard;
	}
}
