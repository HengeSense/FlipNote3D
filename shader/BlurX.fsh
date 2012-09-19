
precision mediump float;
varying lowp vec2 TexCoordOut;

uniform sampler2D Tex;

const float blurStep1 = 0.003333;
const float blurStep2 = 0.006666;
const float blurStep3 = 0.009999;
const float blurStep4 = 0.013333;

void main()
{
    float sum = texture2D(Tex, vec2(TexCoordOut.x, TexCoordOut.y)).r * 0.25;
    
       
    sum += (texture2D(Tex, vec2(TexCoordOut.x - blurStep3, TexCoordOut.y)).r +
        texture2D(Tex, vec2(TexCoordOut.x + blurStep3, TexCoordOut.y)).r) * 0.0625;
    
    sum += (texture2D(Tex, vec2(TexCoordOut.x - blurStep2, TexCoordOut.y)).r +
        texture2D(Tex, vec2(TexCoordOut.x + blurStep2, TexCoordOut.y)).r) * 0.1250;
        
    sum += (texture2D(Tex, vec2(TexCoordOut.x - blurStep1, TexCoordOut.y)).r +
        texture2D(Tex, vec2(TexCoordOut.x + blurStep1, TexCoordOut.y)).r) * 0.1875;
    
    
    gl_FragColor = vec4(sum,0.0,0.0,1.0);
}
