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
#define IMG_NORM_THIS_PIXEL(A,B) IMG_PIXEL(A, SCREEN_UV)
#define IMG_SIZE(A) vec2(textureSize(A,0))
#define IMG_THIS

#define RENDERSIZE VIEWPORT_SIZE
#define TIME TIME
#define isf_FragNormCoord SCREEN_UV

#define main fragment

// Unsupported
// TODO: proper support
#define PASSINDEX 0
#define FRAMEINDEX (0)
#define DATE vec4(0)
#define TIMEDELTA (1.0 / 60.0)
#define IMG_PIXEL(A,B) texelFetch(A,B)
#define IMG_THIS_PIXEL(A) texture(A, SCREEN_UV)


// ISF 1.0 compatibility
#define vv_FragNormCoord isf_FragNormCoord
#define vv_vertShaderInit isf_vertShaderInit

// GLSL compatibility 
#define gl_FragCoord FRAGCOORD
#define gl_FragColor COLOR

#endif /*ISF*/