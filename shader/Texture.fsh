precision mediump float;
varying lowp vec2 TexCoordOut;
varying lowp vec4 ColorOut;
uniform sampler2D Tex;

void main()
{
    gl_FragColor = ColorOut*texture2D(Tex, TexCoordOut);
}