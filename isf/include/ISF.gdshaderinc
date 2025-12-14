#ifndef ISF
#define ISF

// Godot screen origin is in the upper left. Set to 1 if we should use OpenGL style screen coordinates (bottom left origin)
#define GODOT_FLIP_Y 0


// Uniform just to get the size of the rectangle on screen
instance uniform vec4 rect_override = vec4(0,0,0,1);
instance uniform vec2 rendersize_override = vec2(0,0);

bool use_rect_override(){ return rect_override.zw != vec2(0,0); }
bool use_rendersize_override(){ return rendersize_override != vec2(0,0); }

#define GODOT_RESOLUTION vec2( use_rendersize_override() ? rendersize_override : 1.0 / SCREEN_PIXEL_SIZE )
//#define GODOT_RESOLUTION VIEWPORT_SIZE

#define GODOT_UV vec2( use_rect_override() ? UV : SCREEN_UV )

#define GODOT_PIXEL_COORD vec4(GODOT_UV.x * GODOT_RESOLUTION.x, GODOT_UV.y * GODOT_RESOLUTION.x, FRAGCOORD.z, FRAGCOORD.w)

#define GODOT_TEXEL_COORD(A)
//#define GODOT_TEXTURE_SIZE(A)


#include "ISF_Coordinates.gdshaderinc"

#undef __VIEWPORT_SIZE
#define __VIEWPORT_SIZE GODOT_RESOLUTION


#define RENDERSIZE GODOT_RESOLUTION

//varying vec2 RENDERSIZE;
//uniform vec2 RENDERSIZE;

//#define TIME TIME
#define isf_FragNormCoord __GODOT_TO_ISF_SCREEN_UV(GODOT_UV)
//#define PI


instance uniform int PASSINDEX = 0; //#define PASSINDEX int(0)
instance uniform int FRAMEINDEX = 0; //#define FRAMEINDEX int(0)
instance uniform vec4 DATE = vec4(0); //#define DATE vec4(0)
instance uniform float TIMEDELTA = 0.016666; //#define TIMEDELTA float(1.0 / 60.0)


// ISF 2.0 -> Godot shader renames
#define IMG_PIXEL(TEX,B) texture(TEX, __ISF_TO_GODOT_UV(__TEXEL_COORD_TO_UV(TEX,B)) )
#define IMG_NORM_PIXEL(A,B) texture(A, __ISF_TO_GODOT_UV(B))

#define IMG_THIS_PIXEL(TEX) texture(TEX, GODOT_UV)
#define IMG_NORM_THIS_PIXEL(TEX) texture(TEX, GODOT_UV)

#define IMG_SIZE(A) vec2(textureSize(A,0))

// ISF 1.0 compatibility
#define vv_FragNormCoord isf_FragNormCoord
#define vv_vertShaderInit isf_vertShaderInit
#define IMG_THIS_NORM_PIXEL IMG_NORM_THIS_PIXEL

// GLSL compatibility
#include "GLSL_to_GDSL.gdshaderinc"

#undef gl_FragCoord
#define gl_FragCoord vec4(__GODOT_TO_ISF_PIXEL_COORD(GODOT_PIXEL_COORD.xy), GODOT_PIXEL_COORD.z, GODOT_PIXEL_COORD.w)


#endif /*ISF*/
