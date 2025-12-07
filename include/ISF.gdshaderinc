#ifndef ISF
#define ISF

// ISF -> Godot shader renames
#define IMG_NORM_PIXEL(A,B) texture(A,B)
#define IMG_PIXEL(A,B) texelFetch(A,B)
#define RENDERSIZE VIEWPORT_SIZE
#define TIME TIME
#define gl_FragCoord FRAGCOORD
#define isf_FragNormCoord SCREEN_UV

// TODO: proper support
#define PASSINDEX 0
#define FRAMEINDEX (0)
#define DATE vec4(0)
#define TIMEDELTA (1.0 / 60.0)

#endif /*ISF*/