varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D palette_orig; // spr_palette_index
uniform sampler2D palette_swap; // spr_palette_index_red
uniform float color_count;      // how many colors in the palette

void main() {
    vec4 base_color = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // If the pixel is transparent, skip processing
    if (base_color.a < 0.1) {
        gl_FragColor = base_color * v_vColour;
        return;
    }

    // Step through each color in the palette
    for (float i = 0.0; i < color_count; i += 1.0) {
        float u = (i + 0.5) / color_count; //no idea why this works...
		//float u = (i + 0.5) ;

        vec4 orig_col = texture2D(palette_orig, vec2(u, 0.5));
        vec4 swap_col = texture2D(palette_swap, vec2(u, 0.5));

        // Compare base color to original palette color
        if (distance(base_color.rgb, orig_col.rgb) < 0.02) {
            gl_FragColor = vec4(swap_col.rgb, base_color.a);
            //gl_FragColor = vec4(1,1,1, 1); //white
            return;
        }
    }

    // No match found → keep original
    gl_FragColor = base_color * v_vColour;
}
