//
//  Shader.vsh
//  OpenGLTest2
//
//  Created by hx on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;


uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

uniform float alpha;
uniform float shadowDepth;
uniform vec3 lightPosition;

varying float AlphaOut;

void main()
{
    AlphaOut = alpha;
    
    vec4 pos = modelViewMatrix * position;
    pos.x -= lightPosition.x;
    pos.y -= lightPosition.y;
    pos.z -= lightPosition.z;
    pos.x = pos.x * abs(shadowDepth/pos.z)+lightPosition.x;
    pos.y = pos.y * abs(shadowDepth/pos.z)+lightPosition.y;
    pos.z = shadowDepth;
    gl_Position = projectionMatrix * pos;
  
}
