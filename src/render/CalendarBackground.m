//
//  CalendarBackground.m
//  FlipBook3D
//
//  Created by huang xiang on 8/19/12.
//
//

#import "CalendarBackground.h"
#import "ConstantValues.h"
#import "GLProgram.h"
#import "Scene3D.h"
#import "Adela3DGLVIew.h"
#import "BitmapTexture.h"
#import "CalendarDayClip.h"

static GLuint _vertexArray;
static GLuint _vertexBuffer;
static BitmapTexture* _tex;
static GLProgram *_program;

// static  int DAYCLIP_WIDTH      = 31;
// static  int DAYCLIP_HEIGHT     = 25;

 static  int DAYCLIP_DISTU      = 32;
 static  int DAYCLIP_DISTV      = 26;

 static  int MONTH_DISTU        = 250;
 static  int MONTH_DISTV        = 205;

 static  int MONTH_HEADHEIGHT   = 46;

static GLfloat _vertexData[20] = {
    PAGEPART_WIDTH*3,     PAGEPART_HALFHEIGHT*3,       0,             1,		.25,
    -PAGEPART_WIDTH*3,    PAGEPART_HALFHEIGHT*3,       0,             0,		.25,
    PAGEPART_WIDTH*3,     -PAGEPART_HALFHEIGHT*3,      0,             1,		1,
    -PAGEPART_WIDTH*3,    -PAGEPART_HALFHEIGHT*3,      0,             0,		1,
    
};

@implementation CalendarBackground


+(void)initialize{
    _program = [[GLProgram alloc] initWithShader:@"PngTexture" :@"PngTexture"];
    [_program bindPosition];
    [_program bindTextCoord];
    [_program linking];
    [_program bindModelViewProjMtx];
    [_program bindColor];
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertexData), _vertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 20, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 20, BUFFER_OFFSET(12));
    glBindVertexArrayOES(0);
    
    _tex = [[BitmapTexture alloc]initWithFileName:@"2012" asynchronous:false];
}

-(void)renderShadow{
    return;
}

-(void)render{
    
    if(!self.visible){
        return;
    }
    //glDisable(GL_DEPTH_TEST);
    glDepthMask(false);
    glBindVertexArrayOES(_vertexArray);
    glUseProgram(_program.program);
    
    glUniformMatrix4fv(_program.modelViewProjMtx, 1, 0, self.projTransform.m);    
    glUniform4f(_program.color, 1, 1, 1, _alpha);
    
    //glEnable(GL_TEXTURE_2D);
    glActiveTexture(GL_TEXTURE0);
    
    
    glBindTexture(GL_TEXTURE_2D, _tex.texName);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glBindVertexArrayOES(0);
    glBindTexture(GL_TEXTURE_2D, 0);
    
    if(_children && _children.count>0){
        for(CalendarDayClip *obj in _children)
            [obj render];
        for(CalendarDayClip *obj in _children)
            [obj renderLabel];
    }
    glDepthMask(true);
    //glEnable(GL_DEPTH_TEST);
}


-(GLKVector3)getDatePosition:(NSDate*)date{
    

    unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit | NSWeekOfMonthCalendarUnit |NSWeekdayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:units fromDate:date];
    
    //int year    = [components year];
    int month   = [components month]-1;
    //int day     = [components day];
    //NSLog(@"%d,%d,%d",year,month,day);
    int weekOfMonth = [components weekOfMonth];
    int weekDay     = [components weekday];
    GLKVector3 v;
    float monthDx	 = (month % 4) * MONTH_DISTU +25;
    float monthDy	 = floor(month/4) * MONTH_DISTV +72;

    v.x	= (( monthDx + weekDay*DAYCLIP_DISTU- .5*DAYCLIP_DISTU-.5)/1024-.5) * PAGEPART_WIDTH*6;
    v.y	= (.5-(monthDy + MONTH_HEADHEIGHT+ weekOfMonth * DAYCLIP_DISTV - .5*DAYCLIP_DISTV-.5)/768)*PAGEPART_HALFHEIGHT*6;
    v.z	= 0;
    
    return(v);
}

@end
