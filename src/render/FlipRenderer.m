//
//  FlipRender.m
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FlipRenderer.h"
#import "Book.h"
#import "Tween.h"
#import "PageData.h"

@implementation FlipRenderer


-(id)initWithBook:(Book *)book{
    self = [super initWithBook:book];
    if(self){
        _expandLevel          = 0;
        _targetExpandLevel    = 0;
        _pageDist       = 150;
        [self buildPagePosition];
        _slideInterval  = .2;
        _expandInterval = .25;
        _isPinchScaling = false;
        _isSelectedPageFullScreen = false;
    }
    return self;
}

-(void)buildPagePosition{
    _pagesPos = malloc(sizeof(GLKVector3)*(MAX_PAGE_IN_BOOK+2));
}



/******************************
 * open
 ******************************/

-(void)activateFromCloseStatus{
    glEnable(GL_CULL_FACE);
    
    [self removeAllTweenOfThisBook];
    [self updateSlideRestrict];
    self.book.cover.visible = true;
    [self flipToPageById:floor(self.book.pages.count*.5)];
    _slideX = _targetSlideX;
    _targetExpandLevel = 1;
    [Tween rotateYTo:self.book duration:1 delay:0 y:0 ease:EASE_CUBIC_IN_OUT];
    [Tween moveTo:self.book duration:1 delay:.1 x:0 y:0 z:-1000 ease:EASE_EXPO_IN_OUT];
    [Tween to:self duration:1 delay:.2 valuePoint:&_expandLevel targetValue:1 ease:EASE_CUBIC_IN_OUT];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dispatchCloseCompleteNotification) object:Nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTouchListner) object:Nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setAnimatingFlagFalse) object:Nil];
    
    [self performSelector:@selector(addTouchListner)  withObject:nil afterDelay:.6];
    [self performSelector:@selector(setAnimatingFlagFalse)  withObject:nil afterDelay:1.1];
    _isAnimating = true;
}


-(void)activateFromCalendarStatus{
    glEnable(GL_CULL_FACE);
    [self removeAllTweenOfThisBook];
    [self updateSlideRestrict];
    self.book.cover.visible = true;
    [self flipToPageById:floor(self.book.pages.count*.5)];
    _slideX = _targetSlideX;
    _targetExpandLevel = 1;
    [Tween moveTo:self.book duration:1 delay:.1 x:0 y:0 z:-1000 ease:EASE_EXPO_IN_OUT];
    [Tween to:self duration:1 delay:.2 valuePoint:&_expandLevel targetValue:1 ease:EASE_CUBIC_IN_OUT];

    for (int i=0; i<self.book.pages.count; i++) {
        Page *page = [self.book.pages objectAtIndex:i];
        [Tween scaleTo:page duration:1 delay:0 x:1 y:1 z:1 ease:EASE_EXPO_OUT];
        [Tween alphaTo:page duration:.5 delay:0 alpha:1 ease:EASE_LINEAR];
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTouchListner) object:Nil];
    [self removeTouchListner];
    
    //rotate back
    [Tween killTweenOf:self.book];
    [Tween rotateYTo:self.book duration:1 delay:0 y:90 ease:EASE_CUBIC_IN_OUT];
    [Tween to:self duration:.6 delay:0 valuePoint:&_expandLevel targetValue:0 ease:EASE_SINE_IN];
    [self performSelector:@selector(dispatchCloseCompleteNotification)  withObject:nil afterDelay:1];
    _isAnimating = true;
}

-(void)dispatchCloseCompleteNotification{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:RENDERER_CLOSE_COMPLETE
     object:self ];
    _isAnimating = false;
}


/******************************
 * deactive
 ******************************/

-(void)deactivate{
    [super deactivate];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTouchListner) object:Nil];
    [self removeTouchListner];
}

/******************************
 * touch listner
 ******************************/
-(void)updateSlideRestrict{
    _maxDragSlideX = _pageDist*.4;
    _maxSlideX = 0;
    _minSlideX = -_pageDist*(self.book.pages.count-1);
    _minDragSlideX = -_pageDist*(self.book.pages.count-1)-_pageDist*.4;;
}

-(void)touchBeginHandler: (NSNotification *) notification{
    [super touchBeginHandler:notification];
    if (_isPinchScaling || _selectedPage!=Nil) {
        return;
    }
    _avgSpeedX = 0;
}

-(void)touchMoveHandler: (NSNotification *) notification{
    [super touchMoveHandler:notification];
    if (_isPinchScaling || _selectedPage!=Nil) {
        return;
    }
    _targetSlideX += _deltaTouchMove.x;
    
    if(_targetSlideX>_maxDragSlideX){
        _targetSlideX 	= _maxDragSlideX;
    }else if(_targetSlideX<_minDragSlideX){
        _targetSlideX 	= _minDragSlideX;
    }
    if((_avgSpeedX>0 && _deltaTouchMove.x<0) || (_avgSpeedX<0 && _deltaTouchMove.x>0)){
        _avgSpeedX 		= 0;
    }else{
        _avgSpeedX = _avgSpeedX*.5 + _deltaTouchMove.x*.5;
    }
}

-(void)touchEndHandler: (NSNotification *) notification{
    if (_isPinchScaling || _selectedPage!=Nil) {
        return;
    }
    if(_targetSlideX>_maxSlideX){
        _targetSlideX 	= _maxSlideX;
    }else if(_targetSlideX<_minSlideX){
        _targetSlideX 	= _minSlideX;
    }
    
    if(abs(_avgSpeedX)>30){
        int pageFlip = floor(_avgSpeedX/10);
        [self flipToPageById:_focusedPage.id-pageFlip];
        
    }else if(_deltaTouchMove.x>5 && _avgSpeedX>3){
        [self flipPrevPage];
        
    }else if(_deltaTouchMove.x<-5 && _avgSpeedX<-3){
        [self flipNextPage];
        
    }else{
        if(abs(_avgSpeedX)<3 && abs(_absTotalTouchMove.x)<5){
            if (!self.book.shelf.bottomBar.isTouching) {
                if (_touchDownPosition.x>100 && _touchDownPosition.y>100
                    && _touchDownPosition.x<self.book.scene.view.frame.size.width-100
                    && _touchDownPosition.y<self.book.scene.view.frame.size.height-100
                    ) {
                    [self selectFocusedPage];
                }
            }
        }else{
            int focusedId	= round(-_slideX/_pageDist);
            if(focusedId<0){
                focusedId = 0;
            }else if(focusedId>self.book.pages.count-1){
                focusedId = self.book.pages.count-1;
            }
            [self flipToPageById: focusedId];
        }
    }
    
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    [super twoFingerPinch:recognizer];
    if (_targetExpandLevel>_selectedPageExpandLevel) {
        _targetExpandLevel = _selectedPageExpandLevel;
    }
}

-(void)twoFingerPinchBegan:(UIPinchGestureRecognizer *)recognizer {
    
    _targetExpandLevel  = _expandLevel;
    _lastPinchScale     = recognizer.scale;
    _targetExpandLevel *= _lastPinchScale;
}

-(void)twoFingerPinchScale:(UIPinchGestureRecognizer *)recognizer {
    _targetExpandLevel *= recognizer.scale/_lastPinchScale;
    _lastPinchScale     = recognizer.scale;
}

-(void)twoFingerPinchEnd:(UIPinchGestureRecognizer *)recognizer {
    _targetExpandLevel *= recognizer.scale/_lastPinchScale;
    _lastPinchScale     = recognizer.scale;
    if (_selectedPage!=Nil) {
        if (_targetExpandLevel<_selectedPageExpandLevel-.1) {
            [self unselectPage];
        }else {
            [self selectFocusedPage];
        }
    }else{
        if (_targetExpandLevel<0.9) {
            [self.book.shelf unselectBook];
        }else if (_targetExpandLevel<1.05) {
            _targetExpandLevel = 1;
        }else {
            [self selectFocusedPage];
        }
    }

}
/******************************
 * page flip & focus
 ******************************/

-(void)flipToPageById:(int)pageId{
    if(pageId<0){
        pageId = 0;
    }else if(pageId>self.book.pages.count-1){
        pageId=self.book.pages.count-1;
    }
    _targetSlideX = - pageId * _pageDist;
}

-(void)flipToPage:(Page *)page{
    _focusedPage = page;
    _targetSlideX	= -_focusedPage.id * _pageDist;
}

-(void)flipPrevPage{
    if(_focusedPage.id>0){
        [self flipToPageById:_focusedPage.id-1];
    }
}
-(void)flipNextPage{
    if(_focusedPage.id<self.book.pages.count-1){
        [self flipToPageById:_focusedPage.id+1];
    }
}


/******************************
 * page select
 ******************************/

-(void)selectFocusedPage{
    _selectedPage       = _focusedPage;
    _targetSlideX       = -_focusedPage.id * _pageDist;
    _targetExpandLevel  = _selectedPageExpandLevel;
}
-(void)unselectPage{
    _selectedPage       = Nil;
    _targetExpandLevel  = 1;
    if (_isSelectedPageFullScreen) {
        [self postSelectPageExitFullScreenEvent];
    }
}

/******************************
 * page delete
 ******************************/
-(void)registNewAddedPage:(Page *)page{
    [self updateSlideRestrict];
}
-(void)unregistRemovedPage:(Page*)page{
    [self updateSlideRestrict];
    if(_targetSlideX>_maxSlideX){
        _targetSlideX 	= _maxSlideX;
    }else if(_targetSlideX<_minSlideX){
        _targetSlideX 	= _minSlideX;
    }
}

/******************************
 * expand
 ******************************/



float _expandInterval       = 0.25;

float _selectedPageExpandLevel	= 1.3304;


/******************************
 * render
 ******************************/

-(void)render:(BOOL)isUpdate{
   
    [super render:isUpdate];

    if(!self.isRendering){
        return;
    }
    if(_expandLevel<.0001f){
        for(int i =0;i<self.book.pages.count;i++){
            Page *page = (Page *)[self.book.pages objectAtIndex:i];
            page.visible = false;
        }
        return;
    }
    
    _slideX+=(_targetSlideX-_slideX)*_slideInterval;
    if(!_isAnimating){
        _expandLevel+=(_targetExpandLevel-_expandLevel)*_expandInterval;
        if(_selectedPage!=Nil &&!_isPinchScaling && !_isSelectedPageFullScreen){
            if (_selectedPageExpandLevel-_expandLevel<.01) {
                [self postSelectPageFullScreenEvent];
            }
        }
    }
    
    int focusedId = -1;
    focusedId	= roundf(-_slideX/_pageDist);
    if(focusedId<0){
        focusedId = 0;
    }else if(focusedId>self.book.pages.count-1){
        focusedId = self.book.pages.count-1;
    }

    _focusedPage = [self.book.pages objectAtIndex:focusedId];
    _focusedPage.visible =true;
    [_focusedPage loadTex];
    GLKVector3 *v = &_pagesPos[focusedId+1];
    

    if (!_isAnimating) {
        self.book.z = -1000+(_expandLevel-1)*1065;
    }
    
    
    v->x	= (_slideX + _focusedPage.id * _pageDist ) * _expandLevel;
    v->y    = 0;
    v->z	= -powf( fabsf(v->x) , 1.08 ) * _expandLevel;
    
    int p       = _pagesPos[focusedId+1].x;
    int count   = 0;

    for(int i=focusedId-1;i>=-1;i--){
        p-= _pageDist;
        v = &_pagesPos[i+1];
        v->x	= p * _expandLevel;
        v->y    = 0;
        v->z	= -powf( fabsf(v->x) , 1.08 ) * _expandLevel ;
        if(isUpdate){
            if(i>=0){
                Page * page =[self.book.pages objectAtIndex:i];
                count++;
                if(count>5){
                    page.visible = false;
                }else{
                    page.visible = true;
                    if(count<3){
                        [page loadTex];
                    }
                }
            }
        }
    }
    
    p = _pagesPos[focusedId+1].x;
    count = 0;
    for(int i=focusedId+1;i<self.book.pages.count+1;i++){
        p+= _pageDist;
        v = &_pagesPos[i+1];
        v->x	= p * _expandLevel;
        v->y    = 0;
        v->z	= -pow( fabs(v->x) , 1.08 ) * _expandLevel;
        if(isUpdate){
            if(i<self.book.pages.count){
                Page * page =[self.book.pages objectAtIndex:i];
                count++;
                if(count>5){
                    page.visible = false;
                }else{
                    page.visible = true;
                    if(count<3){
                        [page loadTex];
                    }
                }
            }
        }
    }
    
    for(int i=0;i<self.book.pages.count;i++){
        Page * page =[self.book.pages objectAtIndex:i];
    
        GLKVector3 *prevPagePos	=  &_pagesPos[i];
        GLKVector3 *pagePos		=  &_pagesPos[i+1];
        GLKVector3 *nextPagePos	=  &_pagesPos[i+2];
    
        float distPrev	= GLKVector3Distance(*prevPagePos,*pagePos);
        float distNext	= GLKVector3Distance(*nextPagePos,*pagePos);
    
        float angPrev   = acos(distPrev*.5/PAGEPART_WIDTH);
        float angNext   = acos(distNext*.5/PAGEPART_WIDTH);
        
        if(distPrev!=0){
           
            angPrev += acos(-(prevPagePos->z-pagePos->z)/distPrev);
            angPrev = angPrev*RADIANS_TO_DEGREES-90;
        }else{
            angPrev = 90;
        }
        if(distNext!=0){
            angNext += acos(-(nextPagePos->z-pagePos->z)/distNext);
            angNext = 90-angNext*RADIANS_TO_DEGREES;
        }else{
            angNext = -90;
        }
        
        if(isUpdate){
            page.x                  = pagePos->x;
            page.y                  = pagePos->y;
            page.z                  = pagePos->z;
            page.partL.rotationY	= angPrev;
            page.partR.rotationY	= angNext;
            
            page.z *=.5;
            
            if(page.x<-FLIPVIEW_PAGE_MAXX){
                page.x = -FLIPVIEW_PAGE_MAXX;
            }else if(page.x>FLIPVIEW_PAGE_MAXX){
                page.x = FLIPVIEW_PAGE_MAXX;
            }
            
            if(i==0){
                self.book.cover.rotationY = 180 + page.partL.rotationY;
                
                self.book.cover.x   = page.x+1*sinf(self.book.cover.rotationY*DEGREES_TO_RADIANS);
                self.book.cover.y   = page.y;
                self.book.cover.z   = page.z+1*cosf(self.book.cover.rotationY*DEGREES_TO_RADIANS);
            }

        }else{
            page.rotationYL = angPrev;
            page.rotationYR = angNext;
        }
    }
    
}

@end
