//
//  PagePart.m
//  FlipBook3D
//
//  Created by xiang huang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Page.h"
#import "Book.h"
#import "PagePart.h"
#import "GLProgram.h"
#import "BitmapTexture.h"
#import "ConstantValues.h"
#import "Scene3D.h"
#import "BookCover.h"

static GLuint _vertexArray;
static GLuint _vertexBuffer;

static GLProgram *_program;


static GLfloat _vertexData[64] = {
    0,                  PAGEPART_HALFHEIGHT,       0,       0,  0,  1,      .5,		.25,
    -PAGEPART_WIDTH,    PAGEPART_HALFHEIGHT,       0,       0,  0,  1,      0,		.25,
    0,                  -PAGEPART_HALFHEIGHT,      0,       0,  0,  1,      .5,		1,
    -PAGEPART_WIDTH,    -PAGEPART_HALFHEIGHT,      0,       0,  0,  1,      0,		1,
    
    
    PAGEPART_WIDTH,     PAGEPART_HALFHEIGHT,       0,       0,  0,  1,      1,		.25,
    0,                  PAGEPART_HALFHEIGHT,       0,       0,  0,  1,      .5,		.25,
    PAGEPART_WIDTH,     -PAGEPART_HALFHEIGHT,      0,       0,  0,  1,      1,		1,
    0,                  -PAGEPART_HALFHEIGHT,      0,       0,  0,  1,      .5,		1
};


@implementation PagePart
@synthesize part = _part;
@synthesize page = _page;

+(void)initialize{
    _program = [[GLProgram alloc] initWithShader:@"PagePart" :@"PagePart"];
    [_program bindPosition];
    [_program bindNormal];
    [_program bindTextCoord];
    [_program linking];
    [_program bindModelViewProjMtx];
    [_program bindNormalMtx];
    [_program bindLightPos];
    //[_program bindAlpha];
    [_program bindColor];

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


+(GLProgram*)getProgram{
    return _program;
}

-(id)initWidthPart:(enum Part)part page:(Page*)page{
    self = [super init];
    if (self) {
        _part = part;
        _page = page;
    }
    return self;
}

-(void)renderShadow{
    [super renderShadow];
    if(!self.visible || _sceneAlpha<.01){
        return;
    }

    glBindVertexArrayOES(_vertexArray);
    glUniformMatrix4fv(self.scene.background.shadowProgram.modelViewMtx, 1, 0, self.modelViewTransform.m);
    glUniform1f(self.scene.background.shadowProgram.alpha, _sceneAlpha*.25);
    if(_part == LEFT){
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }else {
        glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
    }
}

-(void)render{
    [super render];
    if(!self.visible || _sceneAlpha<.01){
        return;
    }

    glBindVertexArrayOES(_vertexArray);
    glUseProgram(_program.program);

    glUniformMatrix4fv(_program.modelViewProjMtx, 1, 0, self.projTransform.m);
    glUniformMatrix3fv(_program.normalMtx, 1, 0, self.normTransform.m);
    glUniform3f(_program.lightPosition, self.scene.light.direction.x,
                self.scene.light.direction.y,
                self.scene.light.direction.z);
    float color =  1 + _page.z/2000;
    
    glUniform4f(_program.color, color, color, color, _sceneAlpha);
    
    //glEnable(GL_TEXTURE_2D);
    glActiveTexture(GL_TEXTURE0);
    
    
    glBindTexture(GL_TEXTURE_2D, _page.tex.texName);
    
    if(_part == LEFT){
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }else {
        glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
    }
    glBindVertexArrayOES(0);
    glBindTexture(GL_TEXTURE_2D, 0);
    
}

@end
