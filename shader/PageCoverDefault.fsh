//
//  Shader.fsh
//  OpenGLTest2
//
//  Created by hx on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
precision mediump float;
varying lowp vec4 colorVarying;
varying lowp vec2 TexImgCoord;

uniform sampler2D ImgTex;


void main()
{

    vec4 color = texture2D(ImgTex, TexImgCoord);
        float preMutiply = 1.0/color.a;
        color.r *= preMutiply;
        color.g *= preMutiply;
        color.b *= preMutiply;
    
    
    gl_FragColor = color*colorVarying;
}
