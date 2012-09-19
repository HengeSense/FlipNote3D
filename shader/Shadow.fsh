//
//  Shader.fsh
//  OpenGLTest2
//
//  Created by hx on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

varying lowp float AlphaOut;


void main()
{
    gl_FragColor = vec4(AlphaOut,0,0,1);
}
