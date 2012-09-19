//
//  CalenderRender.h
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RendererBase.h"
#import "Page.h"
#import "CalendarBackground.h"
#import "CalendarDayClip.h"

@interface CalendarRenderer : RendererBase{
    GLKVector3 *_pagesPos;
    GLKVector3 *_selectedDayPagePos;
    
    float _maxDragY;
    float _minDragY;
    float _dragY;
    
    Page * _touchDownPage;
    
    
    CalendarDayClip *_selectedDayClip;
    
    BOOL _isExpandInCalendarStatus;
    
    
    CalendarBackground *_bg;
    

    float _expandLevel;
    float _targetExpandLevel;
    float _expandInterval;
    
    NSMutableArray *_dayClips;
}

-(void)resetPagesPosition;


@end
