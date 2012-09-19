//
//  Cube.m
//  FlipNote3D
//
//  Created by xiang huang on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Cube.h"


static GLfloat _vertexData[288] = {
    // Data layout for each line below is:
    // positionX, positionY, positionZ,     normalX, normalY, normalZ,
    .5f, -.5f, -.5f,        0.8f, 0.2f, 0.0f,   0.0f,0.0f,
    .5f, .5f, -.5f,         1.0f, 0.0f, 0.0f,   1.0f,0.0f,
    .5f, -.5f, .5f,         1.0f, 0.0f, 0.0f,   0.0f,1.0f,
    .5f, -.5f, .5f,         1.0f, 0.0f, 0.0f,   0.0f,1.0f,
    .5f, .5f, .5f,          1.0f, 0.0f, 0.0f,   1.0f,1.0f,
    .5f, .5f, -.5f,         1.0f, 0.0f, 0.0f,   1.0f,0.0f,
    
    .5f, .5f, -.5f,         0.0f, 1.0f, 0.0f,   0.0f,0.0f,
    -.5f, .5f, -.5f,        0.0f, 1.0f, 0.0f,   1.0f,0.0f,
    .5f, .5f, .5f,          0.0f, 1.0f, 0.0f,   0.0f,1.0f,
    .5f, .5f, .5f,          0.0f, 1.0f, 0.0f,   0.0f,1.0f,
    -.5f, .5f, -.5f,        0.0f, 1.0f, 0.0f,   1.0f,1.0f,
    -.5f, .5f, .5f,         0.0f, 1.0f, 0.0f,   1.0f,0.0f,
    
    -.5f, .5f, -.5f,        -1.0f, 0.0f, 0.0f,   0.0f,0.0f,
    -.5f, -.5f, -.5f,       -1.0f, 0.0f, 0.0f,   1.0f,0.0f,
    -.5f, .5f, .5f,         -1.0f, 0.0f, 0.0f,   0.0f,1.0f,
    -.5f, .5f, .5f,         -1.0f, 0.0f, 0.0f,   0.0f,1.0f,
    -.5f, -.5f, -.5f,       -1.0f, 0.0f, 0.0f,   1.0f,1.0f,
    -.5f, -.5f, .5f,        -1.0f, 0.0f, 0.0f,   1.0f,0.0f,
    
    -.5f, -.5f, -.5f,       0.0f, -1.0f, 0.0f,   0.0f,0.0f,
    .5f, -.5f, -.5f,        0.0f, -1.0f, 0.0f,   1.0f,0.0f,
    -.5f, -.5f, .5f,        0.0f, -1.0f, 0.0f,   0.0f,1.0f,
    -.5f, -.5f, .5f,        0.0f, -1.0f, 0.0f,   0.0f,1.0f,
    .5f, -.5f, -.5f,        0.0f, -1.0f, 0.0f,   1.0f,1.0f,
    .5f, -.5f, .5f,         0.0f, -1.0f, 0.0f,   1.0f,0.0f,
    
    .5f, .5f, .5f,          0.0f, 0.0f, 1.0f,   0.0f,0.0f,
    -.5f, .5f, .5f,         0.0f, 0.0f, 1.0f,   1.0f,0.0f,
    .5f, -.5f, .5f,         0.0f, 0.0f, 1.0f,   0.0f,1.0f,
    .5f, -.5f, .5f,         0.0f, 0.0f, 1.0f,   0.0f,1.0f,
    -.5f, .5f, .5f,         0.0f, 0.0f, 1.0f,   1.0f,1.0f,
    -.5f, -.5f, .5f,        0.0f, 0.0f, 1.0f,   1.0f,0.0f,
    
    .5f, -.5f, -.5f,        0.0f, 0.0f, -1.0f,   0.0f,0.0f,
    -.5f, -.5f, -.5f,       0.0f, 0.0f, -1.0f,   1.0f,0.0f,
    .5f, .5f, -.5f,         0.0f, 0.0f, -1.0f,   0.0f,1.0f,
    .5f, .5f, -.5f,         0.0f, 0.0f, -1.0f,   0.0f,1.0f,
    -.5f, -.5f, -.5f,       0.0f, 0.0f, -1.0f,   1.0f,1.0f,
    -.5f, .5f, -.5f,        0.0f, 0.0f, -1.0f,   1.0f,0.0f
};

@implementation Cube

@synthesize program = _program;
@synthesize tex = _tex;
-(id)init{
    self = [super init];
    if(self){
        [self setupBuffers];
        _program = [[GLProgram alloc] initWithShader:@"DefaultShader" :@"DefaultShader"];
        [_program bindPosition];
        [_program bindNormal];
        [_program bindTextCoord];
        [_program linking];
        _tex = [[BitmapTexture alloc]initWithFileName:@"texture.jpg" asynchronous:false];
    }
    return self;
}

-(void)dispose{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    if (self.program) {
        [self.program dispose];
    }
    [super dispose];
}

-(void)setupBuffers{
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertexData), _vertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
    glBindVertexArrayOES(0);
}

-(void)render{
    [super render];
    
    glBindVertexArrayOES(_vertexArray);
    
    glUseProgram(_program.program);
    
    glUniformMatrix4fv(_program.modelViewProjMtx, 1, 0, self.projTransform.m);
    glUniformMatrix3fv(_program.normalMtx, 1, 0, self.normTransform.m);
    
    
    glBindTexture(GL_TEXTURE_2D,_tex.texName);
    glDrawArrays(GL_TRIANGLES, 0, 36);
    glBindVertexArrayOES(0);
 
}
@end
