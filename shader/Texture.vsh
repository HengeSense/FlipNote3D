attribute vec4 position;
attribute vec2 texCoord;
 
uniform vec4 color;

varying vec2 TexCoordOut;
varying lowp vec4 ColorOut;

uniform mat4 modelViewProjectionMatrix;



void main(void) {
    gl_Position         = modelViewProjectionMatrix  * position;
	TexCoordOut         = texCoord;
    ColorOut            = color;
}
