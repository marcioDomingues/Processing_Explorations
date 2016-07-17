#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif
 
#define PROCESSING_TEXTURE_SHADER
 
uniform sampler2D texture;
uniform vec2 texOffset;
 
uniform vec2 screen;
uniform vec2 mouse;
uniform float delta;
uniform float feed;
uniform float kill;
 
uniform float dA;
uniform float dB;

varying vec4 vertColor;
varying vec4 vertTexCoord;
 
void main() {
     //old
    /*
    vec2 uv = texture2D(texture, vertTexCoord.st).rg;
    vec2 uv0 = texture2D(texture, vertTexCoord.st + vec2(-texOffset.s, 0.0)).rg;
    vec2 uv1 = texture2D(texture, vertTexCoord.st + vec2(+texOffset.s, 0.0)).rg;
    vec2 uv2 = texture2D(texture, vertTexCoord.st + vec2(0.0, -texOffset.t)).rg;
    vec2 uv3 = texture2D(texture, vertTexCoord.st + vec2(0.0, +texOffset.t)).rg;
    vec2 lapl = uv0 + uv1 + uv2 + uv3 - 4.0 * uv;
    */

    
    vec2 uv = texture2D(texture, vertTexCoord.st).rg;
    //cross *.2
    vec2 uv0 = texture2D(texture, vertTexCoord.st + vec2(-texOffset.s, 0.0)).rg;
    vec2 uv1 = texture2D(texture, vertTexCoord.st + vec2(+texOffset.s, 0.0)).rg;
    vec2 uv2 = texture2D(texture, vertTexCoord.st + vec2(0.0, -texOffset.t)).rg;
    vec2 uv3 = texture2D(texture, vertTexCoord.st + vec2(0.0, +texOffset.t)).rg;
    //diagonal *.5
    vec2 uv4 = texture2D(texture, vertTexCoord.st + vec2(-texOffset.s, -texOffset.t)).rg;
    vec2 uv5 = texture2D(texture, vertTexCoord.st + vec2(+texOffset.s, -texOffset.t)).rg;
    vec2 uv6 = texture2D(texture, vertTexCoord.st + vec2(+texOffset.s, +texOffset.t)).rg;
    vec2 uv7 = texture2D(texture, vertTexCoord.st + vec2(-texOffset.s, +texOffset.t)).rg;



    //remake laplacian it only makes the cross
    //Some typical values used, for those interested, are: 
    //DA=1.0, DB=.5, f=.055, k=.062 (f and k vary for different behaviors), 
    //and Δt=1.0. The Laplacian is performed with a 
    //3x3 convolution with center weight -1, adjacent neighbors .2, 
    //and diagonals .05. The grid is initialized with A=1, B=0, and a 
    //small area is seeded with B=1.
    vec2 lapl = (uv0*.2)+(uv1*.2)+(uv2*.2)+(uv3*.2)+(uv4*.05)+(uv5*.05)+(uv6*.05)+(uv7*.05)+(uv*-1);

    //float du = 1 * lapl.r - (uv.r * uv.g * uv.g) + feed * (1.0 - uv.r);
    //float dv = 0.5 * lapl.g + (uv.r * uv.g * uv.g) - (feed+kill) * uv.g;

    float du = dA * lapl.r - uv.r * uv.g * uv.g + feed * (1.0 - uv.r);
    float dv = dB * lapl.g + uv.r * uv.g * uv.g - (feed+kill) * uv.g;
    vec2 dst = uv + delta * vec2(du, dv);
 
    vec2 diff = vertTexCoord.st * screen - mouse;
    float dist = dot(diff, diff);
    if(dist < 500.0) {
        dst.g = 0.9;
    }
 
    gl_FragColor = vec4(dst.r, dst.g, 0.0, 1.0);
}