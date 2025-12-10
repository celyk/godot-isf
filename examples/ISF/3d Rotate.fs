/*
{
	"CATEGORIES": [
		"Geometry Adjustment",
		"Utility"
	],
	"CREDIT": "by zoidberg",
	"DESCRIPTION": "performs a 3d rotation",
	"INPUTS": [
		{
			"NAME": "inputImage",
			"TYPE": "image"
		},
		{
			"DEFAULT": 1.0,
			"LABEL": "X rotate",
			"MAX": 2.0,
			"MIN": 0.0,
			"NAME": "xrot",
			"TYPE": "float"
		},
		{
			"DEFAULT": 1.0,
			"LABEL": "Y rotate",
			"MAX": 2.0,
			"MIN": 0.0,
			"NAME": "yrot",
			"TYPE": "float"
		},
		{
			"DEFAULT": 1.0,
			"LABEL": "Z rotate",
			"MAX": 2.0,
			"MIN": 0.0,
			"NAME": "zrot",
			"TYPE": "float"
		},
		{
			"DEFAULT": 1.0,
			"LABEL": "Zoom Level",
			"MAX": 1.0,
			"MIN": 0.0,
			"NAME": "zoom",
			"TYPE": "float"
		}
	],
	"ISFVSN": "2"
}
*/

shader_type canvas_item;

#include "res://.godot/imported/ISF/2422514035/generated_inputs.gdshaderinc"






void main()
{
	gl_FragColor = IMG_THIS_PIXEL(inputImage);
}
