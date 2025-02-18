shader_type spatial;
render_mode unshaded, cull_back, depth_draw_always;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform sampler2D DEPTH_TEXTURE;
uniform vec4 outline_color : source_color;
uniform float outline_width = 2.0;

void vertex() {
    // Expand vertices outward to create an outer outline effect
    VERTEX += NORMAL * outline_width;
}

void fragment() {
    vec4 pixelatedtext = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
    
    ALBEDO = pixelatedtext.rgb; // Preserve original appearance
    
    // Perform edge detection using screen texture
    for(int y = -1 * int(outline_width); y <= int(outline_width); y++) {
        for(int x = -1 * int(outline_width); x <= int(outline_width); x++) {
            vec4 tex = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(float(x), float(y)) * pixel_size);
            
            // Detect the transition between the object and the background (edge detection)
            if(abs(tex.a - 0.0) < 0.0001 &&
               SCREEN_UV.x + float(x) * pixel_size.x < 1.0 &&
               SCREEN_UV.x + float(x) * pixel_size.x > 0.0 &&
               SCREEN_UV.y + float(y) * pixel_size.y < 1.0 &&
               SCREEN_UV.y + float(y) * pixel_size.y > 0.0) {
                
                ALBEDO = outline_color.rgb; // Apply outline color
                ALPHA = 1.0; // Ensure full visibility
            }
        }
    }
}
