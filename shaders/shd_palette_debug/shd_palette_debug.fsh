varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D palette_orig;
uniform sampler2D palette_swap;
uniform float color_count;

void main() {
    vec2 uv = v_vTexcoord;
    vec4 base_color = texture2D(gm_BaseTexture, uv);

    // choose a single palette entry to sample based on the fragment uv.x (or a constant)
    // we will sample the palette entry that corresponds to the base_color by brute force:
    float chosen = 0.0;
    float bestDist = 999.0;
    for (float i = 0.0; i < color_count; i += 1.0) {
        float u = (i + 0.5) / color_count;
        vec4 orig_col = texture2D(palette_orig, vec2(u, 0.5));
        float d = distance(base_color.rgb, orig_col.rgb);
        if (d < bestDist) { bestDist = d; chosen = i; }
    }

    float u_chosen = (chosen + 0.5) / color_count;
    vec4 sampled_orig = texture2D(palette_orig, vec2(u_chosen, 0.5));
    vec4 sampled_swap = texture2D(palette_swap, vec2(u_chosen, 0.5));

    // Render layout:
    // left third: base_color, middle third: sampled_orig, right third: sampled_swap
    if (uv.x < 0.3333) {
        gl_FragColor = base_color;
    } else if (uv.x < 0.6666) {
        gl_FragColor = sampled_orig;
    } else {
        gl_FragColor = sampled_swap;
    }
}
