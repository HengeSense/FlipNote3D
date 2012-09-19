//
//  BookCover.m
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "Book.h"
#import "BookCover.h"
#import "GLProgram.h"
#import "ConstantValues.h"
#import "Scene3D.h"
#import "DirectionalLight.h"

static GLuint _vertexOES;
static GLuint _vertexBuffer;

static GLProgram *_defaultProgram;
static GLProgram *_doubleTexProgram;
static BitmapTexture *_whiteTex;
static BitmapTexture *_blackTex;
static GLfloat _vertexData[80] = {
    PAGEPART_WIDTH,     PAGEPART_HALFHEIGHT,       0,       0,  0,  1,      .5,		0,      0.666,0,
    0,                  PAGEPART_HALFHEIGHT,       0,       0,  0,  1,      0,		0,      0,0,
    PAGEPART_WIDTH,     -PAGEPART_HALFHEIGHT,      0,       0,  0,  1,      .5,		.75,    0.666,1,
    0,                  -PAGEPART_HALFHEIGHT,      0,       0,  0,  1,      0,		.75,    0,1,
    
    PAGEPART_WIDTH,     PAGEPART_HALFHEIGHT,       0,       0,  0,  1,      1,		0,      0.666,0,
    0,                  PAGEPART_HALFHEIGHT,       0,       0,  0,  1,      .5,		0,      0,0,
    PAGEPART_WIDTH,     -PAGEPART_HALFHEIGHT,      0,       0,  0,  1,      1,		.75,    0.666,1,
    0,                  -PAGEPART_HALFHEIGHT,      0,       0,  0,  1,      .5,		.75,     0,1
};


@implementation BookCover

@synthesize book = _book;
@synthesize tex = _tex;

+(void)initialize{
    _defaultProgram = [[GLProgram alloc] initWithShader:@"PageCoverDefault" :@"PageCoverDefault"];
    [_defaultProgram bindPosition];
    [_defaultProgram bindNormal];
    [_defaultProgram bindTextCoord];
    [_defaultProgram linking];
    [_defaultProgram bindModelViewProjMtx];
    [_defaultProgram bindNormalMtx];
    [_defaultProgram bindLightPos];
    [_defaultProgram bindColor];
    
    _doubleTexProgram = [[GLProgram alloc] initWithShader:@"PageCoverDoubleTex" :@"PageCoverDoubleTex"];
    [_doubleTexProgram bindPosition];
    [_doubleTexProgram bindNormal];
    [_doubleTexProgram bindTextCoord0];
    [_doubleTexProgram bindTextCoord1];
    [_doubleTexProgram linking];
    [_doubleTexProgram bindModelViewProjMtx];
    [_doubleTexProgram bindNormalMtx];
    [_doubleTexProgram bindLightPos];
    [_doubleTexProgram bindColor];
    glUseProgram(_doubleTexProgram.program);
    GLuint overlayTexLoc = glGetUniformLocation(_doubleTexProgram.program, "OverlayTex");
    GLuint imgTexLoc = glGetUniformLocation(_doubleTexProgram.program, "ImgTex");
    
    glUniform1i(overlayTexLoc, 0);
    glUniform1i(imgTexLoc, 1);
    
    glGenVertexArraysOES(1, &_vertexOES);
    glBindVertexArrayOES(_vertexOES);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertexData), _vertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 40, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 40, BUFFER_OFFSET(12));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 40, BUFFER_OFFSET(24));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord1);
    glVertexAttribPointer(GLKVertexAttribTexCoord1, 2,  GL_FLOAT, GL_FALSE, 40, BUFFER_OFFSET(32));
    glBindVertexArrayOES(0);
    
    
    _whiteTex = [[BitmapTexture alloc]initWithFileName:@"bookcoverWhite" asynchronous:false];
    _blackTex = [[BitmapTexture alloc]initWithFileName:@"bookcoverBlack" asynchronous:false];
}


-(id)initWithBook:(Book *) book{
    self = [super init];
    
    if (self) {
        _book   = book;
        if (_book.data.cover!=Nil && _book.data.cover!=BOOKCOVER_WHITE && _book.data.cover!=BOOKCOVER_BLACK) {
            _tex    = [[BitmapTexture alloc]initWithFileName:_book.data.cover asynchronous:true];
        }
    }
    return self;
}

-(void)reloadCover{
    if (_tex) {
        [_tex dispose];
        _tex = Nil;
    }
    if (_book.data.cover!=Nil && _book.data.cover!=BOOKCOVER_WHITE && _book.data.cover!=BOOKCOVER_BLACK) {
        _tex    = [[BitmapTexture alloc]initWithFileName:_book.data.cover asynchronous:true];
    }
}
-(void)setCoverImage:(UIImage *)img{
    if (_tex) {
        [_tex dispose];
        _tex = Nil;
    }
    if (img) {
        _tex = [[BitmapTexture alloc]initWithCGImage:img.CGImage];
    }
}
-(void)renderShadow{
    [super renderShadow];
    if(!self.visible || _sceneAlpha<.01){
        return;
    }
    /*if(!_tex.isLoaded){
        return;
    }*/
    glBindVertexArrayOES(_vertexOES);

    glUniformMatrix4fv(self.scene.background.shadowProgram.modelViewMtx, 1, 0, self.modelViewTransform.m);
    glUniform1f(self.scene.background.shadowProgram.alpha, _sceneAlpha*.25);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
}

-(void)render{
    [super render];
    if(!self.visible || _sceneAlpha<.01){
        return;
    }
    /*if(!_tex.isLoaded){
        return;
    }*/
    glBindVertexArrayOES(_vertexOES);
    
    if (_tex && _tex.isLoaded) {
        glUseProgram(_doubleTexProgram.program);
        glUniformMatrix4fv(_doubleTexProgram.modelViewProjMtx, 1, 0, self.projTransform.m);
        glUniformMatrix3fv(_doubleTexProgram.normalMtx, 1, 0, self.normTransform.m);
        glUniform3f(_doubleTexProgram.lightPosition, self.scene.light.direction.x,
                    self.scene.light.direction.y,
                    self.scene.light.direction.z);
        glUniform4f(_doubleTexProgram.color, 1, 1, 1, _sceneAlpha);
        
        
        glActiveTexture(GL_TEXTURE0);
        if (_book.data.cover==BOOKCOVER_WHITE ) {
            glBindTexture(GL_TEXTURE_2D, _whiteTex.texName);
        }else{
            glBindTexture(GL_TEXTURE_2D, _blackTex.texName);
        }
        
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, _tex.texName);
        
        glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
    }else{
        glUseProgram(_defaultProgram.program);
        glUniformMatrix4fv(_defaultProgram.modelViewProjMtx, 1, 0, self.projTransform.m);
        glUniformMatrix3fv(_defaultProgram.normalMtx, 1, 0, self.normTransform.m);
        glUniform3f(_defaultProgram.lightPosition, self.scene.light.direction.x,
                    self.scene.light.direction.y,
                    self.scene.light.direction.z);
        glUniform4f(_defaultProgram.color, 1, 1, 1, _sceneAlpha);
        
        if (_book.data.cover==BOOKCOVER_WHITE ) {
            glBindTexture(GL_TEXTURE_2D, _whiteTex.texName);
        }else{
            glBindTexture(GL_TEXTURE_2D, _blackTex.texName);
        }
        
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }
    
    glBindVertexArrayOES(0);
    //glBindTexture(GL_TEXTURE_2D, 0);
}

@end
