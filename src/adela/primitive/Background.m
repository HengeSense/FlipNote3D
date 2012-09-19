//
//  Background.m
//  FlipNote3D
//
//  Created by xiang huang on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Background.h"
#import "Math.h"
#import "Scene3D.h"

static GLfloat _vertexData[28] = {
    -1.0f, -1.0f, 0.99999f,      0.0f,0.25f,    0.0f,0.0f,
    1.0f,  -1.0f, 0.99999f,      1.0f,0.25f,    1.0f,0.0f,
    -1.0f,  1.0f, 0.99999f,      0.0f,1.0f,     0.0f,1.0f,
    1.0f,   1.0f, 0.99999f,      1.0f,1.0f,     1.0f,1.0f
};

static GLfloat _shadowVertexData[20] = {
    -1.0f, -1.0f, 0.99999f,      0.0f,0.0f,
    1.0f,  -1.0f, 0.99999f,      1.0f,0.0f,
    -1.0f,  1.0f, 0.99999f,      0.0f,1.0f,
    1.0f,   1.0f, 0.99999f,      1.0f,1.0f
};
@implementation Background

@synthesize scene = _scene;
@synthesize tex = _tex;
@synthesize program = _program;
@synthesize shadowTex = _shadowTex;
@synthesize shadowFboName = _shadowFboName;
@synthesize shadowProgram = _shadowProgram;
@synthesize shadowMtx = _shadowMtx;
@synthesize shadowTexWidth = _shadowTexWidth;
@synthesize shadowTexHeight = _shadowTexHeight;

@synthesize blurTex = _blurTex;
@synthesize blurTex2 = _blurTex2;

@synthesize blurFboName = _blurFboName;
@synthesize blurFboName2 = _blurFboName2;

@synthesize blurXProgram = _blurXProgram;
@synthesize blurYProgram = _blurYProgram;
@synthesize blurProgram = _blurProgram;

@synthesize shadowDepthPos = _shadowDepthPos;
@synthesize shadowLightPositionPos = _shadowLightPositionPos;


-(id)initWithTexture:(BitmapTexture *)tex scene:(Scene3D *)scene{
    self = [super init];
    _tex = tex;
    _scene = scene;
    _blurProgram = [[GLProgram alloc]initWithShader:@"Blur" :@"Blur"];
    [_blurProgram bindPosition];
    [_blurProgram bindTextCoord];
    [_blurProgram linking];
    _blurDiff = glGetUniformLocation(_blurProgram.program,"diff");
    
    /*_blurXProgram= [[GLProgram alloc]initWithShader:@"BlurX" :@"BlurX"];
    [_blurXProgram bindPosition];
    [_blurXProgram bindTextCoord];
    [_blurXProgram linking];
    
    _blurYProgram= [[GLProgram alloc]initWithShader:@"BlurY" :@"BlurY"];
    [_blurYProgram bindPosition];
    [_blurYProgram bindTextCoord];
    [_blurYProgram linking];*/
    
    _shadowProgram= [[GLProgram alloc]initWithShader:@"Shadow" :@"Shadow"];
    [_shadowProgram bindPosition];
    [_shadowProgram linking];
    
    [_shadowProgram bindModelViewMtx];
    [_shadowProgram bindProjMtx];
    [_shadowProgram bindAlpha];
    
    _shadowDepthPos = glGetUniformLocation(_shadowProgram.program,"shadowDepth");
    _shadowLightPositionPos = glGetUniformLocation(_shadowProgram.program,"lightPosition");

    
    _program    = [[GLProgram alloc]initWithShader:@"Background" :@"Background"];
    [_program bindPosition];
    [_program bindTextCoord0];
    [_program bindTextCoord1];
    [_program linking];
    [_program bindModelViewProjMtx];
    glUseProgram(_program.program);
    GLuint texLoc = glGetUniformLocation(_program.program, "Tex");
    GLuint shadowTexLoc = glGetUniformLocation(_program.program, "ShadowTex");
    glUniform1i(texLoc, 0);
    glUniform1i(shadowTexLoc, 1);
    

    [self setupBuffers];
    [self setupShadowMtx];
    
    return self;
}

-(void)dispose{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (self.program) {
        [self.program dispose];
    }
}

-(void)setupBuffers{
    _shadowTexWidth = 512;
    _shadowTexHeight = 384;
    
    //shadow texture
    //NSLog([NSString stringWithFormat:@"%f,%f",_scene.view.bounds.size.width, _scene.view.bounds.size.height]);
    
    glGenTextures(1, &_shadowTex);
    glBindTexture(GL_TEXTURE_2D, _shadowTex);
    
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 
				 _shadowTexWidth,_shadowTexHeight, 0,
				 GL_RGBA, GL_UNSIGNED_BYTE, NULL);

	glGenFramebuffers(1, &_shadowFboName);
	glBindFramebuffer(GL_FRAMEBUFFER, _shadowFboName);	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _shadowTex, 0);

    glGenTextures(1, &_blurTex);
    glBindTexture(GL_TEXTURE_2D, _blurTex);
    
    // blur 1
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 
				 _shadowTexWidth,_shadowTexHeight,  0,
				 GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    
	glGenFramebuffers(1, &_blurFboName);
	glBindFramebuffer(GL_FRAMEBUFFER, _blurFboName);	
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _blurTex, 0);
    
    //blur 2
    /*glGenTextures(1, &_blurTex2);
    glBindTexture(GL_TEXTURE_2D, _blurTex2);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA,
				 _shadowTexWidth,_shadowTexHeight,  0,
				 GL_RGBA, GL_UNSIGNED_BYTE, NULL);
    
    
	glGenFramebuffers(1, &_blurFboName2);
	glBindFramebuffer(GL_FRAMEBUFFER, _blurFboName2);
	glFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, _blurTex2, 0);*/
    //vertexs
    
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertexData), _vertexData, GL_STATIC_DRAW);

    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 28, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 28, BUFFER_OFFSET(12));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord1);
    glVertexAttribPointer(GLKVertexAttribTexCoord1, 2, GL_FLOAT, GL_FALSE, 28, BUFFER_OFFSET(20));
    glBindVertexArrayOES(0);
    
    
    glGenVertexArraysOES(1, &_shadowVertexArray);
    glBindVertexArrayOES(_shadowVertexArray);
    
    glGenBuffers(1, &_shadowVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _shadowVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_shadowVertexData), _shadowVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 20, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 20, BUFFER_OFFSET(12));
    glBindVertexArrayOES(0);
}

-(void)setupShadowMtx{
    
    GLKVector4 p = GLKVector4Make(0, 0, 1000,0);
    GLKVector4 l = GLKVector4Make(1,1,1000,1);

    float dotp = GLKVector4DotProduct(p, l);
    
    _shadowMtx  = GLKMatrix4Make(dotp-l.x * p.x,     -l.y * p.x,         -l.z * p.x,     -l.w * p .x,
                                 -l.x * p.y,         dotp-l.y * p.y,     -l.z * p.y,     -l.w * p.y, 
                                 -l.x * p.z,         -l.y * p.z,         dotp-l.z * p.z, -l.w * p.z, 
                                 -l.x * p.w,         -l.y * p.w,         -l.z * p.w,     dotp - l.w * p.w);

}

-(void)clearRenderBuffers{
    glDepthMask(GL_TRUE);
    glBindFramebuffer(GL_FRAMEBUFFER, _shadowFboName);
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    const GLenum discards0[]  = {GL_COLOR_ATTACHMENT0};
    glDiscardFramebufferEXT(GL_FRAMEBUFFER,1,discards0);
    
    
    glBindFramebuffer(GL_FRAMEBUFFER, _blurFboName);
    glClear(GL_COLOR_BUFFER_BIT);
    const GLenum discards1[]  = {GL_COLOR_ATTACHMENT0};
    glDiscardFramebufferEXT(GL_FRAMEBUFFER,1,discards1);
}

-(void)renderBlur{
    glBindVertexArrayOES(_shadowVertexArray);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _blurFboName);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _shadowTex);
    glUseProgram(_blurProgram.program);
    glUniform2f(_blurDiff, 0.00390625,0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glBindTexture(GL_TEXTURE_2D, 0);

    
    glBindFramebuffer(GL_FRAMEBUFFER, _shadowFboName);
    glBindTexture(GL_TEXTURE_2D, _blurTex);
    glUseProgram(_blurProgram.program);
    glUniform2f(_blurDiff, 0,0.005208333);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _blurFboName);
    glBindTexture(GL_TEXTURE_2D, _shadowTex);
    glUseProgram(_blurProgram.program);
    glUniform2f(_blurDiff, 0.001953125,0);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    
    glBindFramebuffer(GL_FRAMEBUFFER, _shadowFboName);
    glBindTexture(GL_TEXTURE_2D, _blurTex);
    glUseProgram(_blurProgram.program);
    glUniform2f(_blurDiff, 0,0.00260417);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    glBindVertexArrayOES(0);
    
    
}



-(void)render{
    glBindVertexArrayOES(_vertexArray);
    //glEnable(GL_TEXTURE_2D);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _tex.texName);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, _shadowTex);

    glUseProgram(_program.program);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    //glActiveTexture(GL_TEXTURE1);
    //glBindTexture(GL_TEXTURE_2D, 0);
    //glDisable(GL_TEXTURE_2D);
    //glActiveTexture(GL_TEXTURE0);
    //glBindTexture(GL_TEXTURE_2D, 0);
    //glDisable(GL_TEXTURE_2D);
    glBindVertexArrayOES(0);
}

@end
