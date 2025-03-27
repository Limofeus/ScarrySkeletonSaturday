shader_type spatial;
render_mode blend_mix, shadows_disabled, cull_disabled;

uniform sampler2D hit_texture;
uniform vec3 main_color : source_color = vec3(0.0);
uniform float projectile_lifetime = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = main_color;
	float hit_alpha = texture(hit_texture, UV).a;
	ALPHA = hit_alpha * projectile_lifetime;
}