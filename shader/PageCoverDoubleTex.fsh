//
//  Shader.fsh
//  OpenGLTest2
//
//  Created by hx on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
precision mediump float;
varying lowp vec4 colorVarying;
varying lowp vec2 TexShadeCoord;
varying lowp vec2 TexAlphaCoord;
varying lowp vec2 TexImgCoord;

uniform sampler2D OverlayTex;
uniform sampler2D ImgTex;


void main()
{
    vec4 colorImg   = texture2D(ImgTex, TexImgCoord);
    float alpha     = texture2D(OverlayTex, TexAlphaCoord).a;
    vec4 colorOverlay = texture2D(OverlayTex, TexShadeCoord);
    if(colorOverlay.a!=0.0){
        float preMutiply = 1.0/colorOverlay.a;
        colorOverlay.r *= preMutiply;
        colorOverlay.g *= preMutiply;
        colorOverlay.b *= preMutiply;
    }
    vec4 result = colorVarying * (colorOverlay*colorOverlay.a + colorImg*(1.0-colorOverlay.a));
    result.a *= alpha;
    gl_FragColor = result;
}
