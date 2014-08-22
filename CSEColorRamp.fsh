#ifdef GL_ES
precision mediump float;
#endif


void main()
{
    // 2
    vec2 onePixel = vec2(1.0 / 480.0, 1.0 / 320.0);
    
    // 3
    vec2 texCoord = cc_FragTexCoord2;
    
    // 4
    vec4 color;
    color.rgb = vec3(0.5);
    color -= texture2D(cc_MainTexture, texCoord - onePixel) * 5.0;
    color += texture2D(cc_MainTexture, texCoord + onePixel) * 5.0;
    // 5
    color.rgb = vec3((color.r + color.g + color.b) / 3.0);
    gl_FragColor = vec4(color.rgb, 1);
}