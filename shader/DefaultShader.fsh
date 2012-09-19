//
//  Shader.fsh
//  OpenGLTest2
//
//  Created by hx on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;
varying lowp vec2 TexCoordOut;
uniform sampler2D Tex;

void main()
{
    gl_FragColor = colorVarying * texture2D(Tex, TexCoordOut);
    //gl_FragColor = texture2D(Texture, TexCoordOut);
}
