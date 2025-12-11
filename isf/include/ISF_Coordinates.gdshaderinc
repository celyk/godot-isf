#ifndef ISF_COORDS
#define ISF_COORDS

// Macros for converting coordinates expected by ISF 


vec2 __y_flip_norm(vec2 v){return vec2(v.x, 1.0 - v.y);}
ivec2 __y_flip_unnorm(ivec2 v, ivec2 size){return ivec2(v.x, size.y - v.y);}

#define __VIEWPORT_SIZE vec2(1.0 / SCREEN_PIXEL_SIZE)
#define __GET_TEXTURE_SIZE(TEX) textureSize(TEX,0)

// A is a vec2
#define __GODOT_TO_ISF_SCREEN_UV(A) __y_flip_norm(A)
#define __ISF_TO_GODOT_SCREEN_UV(A) __y_flip_norm(A)

#define __GODOT_TO_ISF_UV(A) __y_flip_norm(A)
#define __ISF_TO_GODOT_UV(A) __y_flip_norm(A)

// A is an ivec2
#define __GODOT_TO_ISF_PIXEL_COORD(A) __y_flip_unnorm(A, ivec2(__VIEWPORT_SIZE+0.5))
#define __ISF_TO_GODOT_PIXEL_COORD(A) __y_flip_unnorm(A, ivec2(__VIEWPORT_SIZE+0.5))

#define __GODOT_TO_ISF_TEXEL_COORD(TEX, A) __y_flip_unnorm(A, __GET_TEXTURE_SIZE(TEX))
#define __ISF_TO_GODOT_TEXEL_COORD(TEX, A) __y_flip_unnorm(A, __GET_TEXTURE_SIZE(TEX))

// A is an ivec2
#define __PIXEL_COORD_TO_SCREEN_UV(A) vec2( (vec2(A) + 0.5) / vec2(__VIEWPORT_SIZE) )
#define __TEXEL_COORD_TO_UV(TEX, A) vec2( (vec2(A) + 0.5) / vec2(__GET_TEXTURE_SIZE(TEX)) )

// A is an vec2
#define __SCREEN_UV_TO_PIXEL_COORD(A) ivec2( A * vec2(__VIEWPORT_SIZE) )
#define __UV_TO_TEXEL_COORD(TEX, A) ivec2( A * vec2(__GET_TEXTURE_SIZE(TEX)) )

#endif /*ISF_COORDS*/