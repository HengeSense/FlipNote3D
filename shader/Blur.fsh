//
//  Blur.fsh
//  Journal
//
//  Created by Julian Walker on 9/8/11.
//  Copyright 2012 FiftyThree, Inc. All rights reserved.
//

precision lowp float;

uniform sampler2D s_Texture;

varying vec2 v_TexCoord00;

varying vec2 v_TexCoord10;
varying vec2 v_TexCoord20;
varying vec2 v_TexCoord30;
//varying vec2 v_TexCoord40;

varying vec2 v_TexCoord11;
varying vec2 v_TexCoord21;
varying vec2 v_TexCoord31;
//varying vec2 v_TexCoord41;
void main()
{
    float sum = 0.25 * texture2D(s_Texture, v_TexCoord00).r;

    sum += 0.1875 * (texture2D(s_Texture, v_TexCoord10).r + texture2D(s_Texture, v_TexCoord11).r);
    sum += 0.1250 * (texture2D(s_Texture, v_TexCoord20).r + texture2D(s_Texture, v_TexCoord21).r);
    sum += 0.0625 * (texture2D(s_Texture, v_TexCoord30).r + texture2D(s_Texture, v_TexCoord31).r);
    //sum += 0.09 * (texture2D(s_Texture, v_TexCoord40).r + texture2D(s_Texture, v_TexCoord41).r);
    
    //gl_FragColor = vec4(1.0,0.0,1.0,1.0);//texture2D(s_Texture, v_TexCoord00);
    gl_FragColor = vec4(sum, 0.0, 0.0, 1.0);
}
