//
//  Blur.vsh
//  Journal
//
//  Created by Julian Walker on 9/8/11.
//  Copyright 2012 FiftyThree, Inc. All rights reserved.
//

precision lowp float;

attribute vec4 position;
attribute vec2 texCoord;

uniform vec2 diff;

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
    v_TexCoord00 = texCoord;
    gl_Position = position;

    v_TexCoord10 = v_TexCoord00 + diff;
    v_TexCoord20 = v_TexCoord10 + diff;
    v_TexCoord30 = v_TexCoord20 + diff;
    //v_TexCoord40 = v_TexCoord30 + diff;
    
    v_TexCoord11 = v_TexCoord00 - diff;
    v_TexCoord21 = v_TexCoord11 - diff;
    v_TexCoord31 = v_TexCoord21 - diff;
    //v_TexCoord41 = v_TexCoord31 - diff;
    
}
