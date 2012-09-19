
attribute vec4 position;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec2 TexCoordOut;
varying lowp vec4 colorVarying;

uniform mat4 modelViewProjectionMatrix;
uniform mat3 normalMatrix;
uniform vec3 lightPosition;
uniform vec4 color;


void main()
{
    vec3 eyeNormal = normalize(normalMatrix * normal);

    float nDotVP = max(0.8, dot(normalize(-lightPosition),eyeNormal));
                 
    colorVarying =  color * nDotVP;
    colorVarying.a = color.a;

    gl_Position = modelViewProjectionMatrix * position;

    TexCoordOut = texCoord;
}
