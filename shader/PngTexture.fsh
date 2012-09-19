precision mediump float;
varying lowp vec2 TexCoordOut;
varying lowp vec4 ColorOut;
uniform sampler2D Tex;

void main()
{
    vec4 color = texture2D(Tex, TexCoordOut);
    float preMutiply = 1.0/color.a;
    color.r *= preMutiply;
    color.g *= preMutiply;
    color.b *= preMutiply;
    gl_FragColor = color*ColorOut;
}
