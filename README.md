# Outline Shader

## HLSL Shader Creation in Unity URP
![Yellow, Green, Red, and Blue Sphere. The Green sphere is outlined.](./ReadMeImages/Outline_Shader_Thumbnail.png)

This project is a custom outline shader written in HLSL using Unity’s ShaderLab syntax for the Universal Render Pipeline (URP).
I created it as a focused learning exercise to gain hands-on experience with HLSL, shader fundamentals, and Unity’s Universal Render Pipeline.

## Editor Adjustable Attributes
![Material Attributes in Unity Editor.](./ReadMeImages/Editable_Attributes.png)

My outline shader has several adjustable attributes which can be changed in the material editor. This allows the user of the material to easily customize the shader’s behavior without modifying code.

- I enjoyed learning about toggles, which enables the user to toggle the outline on and off, and switch between a procedurally determined outline color or a manually selected one.

- For the procedurally determined border color, I used the dot() function to calculate the grayscale luminance value of the base color, and then used that luminance value to drive a lerp() blend for the outline color.

- Additionally, the user of the material can adjust the base color, select a texture, modify texture tiling, and control the width of the outline.

## In Progress and Future Directions
![Unity editor showing the shader in an earlier state, without toggles.](./ReadMeImages/In_Progress_Photo.png)

My goal for this project was to learn the fundamentals of HLSL and ShaderLab by throwing myself into the process and learning through iteration. I now feel I have a solid understanding of variable declaration, data types, structs, interpolators, and per-vertex versus per-fragment logic in HLSL.

I also learned several important conventions and optimizations, such as utilizing floats instead of booleans for toggles, and using the lerp() function with a 0/1 value instead of an if/else statement. I implemented this approach after learning that avoiding branching logic is generally more GPU-friendly. Using floats instead of booleans also allows these values to be directly composed into mathematical functions like lerp().

Additionally, I learned how human perceptual weighting of RGB channels applies to perceived luminance in the digital RGBA color spectrum, and how to account for this using weighted modifiers inside the dot() function. Experimenting with multiple implementations helped reinforce these conventions and gave me a more intuitive understanding of how shader math translates to visual results.

![Sphere Intersecting with Border.](./ReadMeImages/Outline_Collision_Bug.png)

One known issue is that intersecting geometry can become visible inside the outline, breaking the illusion of a solid border. With more time, I would address this using depth-based techniques or stencil buffer approaches to ensure the outline remains visually solid, even in close-up or narrative-driven scenes.
