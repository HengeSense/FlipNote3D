//
//  Shader.fsh
//  OpenGLTest2
//
//  Created by hx on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
precision mediump float;
varying lowp vec2 TexCoordOut0;
varying lowp vec2 TexCoordOut1;
uniform sampler2D ShadowTex;
uniform sampler2D Tex;

void main()
{
    vec4 shadowColor = texture2D(ShadowTex,TexCoordOut1);
    vec4 texColor = texture2D(Tex,TexCoordOut0);
    shadowColor.r = 1.0 - shadowColor.r;
    shadowColor.g = shadowColor.r;
    shadowColor.b = shadowColor.r;

    gl_FragColor = shadowColor*texColor;
}
