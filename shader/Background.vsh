//
//  Shader.vsh
//  OpenGLTest2
//
//  Created by hx on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec2 texCoord0;
attribute vec2 texCoord1;

varying vec2 TexCoordOut0;
varying vec2 TexCoordOut1;
void main()
{    
    
    TexCoordOut0 = texCoord0;
    TexCoordOut1 = texCoord1;
    gl_Position = position;
}
