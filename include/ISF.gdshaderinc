#ifndef ISF
#define ISF

/*
vec4 pixelColor = IMG_PIXEL(image imageName, vec2 pixelCoord);
vec4 pixelColor = IMG_NORM_PIXEL(image imageName, vec2 normalizedPixelCoord);
vec4 pixelColor = IMG_THIS_PIXEL(image imageName);
vec4 pixelColor = IMG_NORM_THIS_PIXEL(image imageName);
vec2 imageSize = IMG_SIZE(image imageName);
*/

// ISF 2.0 -> Godot shader renames
#define IMG_NORM_PIXEL(A,B) texture(A,B)
#define IMG_NORM_THIS_PIXEL(A) IMG_NORM_PIXEL(A, SCREEN_UV)
#define IMG_THIS_NORM_PIXEL(A) IMG_NORM_PIXEL(A, SCREEN_UV)
#define IMG_SIZE(A) vec2(textureSize(A,0))

//#define RENDERSIZE VIEWPORT_SIZE
#define RENDERSIZE vec2(1.0 / SCREEN_PIXEL_SIZE)
//varying vec2 RENDERSIZE;
//uniform vec2 RENDERSIZE;

//#define TIME TIME
#define isf_FragNormCoord vec2(SCREEN_UV)
//#define PI

// Magic to redirect the function body to fragment()
#define main __dummy(){} void fragment

// Handle weird main (void) edge case?
//#define main(a) _dummy(){} void fragment()

instance uniform int PASSINDEX = 0; //#define PASSINDEX int(0)
instance uniform int FRAMEINDEX = 0; //#define FRAMEINDEX int(0)
instance uniform vec4 DATE = vec4(0); //#define DATE vec4(0)
instance uniform float TIMEDELTA = 0.016666; //#define TIMEDELTA float(1.0 / 60.0)

// Unsupported
// TODO: proper support
#define IMG_PIXEL(A,B) texelFetch(A, ivec2(B+0.5), 0)
#define IMG_THIS_PIXEL(A) texture(A, SCREEN_UV)


// ISF 1.0 compatibility
#define vv_FragNormCoord isf_FragNormCoord
#define vv_vertShaderInit isf_vertShaderInit

// GLSL compatibility
#define gl_FragCoord vec4(FRAGCOORD)
#define gl_FragColor COLOR
#define __VERSION__ 100

#endif /*ISF*/