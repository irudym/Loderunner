
//uniform sampler2D u_NoiseTexture;
uniform sampler2D u_lightTexture;

void main() {
    
    vec4 ambientColor = vec4(0.3,0.3,0.4,0.7);
    
    vec4 diffuseColor = texture2D(cc_MainTexture, cc_FragTexCoord1);
    vec3 ambient = ambientColor.rgb * ambientColor.a;
    
    vec3 final = cc_FragColor.rgb * diffuseColor.rgb * ambient;
    //gl_FragColor = vec4(final, diffuseColor.a);
    //gl_FragColor = vec4(0,0,0,1);
    //gl_FragColor = texture2D(u_lightTexture, gl_FragCoord.xy);
    
    vec3 bleach = vec3(0.5,0.5,0.5);
    
    vec2 resolution = vec2(1136,640);
    vec2 lighCoord = (gl_FragCoord.xy / resolution.xy);
    vec4 light = texture2D(u_lightTexture, lighCoord);
    vec3 intensity = ambient + light.rgb;
    vec3 finalColor = diffuseColor.rgb * intensity;
    //if(light.r == 1.0) finalColor = diffuseColor.rgb + bleach;
    
    gl_FragColor = cc_FragColor * vec4(finalColor, diffuseColor.a);
}