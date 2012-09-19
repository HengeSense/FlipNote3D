//
//  CalenderRender.m
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarRenderer.h"
#import "RendererBase.h"
#import "Book.h"
#import "Scene3D.h"
#import "PageData.h"
#import "Tween.h"
#import "BitmapTexture.h"
#import "CalendarDayClip.h"

@implementation CalendarRenderer


-(id)initWithBook:(Book *)book{
    self = [super initWithBook:book];
    if(self!=Nil){
        [self buildPagePosition];
        _dayClips   = [[NSMutableArray alloc]init];
        _bg = [[CalendarBackground alloc]init];
        
        _bg.x = 0;
        _bg.y = 0;
        _bg.z = 10;
        
    }
    return self;
}


-(void)buildPagePosition{
    _pagesPos = malloc(sizeof(GLKVector3)*(MAX_PAGE_IN_BOOK));
    _selectedDayPagePos = malloc(sizeof(GLKVector3)*(MAX_PAGE_IN_BOOK));
}
-(void)resetPagesPosition{
    for (int i=0; i<self.book.pages.count; i++) {
        Page *page = [self.book.pages objectAtIndex:i];
        PageData *pd = [self.book.data.pages objectAtIndex:page.id];
        GLKVector3 pagePos = [_bg getDatePosition:pd.date];
        _pagesPos[i].x  = pagePos.x;
        _pagesPos[i].y  = pagePos.y;
        _pagesPos[i].z  = 10;
    }
}

-(void)resetPagesInSelectedDayPosition{
    int row = 4;
    int distU = PAGEPART_WIDTH+150;
    int distV = PAGEPART_HALFHEIGHT+150;
    int rowWidth = distU*(row-1);
    
    for (int i=0; i<_selectedDayClip.pages.count; i++) {
        _selectedDayPagePos[i].x  = i%row*distU - rowWidth*.5f;
        _selectedDayPagePos[i].y  = 600 - floorf(1.0f*i/row)*distV;
        _selectedDayPagePos[i].z  = 10;
    }
}
    


/******************************
 * open
 ******************************/

-(void)activateFromTableStatus{
    NSLog(@"calendar view activateFromTableStatus");
    
    _expandLevel        = 1;
    _targetExpandLevel  = 1;
    _expandInterval     = .25;
    _isExpandInCalendarStatus = false;
    [self removeAllTweenOfThisBook];
    
    
    [self showBg];
    
    // remove day clips
    if (_dayClips.count>0) {
        for (int i=0; i<_dayClips.count; i++) {
            CalendarDayClip *dayClip = [_dayClips objectAtIndex:i];
            [_bg removeChild:dayClip];
        }
        [_dayClips removeAllObjects];
    }
    
    for (int i=0; i<self.book.pages.count; i++) {
        Page *page = [self.book.pages objectAtIndex:i];
        PageData *pd = [self.book.data.pages objectAtIndex:page.id];
        GLKVector3 pagePos = [_bg getDatePosition:pd.date];
        
        _pagesPos[i].x  = pagePos.x;
        _pagesPos[i].y  = pagePos.y;
        _pagesPos[i].z  = 1;
        [Tween moveTo:page duration:1 delay:0 x:_pagesPos[i].x y:_pagesPos[i].y z:_pagesPos[i].z ease:EASE_EXPO_OUT];
        [Tween scaleTo:page duration:1 delay:0 x:.08 y:.08 z:.08 ease:EASE_EXPO_OUT];
        [Tween alphaTo:page duration:.6 delay:.4 alpha:0 ease:EASE_LINEAR];
        bool hasDateInArray = false;
        for (int j=0; j<_dayClips.count; j++) {
            CalendarDayClip *dayClip = [_dayClips objectAtIndex:j];
            
            if ([dayClip isEqualToDate:pd.date]) {
                hasDateInArray = true;
                [dayClip addpage:page];
            }
        }
        if (!hasDateInArray) {
            CalendarDayClip *dayClip = [[CalendarDayClip alloc]initWithDate:[pd.date copy]];
            [dayClip addpage:page];
            [_dayClips addObject:dayClip];
            dayClip.position = _pagesPos[i];
            [_bg addChild:dayClip];
        }
    }

    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dispatchCloseCompleteNotification) object:Nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTouchListner) object:Nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setAnimatingFlagFalse) object:Nil];
    
    [self performSelector:@selector(addTouchListner)  withObject:nil afterDelay:.6];
    [self performSelector:@selector(setAnimatingFlagFalse)  withObject:nil afterDelay:1.2];
    _isAnimating = true;
}




/******************************
 * close
 ******************************/

-(void)close{
    [super close];
    self.isRendering = false;
    self.book.cover.visible = true;
    
    [self removeAllTweenOfThisBook];
    
    for (int i=0; i<self.book.pages.count; i++) {
        Page *page = [self.book.pages objectAtIndex:i];
        [Tween rotateYTo:page.partL duration:.3 delay:0 y:90 ease:EASE_EXPO_OUT];
        [Tween rotateYTo:page.partR duration:.3 delay:0 y:-90 ease:EASE_EXPO_OUT];
        [Tween scaleTo:page duration:.3 delay:0 x:1 y:1 z:1 ease:EASE_EXPO_OUT];
        [Tween moveTo:page duration:.3 delay:0 x:0 y:0 z:0 ease:EASE_EXPO_OUT];
        
    }
    [Tween rotateYTo:self.book duration:1 delay:0 y:90 ease:EASE_CUBIC_OUT];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTouchListner) object:Nil];
    [self removeTouchListner];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(activeFromFlipCompleteHandler) object:Nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dispatchCloseCompleteNotification) object:Nil];
    [self performSelector:@selector(dispatchCloseCompleteNotification)  withObject:Nil afterDelay:1];
    _isAnimating = true;
}

-(void)dispatchCloseCompleteNotification{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:RENDERER_CLOSE_COMPLETE
     object:self ];
    _isAnimating = false;
}

-(void)deactivate{
    [super deactivate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTouchListner) object:Nil];
    [self removeTouchListner];
    [self hideBg:1];
}


/*************************
 touch events
 *************************/

-(void)addTouchListner{
    [super addTouchListner];
    for (int i=0; i<_dayClips.count; i++) {
        CalendarDayClip *dayClip = [_dayClips objectAtIndex:i];
        [[NSNotificationCenter defaultCenter]
        addObserver:self
        selector:@selector(dayClipTouchClick:)
        name:TOUCH_CLICK
        object:dayClip];
    }
}

-(void)removeTouchListner{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TOUCH_CLICK object:self.book.scene];
    [super removeTouchListner];
    for (int i=0; i<_dayClips.count; i++) {
        CalendarDayClip *dayClip = [_dayClips objectAtIndex:i];
        [[NSNotificationCenter defaultCenter]
         removeObserver:self name:TOUCH_CLICK object:dayClip];
    }
}


-(void)touchMoveHandler: (NSNotification *) notification{
    [super touchMoveHandler:notification];
    float deltaY         = _deltaTouchMove.y * 2.5;
    _dragY              -= deltaY;
}

-(void)touchEndHandler: (NSNotification *) notification{
    if (_dragY>_maxDragY) {
        _dragY = _maxDragY;
    }else if(_dragY<_minDragY) {
        _dragY = _minDragY;
    }
    _touchDownPage = Nil;
}


-(void)dayClipTouchClick: (NSNotification *) notification{
    if (self.book.shelf.bottomBar.isTouching) {
        return;
    }
    if (_selectedDayClip!=Nil) {
        return;
    }
    CalendarDayClip *dayClip = notification.object;
    NSArray * pages = dayClip.pages;
    if (pages.count==1) {
        Page * page = [pages objectAtIndex:0];
        [self selectPage:page];
    }else{
        [self selectDay:dayClip];
    }
    
}


-(void)twoFingerPinchBegan:(UIPinchGestureRecognizer *)recognizer {
    
    _expandLevel        = 1;
    _targetExpandLevel  = 1;
    _lastPinchScale     = recognizer.scale;
    [self removePagesAndPagePartsTween];
    if (_selectedDayClip==Nil) {
        for (int i=0; i<self.book.pages.count; i++) {
            Page *page = [self.book.pages objectAtIndex:i];
            [Tween alphaTo:page duration:.3 delay:0 alpha:1 ease:EASE_LINEAR];
        }
    }
    if (_selectedPage==Nil && _selectedDayClip==Nil) {
        [self hideBg:.3];
    }

}

-(void)twoFingerPinchScale:(UIPinchGestureRecognizer *)recognizer {
    float deltaScale = recognizer.scale/_lastPinchScale;
    if (_selectedPage==Nil) {
        _targetExpandLevel *= deltaScale*deltaScale;
        if (_targetExpandLevel>1) {
            _targetExpandLevel = 1;
        }
        if (_selectedDayClip==Nil) {
            if (_targetExpandLevel<.9 && _isExpandInCalendarStatus) {
                _isExpandInCalendarStatus = false;
                _targetExpandLevel = .6;
                int distU = PAGEPART_WIDTH*.7;
                int rowWidth = distU*self.book.pages.count;
                for (int i=0; i<self.book.pages.count; i++) {
                    _pagesPos[i].x  = i*distU - rowWidth*.5f;
                    _pagesPos[i].y  = 0;
                    _pagesPos[i].z  = 10;
                }
            }else if(_targetExpandLevel>.6 && !_isExpandInCalendarStatus){
                _isExpandInCalendarStatus = true;
                _targetExpandLevel = 1;
                [self resetPagesPosition];
            }
        }
    }else{
        _selectedPage.scaleX *= deltaScale;
        _selectedPage.scaleY *= deltaScale;
        _selectedPage.scaleZ *= deltaScale;
    }
    _lastPinchScale = recognizer.scale;
}

-(void)twoFingerPinchEnd:(UIPinchGestureRecognizer *)recognizer {
    _lastPinchScale = recognizer.scale;
    _isPinchScaling = false;
    if (_selectedPage==Nil) {
        if (_selectedDayClip==Nil) {
            if (_targetExpandLevel>.6) {
                if (!_isExpandInCalendarStatus){
                    _isExpandInCalendarStatus = true;
                    _targetExpandLevel = 1;
                    [self resetPagesPosition];
                }
                [self removePagesAndPagePartsTween];
                for (int i=0; i<self.book.pages.count; i++) {
                    Page *page = [self.book.pages objectAtIndex:i];
                    [Tween rotateYTo:page.partL duration:.6 delay:0 y:0 ease:EASE_EXPO_OUT];
                    [Tween rotateYTo:page.partR duration:.6 delay:0 y:0 ease:EASE_EXPO_OUT];
                    [Tween moveTo:page duration:.6 delay:0 x:_pagesPos[i].x y:_pagesPos[i].y z:_pagesPos[i].z ease:EASE_EXPO_OUT];
                    [Tween scaleTo:page duration:.6 delay:0 x:.08 y:.08 z:.08 ease:EASE_EXPO_OUT];
                    [Tween alphaTo:page duration:.6 delay:0 alpha:0 ease:EASE_LINEAR];
                }
                
                [self showBg];
            }else{
                _targetExpandLevel = 0;
                [self.book.shelf unselectBook];
            }
        }else{
            [self unselectDay];
        }
    }else{
        [self unselectPage];
    }

}

/*************************
 select & unselect date
 *************************/

-(void)updateDragYBound{
    if (_selectedDayClip.pages.count>12) {
        _minDragY = 0;
        _maxDragY = -_selectedDayPagePos[_selectedDayClip.pages.count-1].y-550;
    }else{
        _minDragY = 0;
        _maxDragY = 0;
    }
}
-(void)selectDay:(CalendarDayClip*)dayClip{
    NSLog(@"selectDay");
    _selectedDayClip = dayClip;
    [self resetPagesInSelectedDayPosition];
    
    _dragY    = 0;
    float delay = 0;
    [self removePagesAndPagePartsTween];
    for (int i=0; i<dayClip.pages.count; i++) {

        Page *page = [dayClip.pages objectAtIndex:i];
        page.z = 10;
        [Tween rotateYTo:page.partL duration:.6 delay:delay y:0 ease:EASE_EXPO_OUT];
        [Tween rotateYTo:page.partR duration:.6 delay:delay y:0 ease:EASE_EXPO_OUT];
        [Tween scaleTo:page duration:.6 delay:delay x:.5 y:.5 z:.5 ease:EASE_EXPO_OUT];
        [Tween alphaTo:page duration:.3 delay:0 alpha:1 ease:EASE_LINEAR];
        delay+=.03;
    }
    [Tween killTweenOf:_bg];
    [Tween scaleTo:_bg duration:1 delay:0 x:1 y:1 z:1 ease:EASE_EXPO_OUT];
    [Tween alphaTo:_bg duration:.6 delay:0 alpha:.2 ease:EASE_LINEAR];
    for (int i=0;i<_dayClips.count;i++){
        CalendarDayClip *dayClip = [_dayClips objectAtIndex:i];
        [Tween alphaTo:dayClip duration:.3 delay:0 alpha:0 ease:EASE_LINEAR];
    }
    [self updateDragYBound];
    [self performSelector:@selector(addPageClickHandler) withObject:Nil afterDelay:.05];
}

-(void)addPageClickHandler{
    for (int i=0; i<_selectedDayClip.pages.count; i++) {
        Page *page = [_selectedDayClip.pages objectAtIndex:i];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(pageTouchClick:)
         name:TOUCH_CLICK
         object:page];
    }
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sceneTouchClickWhileDayClipSelected:)
     name:TOUCH_CLICK
     object:self.book.scene];
}

-(void)sceneTouchClickWhileDayClipSelected:(NSNotification *) notification{
    
    if (_selectedDayClip!=Nil) {
        for (int i=0; i<_selectedDayClip.pages.count; i++) {
            Page *page = [_selectedDayClip.pages objectAtIndex:i];
            if (page.isTouching) {
                return;
            }
        }
        if (self.book.shelf.bottomBar.isTouching) {
            NSDate *today = [[NSDate alloc]init];
            if ([_selectedDayClip isEqualToDate:today]){
                return;
            }
        }
        [self unselectDay];
    }
}

-(void)unselectDay{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:TOUCH_CLICK object:self.book.scene];
    
    for (int i=0; i<_selectedDayClip.pages.count; i++) {
        
        Page *page = [_selectedDayClip.pages objectAtIndex:i];
        [[NSNotificationCenter defaultCenter]
         removeObserver:self name:TOUCH_CLICK object:page];
        [Tween killTweenOf:page];
        [Tween killTweenOf:page.partL];
        [Tween killTweenOf:page.partR];
        float duration = sqrt(_expandLevel)*.5;
        [Tween moveTo:page duration:duration delay:0 x:_pagesPos[page.id].x y:_pagesPos[page.id].y z:_pagesPos[page.id].z ease:EASE_EXPO_OUT];
        [Tween rotateYTo:page.partL duration:duration*.6 delay:0 y:0 ease:EASE_EXPO_OUT];
        [Tween rotateYTo:page.partR duration:duration*.6 delay:0 y:0 ease:EASE_EXPO_OUT];
        [Tween scaleTo:page duration:duration*.6 delay:0 x:.08 y:.08 z:.08 ease:EASE_EXPO_OUT];
        [Tween alphaTo:page duration:duration*.6 delay:0 alpha:0 ease:EASE_LINEAR];
    }
    [Tween killTweenOf:_bg];
    [Tween scaleTo:_bg duration:1 delay:0 x:1 y:1 z:1 ease:EASE_EXPO_OUT];
    [Tween alphaTo:_bg duration:.6 delay:0 alpha:1 ease:EASE_LINEAR];
    for (int i=0;i<_dayClips.count;i++){
        CalendarDayClip *dayClip = [_dayClips objectAtIndex:i];
        [Tween killTweenOf:dayClip];
        [Tween alphaTo:dayClip duration:.6 delay:0 alpha:1 ease:EASE_LINEAR];
    }
    _selectedDayClip = Nil;
}

-(void)pageTouchClick: (NSNotification *) notification{
    if (self.book.shelf.bottomBar.isTouching) {
        return;
    }
    if (_selectedPage!=Nil || _selectedDayClip==Nil) {
        return;
    }
    NSLog(@"pageTouchClick");
    Page *page = notification.object;
    [self selectPage:page];
}


/*************************
 select & unselect page
 *************************/

-(void)selectPage:(Page *)page{
    if (_selectedPage!=Nil) {
        return;
    }
    _selectedPage         = page;
    page.alpha = 1;
    [Tween moveTo:page duration:.3 delay:0 x:0 y:0 z:1333 ease:EASE_EXPO_OUT];
    [Tween scaleTo:page duration:.3 delay:0 x:1 y:1 z:1 ease:EASE_EXPO_OUT];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(postSelectPageFullScreenEvent) object:Nil];
    [self performSelector:@selector(postSelectPageFullScreenEvent)  withObject:Nil afterDelay:.3];
}



-(void)unselectPage{
    if (_selectedPage==Nil) {
        return;
    }
    if (_isSelectedPageFullScreen) {
        [self postSelectPageExitFullScreenEvent];
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(postSelectPageFullScreenEvent) object:Nil];
    [Tween killTweenOf:_selectedPage];
    
    if (_selectedDayClip==Nil) {
        [Tween alphaTo:_selectedPage duration:.6 delay:.4 alpha:0 ease:EASE_LINEAR];
        [Tween scaleTo:_selectedPage duration:1 delay:0 x:.08 y:.08 z:.08 ease:EASE_EXPO_OUT];
        [Tween moveTo:_selectedPage duration:1 delay:0 x:_pagesPos[_selectedPage.id].x y:_pagesPos[_selectedPage.id].y z:_pagesPos[_selectedPage.id].z ease:EASE_EXPO_OUT];
    }else{
        [Tween alphaTo:_selectedPage duration:.6 delay:.4 alpha:1 ease:EASE_LINEAR];
        [Tween scaleTo:_selectedPage duration:1 delay:0 x:.5 y:.5 z:.5 ease:EASE_EXPO_OUT];
        int index = [_selectedDayClip.pages indexOfObject:_selectedPage];
        [Tween moveTo:_selectedPage duration:1 delay:0
                    x:_selectedDayPagePos[index].x
                    y:_selectedDayPagePos[index].y+_dragY
                    z:_selectedDayPagePos[index].z
                 ease:EASE_EXPO_OUT];
    }
    _selectedPage = Nil;
}

/*************************
 add &delete
 *************************/

-(void)registNewAddedPage:(Page*)page{
    PageData *pd = [self.book.data.pages objectAtIndex:page.id];
    bool hasDateInArray = false;
    for (int j=0; j<_dayClips.count; j++) {
        CalendarDayClip *dayClip = [_dayClips objectAtIndex:j];
        
        if ([dayClip isEqualToDate:pd.date]) {
            hasDateInArray = true;
            [dayClip addpage:page];
        }
    }
    if (!hasDateInArray) {
        CalendarDayClip *dayClip = [[CalendarDayClip alloc]initWithDate:[pd.date copy]];
        [_dayClips addObject:dayClip];
        [dayClip addpage:page];
        
        dayClip.alpha = 1;
        dayClip.position = _pagesPos[page.id];
        [_bg addChild:dayClip];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(dayClipTouchClick:)
         name:TOUCH_CLICK
         object:dayClip];
    }
    if (_selectedDayClip!=Nil && [_selectedDayClip isEqualToDate:pd.date]) {
        [self resetPagesInSelectedDayPosition];
        [Tween scaleTo:page duration:1 delay:0 x:.5 y:.5 z:.5 ease:EASE_EXPO_OUT];
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(pageTouchClick:)
         name:TOUCH_CLICK
         object:page];
        [self updateDragYBound];
    }else{
        [Tween moveTo:page duration:.6 delay:0 x:_pagesPos[page.id].x y:_pagesPos[page.id].y z:_pagesPos[page.id].z ease:EASE_EXPO_OUT];
        [Tween scaleTo:page duration:.6 delay:0 x:.08 y:.08 z:.08 ease:EASE_EXPO_OUT];
        [Tween alphaTo:page duration:.6 delay:0 alpha:0 ease:EASE_LINEAR];
    }
    
}

/*************************
 render
 *************************/


-(void)render:(BOOL)isUpdate{
    
    [super render:isUpdate];
    
    if(!self.isRendering){
        Page *firstPage  = [self.book.pages objectAtIndex:0];
        self.book.cover.rotationY = 180+firstPage.partL.rotationY;
        self.book.cover.x   = firstPage.x +1*sinf(self.book.cover.rotationY*DEGREES_TO_RADIANS);
        self.book.cover.y   = firstPage.y;
        self.book.cover.z   = firstPage.z +1*cosf(self.book.cover.rotationY*DEGREES_TO_RADIANS);
        return;
    }
    if (_isPinchScaling && _selectedPage==Nil) {
        _expandLevel = _targetExpandLevel;
        
        if (_selectedDayClip==Nil) {

            float partRotation = _expandLevel<.5 ? 89 : (89*(1-_expandLevel)*2);
            if (partRotation<0) {
                partRotation = 0;
            }
            float scale = _expandLevel>1? .08:((1.0-_expandLevel)*.92+.08);
            for (int i=0; i<self.book.pages.count; i++) {
                Page *page  = [self.book.pages objectAtIndex:i];
            
                float targetX = _pagesPos[i].x *_expandLevel;
                float targetY = _pagesPos[i].y *_expandLevel;
                float targetZ = _pagesPos[i].z *_expandLevel;
                
                page.x      += (targetX-page.x)*.1;
                page.y      += (targetY-page.y)*.1;
                page.z      += (targetZ-page.z)*.1;
            
                page.scaleX = scale;
                page.scaleY = scale;
                page.scaleZ = scale;
            
                page.partL.rotationY = partRotation;
                page.partR.rotationY = -partRotation;
            }
        }else{
            float scale = _expandLevel*.42+.08;
            for (int i=0; i<_selectedDayClip.pages.count; i++) {
                Page *page = [_selectedDayClip.pages objectAtIndex:i];
                
                page.x      = _expandLevel*_selectedDayPagePos[i].x + _pagesPos[page.id].x *(1-_expandLevel);
                page.y      = _expandLevel*(_dragY+_selectedDayPagePos[i].y) + _pagesPos[page.id].y*(1-_expandLevel);
                page.z      = _expandLevel*_selectedDayPagePos[i].z + _pagesPos[page.id].z *(1-_expandLevel);
                
                page.scaleX = scale;
                page.scaleY = scale;
                page.scaleZ = scale;
                
            }
        }
    }else if(_selectedDayClip!=Nil){
        for (int i=0; i<_selectedDayClip.pages.count; i++) {
            Page *page  = [_selectedDayClip.pages objectAtIndex:i];
            if (_selectedPage!=page) {
                float targetY = _dragY + _selectedDayPagePos[i].y;
                page.x      += (_selectedDayPagePos[i].x-page.x)*.25;
                page.z      += (_selectedDayPagePos[i].z-page.z)*.25;
                page.y      += (targetY-page.y)*.25;
                if (page.y>800) {
                    page.alpha  = (400.0-(page.y-800))/400;
                }else if(page.y<-800) {
                    page.alpha  = (400.0+(800+page.y))/400;
                }else{
                    page.alpha  = 1;
                }
            }
        }
    }
}



/*************************
 bg
 *************************/

-(void)showBg{
    if (_bg.parent == Nil) {
        [self.book addChild:_bg];
    }
    _bg.alpha = 0;
    _bg.scaleX= 1.2;
    _bg.scaleY= 1.2;
    _bg.scaleZ= 1.2;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBgComplete) object:Nil];
    [Tween killTweenOf:_bg];
    [Tween scaleTo:_bg duration:1 delay:0 x:1 y:1 z:1 ease:EASE_EXPO_OUT];
    [Tween alphaTo:_bg duration:1 delay:0 alpha:1 ease:EASE_EXPO_OUT];
}

-(void)hideBg:(float)animTime{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideBgComplete) object:Nil];
    [Tween killTweenOf:_bg];
    [Tween scaleTo:_bg duration:animTime delay:0 x:1.2 y:1.2 z:1.2 ease:EASE_EXPO_OUT];
    [Tween alphaTo:_bg duration:animTime delay:0 alpha:0 ease:EASE_EXPO_OUT];
    [self performSelector:@selector(hideBgComplete)  withObject:nil afterDelay:animTime];
}

-(void)hideBgComplete{
    [self.book removeChild:_bg];
}



@end
