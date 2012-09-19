
precision mediump float;
varying lowp vec2 TexCoordOut;

uniform sampler2D Tex;

const float blurStep1 = 0.003333;
const float blurStep2 = 0.006666;
const float blurStep3 = 0.009999;
const float blurStep4 = 0.013333;
void main()
{
    float sum = texture2D(Tex, vec2(TexCoordOut.x, TexCoordOut.y)).r * 0.16;
    

    sum += (texture2D(Tex, vec2(TexCoordOut.x, TexCoordOut.y - blurStep3)).r +
        texture2D(Tex, vec2(TexCoordOut.x, TexCoordOut.y + blurStep3)).r) * 0.0625;
    
    sum += (texture2D(Tex, vec2(TexCoordOut.x, TexCoordOut.y - blurStep2)).r +
        texture2D(Tex, vec2(TexCoordOut.x, TexCoordOut.y + blurStep2)).r) * 0.1250;
        
    sum += (texture2D(Tex, vec2(TexCoordOut.x, TexCoordOut.y - blurStep1)).r +
        texture2D(Tex, vec2(TexCoordOut.x, TexCoordOut.y + blurStep1)).r) * 0.1875;
        
    
    sum = 1.0 - sum*.25;
    gl_FragColor = vec4(sum,sum,sum,1.0);
}
