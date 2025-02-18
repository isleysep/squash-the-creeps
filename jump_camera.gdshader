shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform int pixel_size : hint_range(1, 64) = 4; // Pixel size
uniform vec2 screen_size = vec2(1920.0, 1080.0); // Screen size (set manually)
uniform float squishedness = 0;

void fragment() {
    //Pixel coordinates in screen space
    vec2 pixel_coords = floor(FRAGCOORD.xy / float(pixel_size)) * float(pixel_size);
    // Convert pixel coordinates to UVs for screen texture
    vec2 uv = pixel_coords / screen_size;
    // Get color from texture screen
    COLOR = mix(
		vec4(vec3(0.0), 1.0),
		texture(SCREEN_TEXTURE, uv),
		step(squishedness * 0.5, uv.y) - step(1.0 - squishedness * 0.5, uv.y)
	);
}
