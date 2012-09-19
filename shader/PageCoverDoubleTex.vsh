//
//  Shader.vsh
//  OpenGLTest2
//
//  Created by hx on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texCoord0;
attribute vec2 texCoord1;

varying vec2 TexShadeCoord;
varying vec2 TexAlphaCoord;
varying vec2 TexImgCoord;

varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec3 lightPosition;
uniform vec4 color;


void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);
    
    //vec4 diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
    
    float nDotVP = max(0.8, dot(normalize(-lightPosition),eyeNormal));
    
    colorVarying =  color * nDotVP;
    colorVarying.a = color.a;
    
    gl_Position = modelViewProjectionMatrix * position;
    
    TexShadeCoord = texCoord0;
    
    TexAlphaCoord = texCoord0 - vec2(0.5,0);
    
    TexImgCoord   = texCoord1;
}
