//
//  CalendarDayClip.m
//  FlipBook3D
//
//  Created by huang xiang on 8/26/12.
//
//

#import "CalendarDayClip.h"
#import "BitmapTexture.h"
#import "GLProgram.h"


static GLuint _vertexArray;
static GLuint _vertexBuffer;

static GLuint _labelVertexArray;
static GLuint _labelVertexBuffer;

static BitmapTexture* _tex;
static GLProgram *_program;

static  int DAYCLIP_WIDTH      = 31;
static  int DAYCLIP_HEIGHT     = 25;




@implementation CalendarDayClip
@synthesize date = _date;

+(void)initialize{
    
    _program = [[GLProgram alloc] initWithShader:@"PngTexture" :@"PngTexture"];
    [_program bindPosition];
    [_program bindTextCoord];
    [_program linking];
    [_program bindModelViewProjMtx];
    [_program bindColor];
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);

    GLfloat _vertexData[20] = {
        DAYCLIP_WIDTH*1.5,     DAYCLIP_HEIGHT*1.5,       0,             0.2422,		0,
        -DAYCLIP_WIDTH*1.5,    DAYCLIP_HEIGHT*1.5,       0,             0,          0,
        DAYCLIP_WIDTH*1.5,     -DAYCLIP_HEIGHT*1.5,      0,             0.2422,		0.3906,
        -DAYCLIP_WIDTH*1.5,    -DAYCLIP_HEIGHT*1.5,      0,             0,          0.3906,
    };
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_vertexData), _vertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 20, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 20, BUFFER_OFFSET(12));
    glBindVertexArrayOES(0);
    
    
    glGenVertexArraysOES(1, &_labelVertexArray);
    glBindVertexArrayOES(_labelVertexArray);
    
    float labelSize = 18;
    
    GLfloat _labelVertexData[200] = {
        labelSize+40,     labelSize+32,       0,             0.1094,  0.3984,
        -labelSize+40,    labelSize+32,       0,             0,       0.3984,
        labelSize+40,     -labelSize+32,      0,             0.1094,  0.3984 + 0.2188,
        -labelSize+40,    -labelSize+32,      0,             0,       0.3984 + 0.2188,
        
        labelSize+40,     labelSize+32,       0,             0.1094*2,  0.3984,
        -labelSize+40,    labelSize+32,       0,             0.1094,    0.3984,
        labelSize+40,     -labelSize+32,      0,             0.1094*2,  0.3984 + 0.2188,
        -labelSize+40,    -labelSize+32,      0,             0.1094,    0.3984 + 0.2188,
        
        labelSize+40,     labelSize+32,       0,             0.1094*3,  0.3984,
        -labelSize+40,    labelSize+32,       0,             0.1094*2,  0.3984,
        labelSize+40,     -labelSize+32,      0,             0.1094*3,  0.3984 + 0.2188,
        -labelSize+40,    -labelSize+32,      0,             0.1094*2,  0.3984 + 0.2188,
        
        labelSize+40,     labelSize+32,       0,             0.1094*4,  0.3984,
        -labelSize+40,    labelSize+32,       0,             0.1094*3,  0.3984,
        labelSize+40,     -labelSize+32,      0,             0.1094*4,  0.3984 + 0.2188,
        -labelSize+40,    -labelSize+32,      0,             0.1094*3,  0.3984 + 0.2188,
        
        labelSize+40,     labelSize+32,       0,             0.1094*5,  0.3984,
        -labelSize+40,    labelSize+32,       0,             0.1094*4,  0.3984,
        labelSize+40,     -labelSize+32,      0,             0.1094*5,  0.3984 + 0.2188,
        -labelSize+40,    -labelSize+32,      0,             0.1094*4,  0.3984 + 0.2188,
        
        labelSize+40,     labelSize+32,       0,             0.1094,  0.6172,
        -labelSize+40,    labelSize+32,       0,             0,       0.6172,
        labelSize+40,     -labelSize+32,      0,             0.1094,  0.6172 + 0.2188,
        -labelSize+40,    -labelSize+32,      0,             0,       0.6172 + 0.2188,
        
        labelSize+40,     labelSize+32,       0,             0.1094*2,  0.6172,
        -labelSize+40,    labelSize+32,       0,             0.1094,    0.6172,
        labelSize+40,     -labelSize+32,      0,             0.1094*2,  0.6172 + 0.2188,
        -labelSize+40,    -labelSize+32,      0,             0.1094,    0.6172 + 0.2188,
        
        labelSize+40,     labelSize+32,       0,             0.1094*3,  0.6172,
        -labelSize+40,    labelSize+32,       0,             0.1094*2,  0.6172,
        labelSize+40,     -labelSize+32,      0,             0.1094*3,  0.6172 + 0.2188,
        -labelSize+40,    -labelSize+32,      0,             0.1094*2,  0.6172 + 0.2188,
        
        labelSize+40,     labelSize+32,       0,             0.1094*4,  0.6172,
        -labelSize+40,    labelSize+32,       0,             0.1094*3,  0.6172,
        labelSize+40,     -labelSize+32,      0,             0.1094*4,  0.6172 + 0.2188,
        -labelSize+40,    -labelSize+32,      0,             0.1094*3,  0.6172 + 0.2188,
        
        labelSize+40,     labelSize+32,       0,             0.1094*5,  0.6172,
        -labelSize+40,    labelSize+32,       0,             0.1094*4,  0.6172,
        labelSize+40,     -labelSize+32,      0,             0.1094*5,  0.6172 + 0.2188,
        -labelSize+40,    -labelSize+32,      0,             0.1094*4,  0.6172 + 0.2188,
    };
    
    glGenBuffers(1, &_labelVertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _labelVertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(_labelVertexData), _labelVertexData, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 20, BUFFER_OFFSET(0));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, 20, BUFFER_OFFSET(12));
    glBindVertexArrayOES(0);
    
    _tex    = [[BitmapTexture alloc]initWithFileName:@"calendar.png" asynchronous:false];
}

-(id)initWithDate:(NSDate*)date{
    self = [super init];
    if (self) {
        _date = date;
        _pages = [[NSMutableArray alloc]init];
        _labelVertexId = 0;
        Rect hitRect;
        hitRect.top     =  DAYCLIP_HEIGHT*1.5;
        hitRect.bottom  = -DAYCLIP_HEIGHT*1.5;
        hitRect.left    = -DAYCLIP_WIDTH*1.5;
        hitRect.right   =  DAYCLIP_WIDTH*1.5;
        self.hitTestRect    = hitRect;
        
    }
    return self;
}

-(void)addpage:(Page*)page{
    [_pages addObject:page];
    if (_pages.count<10) {
        _labelVertexId = (_pages.count-1)*4;
    }else{
        _labelVertexId = 36;
    }
    
}

-(NSArray*)pages{
    return [_pages copy];
}

-(void)renderShadow{
    return;
}

-(BOOL)isEqualToDate:(NSDate*)inputDate{
    unsigned units = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:units fromDate:inputDate];
    
    int year    = [components year];
    int month   = [components month];
    int day     = [components day];
    
    NSDateComponents *components2 = [calendar components:units fromDate:_date];
    
    int year2    = [components2 year];
    int month2   = [components2 month];
    int day2     = [components2 day];
    return (year==year2 && month ==month2 && day==day2);
}

-(void)render{
    [super render];
    if(!self.visible){
        return;
    }
    
    
    glUseProgram(_program.program);
    
    glUniformMatrix4fv(_program.modelViewProjMtx, 1, 0, self.projTransform.m);
    glUniform4f(_program.color, 1, 1, 1, _sceneAlpha);
    
    //glEnable(GL_TEXTURE_2D);
    glActiveTexture(GL_TEXTURE0);
    
    
    glBindTexture(GL_TEXTURE_2D, _tex.texName);
    
    glBindVertexArrayOES(_vertexArray);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glBindVertexArrayOES(0);
    glBindTexture(GL_TEXTURE_2D, 0);
    
}

-(void)renderLabel{
    if(!self.visible){
        return;
    }
    glUseProgram(_program.program);
    
    glUniformMatrix4fv(_program.modelViewProjMtx, 1, 0, self.projTransform.m);
    glUniform4f(_program.color, 1, 1, 1, _sceneAlpha);
    //NSLog(@"%f,%f",_alpha,_sceneAlpha);
    //glEnable(GL_TEXTURE_2D);
    glActiveTexture(GL_TEXTURE0);
    
    
    glBindTexture(GL_TEXTURE_2D, _tex.texName);
    
    glBindVertexArrayOES(_labelVertexArray);
    glDrawArrays(GL_TRIANGLE_STRIP, _labelVertexId, 4);
    
    glBindVertexArrayOES(0);
    glBindTexture(GL_TEXTURE_2D, 0);

}

@end
