shader_type spatial;
render_mode unshaded, cull_back, depth_draw_always;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;
uniform float outline_width = 2.0;

void vertex() {
    // Expand vertices outward to create an outline effect
    VERTEX += NORMAL * outline_width * 0.1; // Scaled to avoid excessive expansion
}

void fragment() {
    vec4 pixel_color = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec2 pixel_size = 1.0 / VIEWPORT_SIZE;

    // Sample the depth of the current fragment
    float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;

    bool is_edge = false;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            vec2 offset = vec2(float(x), float(y)) * pixel_size * outline_width;
            float sample_depth = texture(DEPTH_TEXTURE, SCREEN_UV + offset).r;

            // Detect edges by depth discontinuity
            if (abs(depth - sample_depth) > 0.0001) { // Adjust threshold if needed
                is_edge = true;
            }
        }
    }

    if (is_edge) {
        ALBEDO = vec3(0.0, 0.0, 0.0); // Outline color (black)
        ALPHA = 1.0;  // Fully visible outline
    } else {
        ALPHA = 0.0;  // Fully transparent interior
    }
}
