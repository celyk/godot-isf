#ifndef GLSL_TO_GDSL
#define GLSL_TO_GDSL

// A GLSL compatability layer for Godot Shaders


#define __VERSION__ 100
#define gl_FragCoord FRAGCOORD
#define gl_FragColor COLOR
#define gl_Position POSITION
#define gl_FragDepth DEPTH
#define gl_FrontFacing FRONT_FACING
#define gl_InstanceID INSTANCE_ID
#define gl_VertexID VERTEX_ID
#define gl_PointSize POINT_SIZE
#define gl_PointCoord POINT_COORD

// Attempt to remove void from main(void) {
//#define void) )

// Magic to redirect the function body to fragment()
#define main __dummy(){} void fragment

#endif /*GLSL_TO_GDSL*/