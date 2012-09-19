varying lowp vec4 colorVarying;
varying lowp vec2 TexCoordOut;
uniform sampler2D Tex;

void main()
{
    gl_FragColor = colorVarying * texture2D(Tex, TexCoordOut);
}