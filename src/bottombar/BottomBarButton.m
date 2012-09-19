//
//  BottomBarButton.m
//  FlipBook3D
//
//  Created by huang xiang on 8/6/12.
//
//

#import "BottomBarButton.h"
#import "ConstantValues.h"
#import "GLProgram.h"
#import "Scene3D.h"


@implementation BottomBarButton


static BitmapTexture* _tex;

+(BitmapTexture*)getTexture{
    return _tex;
}
static GLProgram *_program;




+(void)initialize{
    _tex    = [[BitmapTexture alloc]initWithFileName:@"bottomBar.png" asynchronous:false];
    
    _program = [[GLProgram alloc] initWithShader:@"BottomBar" :@"BottomBar"];
    [_program bindPosition];
    [_program bindNormal];
    [_program bindTextCoord];
    [_program linking];
    [_program bindModelViewProjMtx];
    [_program bindNormalMtx];
    [_program bindLightPos];
    [_program bindColor];

    
}


@synthesize part = _part;
@synthesize buttonName = _buttonName;
+(GLProgram*)getProgram{
    return _program;
}

-(id)initWidthPart:(enum Part)part andName:(enum ButtonName)name{
    self = [super init];
    if (self) {
        _part = part;
        _buttonName = name;
        [self initBuffers];
        [self updateBuffers:_u :_v :false];
        Rect hitRect;
        
        if(_part==LEFT){
            hitRect.top     =  BOTTOMBARBTN_HALFSIZE;
            hitRect.bottom  = -BOTTOMBARBTN_HALFSIZE;
            hitRect.left    = -BOTTOMBARBTN_SIZE;
            hitRect.right   = 0;
            self.hitTestRect    = hitRect;
        }else{
            hitRect.top     =  BOTTOMBARBTN_HALFSIZE;
            hitRect.bottom  = -BOTTOMBARBTN_HALFSIZE;
            hitRect.left    = 0;
            hitRect.right   = BOTTOMBARBTN_SIZE;
            self.hitTestRect    = hitRect;
        }
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(touchClickHandler:)
         name:TOUCH_CLICK
         object:self];
    }
    return self;
}

-(enum Part)part{
    return _part;
}

-(void)setPart:(enum Part)part{
    _part = part;

    Rect hitRect;
    
    if(_part==LEFT){
        hitRect.top     =  BOTTOMBARBTN_HALFSIZE;
        hitRect.bottom  = -BOTTOMBARBTN_HALFSIZE;
        hitRect.left    = -BOTTOMBARBTN_SIZE;
        hitRect.right   = 0;
        self.hitTestRect    = hitRect;
    }else{
        hitRect.top     =  BOTTOMBARBTN_HALFSIZE;
        hitRect.bottom  = -BOTTOMBARBTN_HALFSIZE;
        hitRect.left    = 0;
        hitRect.right   = BOTTOMBARBTN_SIZE;
        self.hitTestRect    = hitRect;
    }
}


-(void)touchClickHandler:(NSNotification *) notification{
    
}

-(void)initBuffers{
        
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    //glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(12));
    
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 32, BUFFER_OFFSET(24));
    
    glBindVertexArrayOES(0);
}

-(void)updateBuffers:(int)u :(int)v :(BOOL)firstTime{
    _u = u;
    _v = v;
    GLfloat texCoordAx;
    GLfloat texCoordAy;
    GLfloat texCoordBx;
    GLfloat texCoordBy;
    texCoordAx = u*80.0/256;  texCoordAy = v*80.0/256; texCoordBx = (u+1)*80.0/256; texCoordBy = (v+1)*80.0/256;
    
    GLfloat vertexData[64] = {
        0,                  BOTTOMBARBTN_HALFSIZE,       0,       0,  0,  1,    texCoordBx,texCoordAy,
        -BOTTOMBARBTN_SIZE, BOTTOMBARBTN_HALFSIZE,       0,       0,  0,  1,    texCoordAx,texCoordAy,
        0,                  -BOTTOMBARBTN_HALFSIZE,      0,       0,  0,  1,    texCoordBx,texCoordBy,
        -BOTTOMBARBTN_SIZE, -BOTTOMBARBTN_HALFSIZE,      0,       0,  0,  1,    texCoordAx,texCoordBy,
        
        
        BOTTOMBARBTN_SIZE,  BOTTOMBARBTN_HALFSIZE,       0,       0,  0,  1,    texCoordBx,texCoordAy,
        0,                  BOTTOMBARBTN_HALFSIZE,       0,       0,  0,  1,    texCoordAx,texCoordAy,
        BOTTOMBARBTN_SIZE,  -BOTTOMBARBTN_HALFSIZE,      0,       0,  0,  1,    texCoordBx,texCoordBy,
        0,                  -BOTTOMBARBTN_HALFSIZE,      0,       0,  0,  1,    texCoordAx,texCoordBy
    };
    
    
    if (firstTime) {
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    }else{
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
        glBufferSubData(GL_ARRAY_BUFFER, 0, sizeof(vertexData), vertexData);
    }
    glBindVertexArrayOES(0);
}
-(void)renderShadow{
    [super renderShadow];
    if(!self.visible){
        return;
    }
    
    glBindVertexArrayOES(_vertexArray);
    glUniformMatrix4fv(self.scene.background.shadowProgram.modelViewMtx, 1, 0, self.modelViewTransform.m);
    glUniform1f(self.scene.background.shadowProgram.alpha, 1);
    
    if(_part == LEFT){
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }else {
        glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
    }
}

-(void)render{
    [super render];
    if(!self.visible){
        return;
    }
    
    glBindVertexArrayOES(_vertexArray);
    glUseProgram(_program.program);
    
    glUniformMatrix4fv(_program.modelViewProjMtx, 1, 0, self.projTransform.m);
    glUniformMatrix3fv(_program.normalMtx, 1, 0, self.normTransform.m);
    glUniform3f(_program.lightPosition, self.scene.light.direction.x,
                self.scene.light.direction.y,
                self.scene.light.direction.z);
    
    glUniform4f(_program.color, 1, 1, 1, 1);
    

    
    //glEnable(GL_TEXTURE_2D);
    glActiveTexture(GL_TEXTURE0);
    
    
    glBindTexture(GL_TEXTURE_2D, _tex.texName);
    
    if(_part == LEFT){
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    }else {
        glDrawArrays(GL_TRIANGLE_STRIP, 4, 4);
    }
    glBindVertexArrayOES(0);
    
}

@end
