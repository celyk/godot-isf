#ifndef ISF
#define ISF

// Uniform just to get the size of the rectangle on screen
instance uniform vec4 rect_override = vec4(0,0,0,1);
instance uniform vec2 rendersize_override = vec2(0,0);

bool use_rect_override(){ return rect_override.zw != vec2(0,0); }
bool use_rendersize_override(){ return rendersize_override != vec2(0,0); }

#define GODOT_RESOLUTION vec2( use_rendersize_override() ? rendersize_override : 1.0 / SCREEN_PIXEL_SIZE )
//#define GODOT_RESOLUTION VIEWPORT_SIZE

#define GODOT_UV vec2( use_rect_override() ? UV : SCREEN_UV )

#define GODOT_PIXEL_COORD vec4(GODOT_UV.x * GODOT_RESOLUTION.x, GODOT_UV.y * GODOT_RESOLUTION.x, FRAGCOORD.z, FRAGCOORD.w)

// Get the rect transform from UV space to model space
/*mat4 getRectTransform(){
	return mat4(1);
}
void vertex() {
	//VERTEX += 100.0;
}*/


// ISF 2.0 -> Godot shader renames
#define IMG_NORM_PIXEL(A,B) texture(A,B)
#define IMG_NORM_THIS_PIXEL(A) IMG_NORM_PIXEL(A, GODOT_UV)
#define IMG_THIS_NORM_PIXEL(A) IMG_NORM_PIXEL(A, GODOT_UV)
#define IMG_SIZE(A) vec2(textureSize(A,0))

#define RENDERSIZE GODOT_RESOLUTION
//varying vec2 RENDERSIZE;
//uniform vec2 RENDERSIZE;

//#define TIME TIME
#define isf_FragNormCoord vec2(GODOT_UV)
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
#define IMG_THIS_PIXEL(A) texture(A, GODOT_UV)


// ISF 1.0 compatibility
#define vv_FragNormCoord isf_FragNormCoord
#define vv_vertShaderInit isf_vertShaderInit

// GLSL compatibility
#define gl_FragCoord GODOT_PIXEL_COORD
#define gl_FragColor COLOR
#define __VERSION__ 100

#endif /*ISF*/
