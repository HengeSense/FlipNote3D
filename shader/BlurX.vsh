attribute vec4 position;
attribute vec2 texCoord;

varying vec2 TexCoordOut;

void main()
{    
    gl_Position = position;
    TexCoordOut = texCoord;
}