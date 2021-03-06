#version 100
#extension GL_EXT_draw_buffers: enable
precision highp float;

uniform sampler2D u_colmap;
uniform sampler2D u_normap;
uniform mat4 u_viewMatrix;
uniform mat4 u_viewProjMatrix;

varying vec3 v_position;
varying vec3 v_normal;
varying vec2 v_uv;

vec3 applyNormalMap(vec3 geomnor, vec3 normap) {
    normap = normap * 2.0 - 1.0;
    vec3 up = normalize(vec3(0.001, 1, 0.001));
    vec3 surftan = normalize(cross(geomnor, up));
    vec3 surfbinor = cross(geomnor, surftan);
    return normap.y * surftan + normap.x * surfbinor + normap.z * geomnor;
}

void main() {
    vec3 norm = applyNormalMap(v_normal, vec3(texture2D(u_normap, v_uv)));
    vec3 col = vec3(texture2D(u_colmap, v_uv));

    gl_FragData[0] = vec4(col, 1.0);
    gl_FragData[1] = vec4(v_position, 1.0);
    gl_FragData[2] = vec4(norm, 1.0);
    gl_FragData[3] = vec4(1.0);


/*
    // optimization
    vec4 pos = u_viewMatrix * vec4(v_position, 1.0);
    vec4 posNDC = u_viewProjMatrix * vec4(v_position, 1.0);
    posNDC /= posNDC.w;
    gl_FragData[0] = vec4(col, posNDC.z);
    gl_FragData[1] = vec4(norm, pos.z);
    */

}