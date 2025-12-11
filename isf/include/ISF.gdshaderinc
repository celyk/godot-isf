#ifndef ISF
#define ISF

// Godot screen origin is in the upper left. Set to 1 if we should use OpenGL style screen coordinates (bottom left origin)
#define GODOT_FLIP_Y 0

#include "ISF_Coordinates.gdshaderinc"

// Uniform just to get the size of the rectangle on screen
instance uniform vec4 rect_override = vec4(0,0,0,1);
instance uniform vec2 rendersize_override = vec2(0,0);

bool use_rect_override(){ return rect_override.zw != vec2(0,0); }
bool use_rendersize_override(){ return rendersize_override != vec2(0,0); }

#define GODOT_RESOLUTION vec2( use_rendersize_override() ? rendersize_override : 1.0 / SCREEN_PIXEL_SIZE )
//#define GODOT_RESOLUTION VIEWPORT_SIZE

#if GODOT_FLIP_Y == 1
vec2 __handle_y_flip(vec2 v){return vec2(v.x, 1.0-v.y);}
#else
vec2 __handle_y_flip(vec2 v){return v;}
#endif

#define GODOT_UV __handle_y_flip( vec2( use_rect_override() ? UV : SCREEN_UV ) )

#define GODOT_PIXEL_COORD vec4(GODOT_UV.x * GODOT_RESOLUTION.x, GODOT_UV.y * GODOT_RESOLUTION.x, FRAGCOORD.z, FRAGCOORD.w)

#define GODOT_TEXEL_COORD(A)
//#define GODOT_TEXTURE_SIZE(A)



#define RENDERSIZE GODOT_RESOLUTION
//varying vec2 RENDERSIZE;
//uniform vec2 RENDERSIZE;

//#define TIME TIME
#define isf_FragNormCoord __GODOT_TO_ISF_SCREEN_UV(GODOT_UV)
//#define PI

// Magic to redirect the function body to fragment()
//#define main __dummy(){} void fragment

// Handle weird main (void) edge case?
//#define main(a) _dummy(){} void fragment()


instance uniform int PASSINDEX = 0; //#define PASSINDEX int(0)
instance uniform int FRAMEINDEX = 0; //#define FRAMEINDEX int(0)
instance uniform vec4 DATE = vec4(0); //#define DATE vec4(0)
instance uniform float TIMEDELTA = 0.016666; //#define TIMEDELTA float(1.0 / 60.0)


// ISF 2.0 -> Godot shader renames
#define IMG_PIXEL(TEX,B) texture(TEX, __TEXEL_COORD_TO_UV(__ISF_TO_GODOT_TEXEL_COORD(B)) )
#define IMG_NORM_PIXEL(A,B) texture(A, __ISF_TO_GODOT_UV(B))

#define IMG_THIS_PIXEL(TEX) texture(TEX, GODOT_UV)
#define IMG_NORM_THIS_PIXEL(A) IMG_NORM_PIXEL(A, GODOT_UV)
#define IMG_THIS_NORM_PIXEL(A) IMG_NORM_PIXEL(A, GODOT_UV)

#define IMG_SIZE(A) vec2(textureSize(A,0))

// ISF 1.0 compatibility
#define vv_FragNormCoord isf_FragNormCoord
#define vv_vertShaderInit isf_vertShaderInit

// GLSL compatibility
#include "GLSL_to_GDSL.gdshaderinc"

#endif /*ISF*/
