//
//  Shader.vsh
//  OpenGLTest2
//
//  Created by hx on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec2 TexCoordOut;
varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec3 lightPosition;


void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);

    vec4 diffuseColor = vec4(1.0, 1.0, 1.0, 1.0);
    
    float nDotVP = max(0.8, dot(normalize(-lightPosition),eyeNormal));
                 
    colorVarying =  diffuseColor * nDotVP;
    
    gl_Position = modelViewProjectionMatrix * position;
    
    TexCoordOut = texCoord;
}
