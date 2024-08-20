shader_type canvas_item;
render_mode unshaded;

uniform float cutoff : hint_range(0.0, 1.0);
uniform sampler2D mask : hint_default_transparent;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	float value = texture(mask, UV).r;
	float alpha = step(cutoff, value);
	if (value < cutoff) {
		COLOR = vec4(COLOR.rgb, 0.0);
	} else {
		COLOR = vec4(COLOR.rgb, 1.0);
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
