shader_type spatial;

uniform sampler2D number_texture; // The number spritesheet
uniform int digit = 0; // Current digit (0-9)
const int NUM_DIGITS = 10; // Total digits in the texture

void fragment() {
    vec2 uv = UV;
    uv.x = (uv.x / float(NUM_DIGITS)) + (float(digit) / float(NUM_DIGITS)); 
    vec4 tex_color = texture(number_texture, uv);
    ALBEDO = tex_color.rgb;
}
