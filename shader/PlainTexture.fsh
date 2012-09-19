varying lowp vec4 DestinationColor;

varying lowp vec2 TexCoordOut;
uniform sampler2D Tex;

void main(void) {
    //gl_FragColor = DestinationColor;
	gl_FragColor = texture2D(Tex, TexCoordOut);
}

