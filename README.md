# Real-time Terrain Grass Shader
![Image](https://i.imgur.com/a77OdRi.png)

This package includes a Unity terrain shader that generates grass on different textures in Real-time. (Tested with 5.6)
It was created in the course of a Bachelor's thesis at the [HCI research group](https://www.inf.uni-hamburg.de/en/inst/ab/hci/research.html) at the [Hamburg University](https://www.uni-hamburg.de/).

## Main Feature

Grass is generated on the GPU in real-time and distributed depending on the ID of the ground textures. Painting terrain textures immediately updates the grass for direct visual feedback. The shader utilizes the "Deferred Rendering" path support cheap lighting and shadows. It also supports up to 10 sperical colliders (e.g. for the player character to bend the grass where he walks).



### Installation

Import the .unitypackage into your project. Either open one of the two demo scenes or follow the instructions.

##### Instructions on how to use the terrain grass shader:

------------------------

**Setup:**
1. Make sure rendering path is set to Deferred and color space is linear.
2. Create a terrain object and add at least one texture.
3. Go the terrain settings -> Choose the "Custom" option under "Material" and add the "Grass Shader Deferred" Material in the "Custom Material" slot.

------------------------

**Configuration:**
To configure the shader, select the "Grass Shader Deferred" material found in "Terrain Shader/Shader".
The four foldout menus "Options for Terrain texture #" are used to configure the grass for the first four terrain textures of the terrain object.
Select the texture of the grass you want to draw.
Configure the height, width and the dry/healthy colors to your content.
Finally the "Enabled" checkbox activates this grass.
The grass is now rendered on the terrain depending on the strength of the corresponding terrain texture.

- **Noise Texture:** Specify a noise texture for varying height and color.
- **Smoothness:** Increase reflectivity of the grass (0 is recommended).
- **UpDown:** Move grass into the ground in the case that bottom of texture and the ground do not meet up.
- **Grass Density:** Change the amount of grass rendered.
- **3 Sprites:** Enables highest LOD with 3 interlacing sprites
- **1 Sprite:** Enables lowest LOD with 1 sprite (else 2 sprites are used; better for an elevated view).
- **Enable wind:** Enable waving movement of the grass.
- **Wind Direction:** 0-360° denotes direction of wind movement.
- **Max Distance:** Maximum drawing distance of grass.
- **LOD2 Distance:** Distance where to switch to second LOD.
- **Transition Size:** Size of the transition area between the LODs (larger values cost more performance but smoothen the transition).
- **Cast Shadows:** Enables grass to cast shadows (Very high overhead).
- **Shadow Thickness:** Makes cast shadows more distinctive. (Also use the shadow strength of the casting light!)
- **Shadow LOD Distance:** Distance up to which the grass casts shadows.
- **HDR On:** Enable this when using HDR.

------------------------

You can add the "Terrain Shader/Shader/GrassCollider.cs" script to the player character model (or any other object) to make the grass bend in a circle around it.
When the script is added to the model, "Radius" specifies the maximum radius where grass is bent.
The "Material" slot of the script needs to be filled with the "Grass Shader Deferred" material.

------------------------

**Performance Hints:**
If more performance is needed you can try to do the following adjustments:
- Reduce any LOD distances
- Disable Shadow Casting
- Reduce density
- Change lowest LOD to 1 Sprite

**Other:**
- The included texture is best used for rather flat terrains (or as long as the grass terrain is flat). For grass on hills a wedge \ / texture is more suitable.
- If you blend two terrain textures the grass assigned to each texture blends depending on the strengths of each texture.


License
----

MIT License

Copyright (c) [2017] [Sebastian Rings]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

