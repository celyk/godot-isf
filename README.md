# Godot ISF [WIP]

The addon allows importing an ISF file (.fs) to a PackedScene that contains the buffers and shaders required to run the effect.

After I get most features working, I hope to add an export button so that Godot can be used for developing ISF!

# Usage

1. Clone this repo and move the directory under your projects /addons directory
2. Enable the addon in your project settings
3. Drag in your .fs files to the project directory. They will be automatically converted to a scene file

The generated ShaderMaterial should be directly accessable on the scene node. You can peak at the inner workings by right clicking on it and ticking Editable Children

# Features

- [] Basic ISF support
- [] Multi-passes
- [] Persistent buffers
- [] Audio reactivity (FFT)
- [] Import from standard ISF directory

# Limitations

I did my best to follow the ISF [specification](https://github.com/mrRay/ISF_Spec), but unfortunately not every GLSL feature can be accounted for in Godot shaders
- Function overloading. You will get an error if the ISF shader overloads a built in function. To fix it you will have to rename the function.
- Global variables aren't supported at all. Try adding `const` to them instead

If you come across a limitation not listed here, please report it by filing an issue on this repository

# Writing an ISF shader in Godot

TODO

# Support

You can support this addon by reporting bugs and donating via kofi

https://ko-fi.com/celyk

# Resources

https://github.com/mrRay/ISF_Spec

https://docs.isf.video/quickstart.html#using-isf-compositions

https://gist.github.com/dlublin/2df96d7e9f0a72dd9a1260d8309a722f

https://github.com/dreness/kodelife-generator/blob/main/src/klproj/isf_parser.py
