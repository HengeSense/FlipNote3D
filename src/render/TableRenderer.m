//
//  TableRender.m
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableRenderer.h"
#import "FlipRenderer.h"
#import "Book.h"
#import "Tween.h"
#import "Page.h"

@implementation TableRenderer


-(void)updateDragYBound{
    if (self.book.pages.count>12) {
        _minDragY = 0;
        _maxDragY = -_pagesPos[self.book.pages.count-1].y-550;
    }else{
        _minDragY = 0;
        _maxDragY = 0;
    }
}
-(void)buildPagePosition{
    _pagesPos = malloc(sizeof(GLKVector3)*(MAX_PAGE_IN_BOOK));
}
-(void)resetPagesPosition{
    int row = 4;
    int distU = PAGEPART_WIDTH+150;
    int distV = PAGEPART_HALFHEIGHT+150;
    int rowWidth = distU*(row-1);
    for (int i=0; i<self.book.pages.count; i++) {
        _pagesPos[i].x  = i%row*distU - rowWidth*.5f;
        _pagesPos[i].y  = 600 - floorf(1.0f*i/row)*distV;
        _pagesPos[i].z  = 10;
    }

}

/******************************
 * open
 ******************************/

-(void)activateFromFlipStatus{
    NSLog(@"table view activateFromFlipStatus");

    _expandLevel  = 1;
    _targetExpandLevel = 1;
    _expandInterval = .25;
    _isExpandInTableStatus = true;
    
    [self removeAllTweenOfThisBook];
    self.book.cover.visible = false;
    
    self.isRendering = false;
    [self buildPagePosition];
    [self resetPagesPosition];
        _dragY    = 0;
    
    int focusedPageId = ((FlipRenderer*)self.book.renderer).focusedPage.id;
    Page *firstPage = [self.book.pages objectAtIndex:focusedPageId];
    firstPage.visible    = true;
    [firstPage loadThumb];
    float delay = 0;
    float maxDelay = 0;
    for (int i=0; i<focusedPageId; i++) {
        
        Page *page = [self.book.pages objectAtIndex:i];
        page.visible    = true;
        [Tween moveTo:page duration:1 delay:delay x:_pagesPos[i].x y:_pagesPos[i].y z:_pagesPos[i].z ease:EASE_EXPO_OUT];
        [Tween rotateYTo:page.partL duration:1 delay:delay y:0 ease:EASE_EXPO_OUT];
        [Tween rotateYTo:page.partR duration:1 delay:delay y:0 ease:EASE_EXPO_OUT];
        [Tween scaleTo:page duration:1 delay:delay x:.5 y:.5 z:.5 ease:EASE_EXPO_OUT];
        delay+=.03;
        [page loadThumb];
    }
    maxDelay = delay;
    delay = 0;
    for (int i=self.book.pages.count-1; i>focusedPageId; i--) {
        
        Page *page = [self.book.pages objectAtIndex:i];
        page.visible    = true;
        
        [Tween moveTo:page duration:1 delay:delay x:_pagesPos[i].x y:_pagesPos[i].y z:_pagesPos[i].z ease:EASE_EXPO_OUT];
        [Tween rotateYTo:page.partL duration:.6 delay:delay y:0 ease:EASE_EXPO_OUT];
        [Tween rotateYTo:page.partR duration:.6 delay:delay y:0 ease:EASE_EXPO_OUT];
        [Tween scaleTo:page duration:1 delay:delay x:.5 y:.5 z:.5 ease:EASE_EXPO_OUT];
        delay+=.03;
        [page loadThumb];
    }
    if(delay>maxDelay){
        maxDelay = delay;
    }
    maxDelay+=.03;
    
    
    [Tween moveTo:firstPage duration:1 delay:maxDelay x:_pagesPos[focusedPageId].x y:_pagesPos[focusedPageId].y z:_pagesPos[focusedPageId].z ease:EASE_EXPO_OUT];
    [Tween rotateYTo:firstPage.partL duration:1 delay:maxDelay y:0 ease:EASE_EXPO_OUT];
    [Tween rotateYTo:firstPage.partR duration:1 delay:maxDelay y:0 ease:EASE_EXPO_OUT];
    [Tween scaleTo:firstPage duration:1 delay:maxDelay x:.5 y:.5 z:.5 ease:EASE_EXPO_OUT];
    
    [Tween moveZTo:self.book duration:1+maxDelay delay:0 z:-2000 ease:EASE_EXPO_OUT];
    
    
    [self performSelector:@selector(activeFromFlipCompleteHandler)  withObject:nil afterDelay:maxDelay+1];
    [self updateDragYBound];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dispatchCloseCompleteNotification) object:Nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(addTouchListner) object:Nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setAnimatingFlagFalse) object:Nil];
    
    [self performSelector:@selector(addTouchListner)  withObject:nil afterDelay:maxDelay+1];
    [self performSelector:@selector(setAnimatingFlagFalse)  withObject:nil afterDelay:maxDelay+1];
    _isAnimating = true;
}

-(void)activeFromFlipCompleteHandler{
    glDisable(GL_CULL_FACE);
    self.isRendering = true;
}


/******************************
 * close
 ******************************/

-(void)close{
    [super close];
    glDisable(GL_CULL_FACE);
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
}

/******************************
 * toches
 ******************************/

-(void)addTouchListner{
    [super addTouchListner];
    for (int i=0; i<self.book.pages.count; i++) {
        Page *page = [self.book.pages objectAtIndex:i];
        [[NSNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(pageTouchClick:)
            name:TOUCH_CLICK
            object:page];
    }
}


-(void)removeTouchListner{
    [super removeTouchListner];
    for (int i=0; i<self.book.pages.count; i++) {
        Page *page = [self.book.pages objectAtIndex:i];
        [[NSNotificationCenter defaultCenter]
         removeObserver:self name:TOUCH_CLICK object:page];
    }
}




-(void)touchMoveHandler: (NSNotification *) notification{
    [super touchMoveHandler:notification];
    float deltaY         = _deltaTouchMove.y * 2.5;
    NSLog(@"%f",deltaY);
    _dragY              -= deltaY;
}

-(void)touchEndHandler: (NSNotification *) notification{
    if (_dragY>_maxDragY) {
        _dragY = _maxDragY;
    }else if(_dragY<_minDragY) {
        _dragY = _minDragY;
    }
}

-(void)pageTouchClick: (NSNotification *) notification{
    if (_isPinchScaling) {
        return;
    }
    if (self.book.shelf.bottomBar.isTouching) {
        return;
    }
    Page *page = notification.object;
    [self selectPage:page];
}


-(void)twoFingerPinchBegan:(UIPinchGestureRecognizer *)recognizer {
    
    _expandLevel = 1;
    _targetExpandLevel = 1;
    _lastPinchScale = recognizer.scale;
    [self removePagesAndPagePartsTween];
}

-(void)twoFingerPinchScale:(UIPinchGestureRecognizer *)recognizer {
    float deltaScale = recognizer.scale/_lastPinchScale;
    if (_selectedPage==Nil) {
        _targetExpandLevel *= deltaScale * deltaScale;
        if (_targetExpandLevel>1.1) {
            _targetExpandLevel = 1.1;
        }
        if (_targetExpandLevel<1 && _isExpandInTableStatus) {
            _isExpandInTableStatus = false;
            _targetExpandLevel = .6;
            int distU = PAGEPART_WIDTH*.7;
            int rowWidth = distU*self.book.pages.count;
            for (int i=0; i<self.book.pages.count; i++) {
                _pagesPos[i].x  = i*distU - rowWidth*.5f;
                _pagesPos[i].y  = 0;
                _pagesPos[i].z  = 10;
            }
        }else if(_targetExpandLevel>.6 && !_isExpandInTableStatus){
            _isExpandInTableStatus = true;
            _targetExpandLevel = 1;
            [self resetPagesPosition];
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
    
    if (_selectedPage==Nil) {
        if (_targetExpandLevel>.6) {
            [self removePagesAndPagePartsTween];
            for (int i=0; i<self.book.pages.count; i++) {
                Page *page = [self.book.pages objectAtIndex:i];
                [Tween rotateYTo:page.partL duration:1 delay:0 y:0 ease:EASE_EXPO_OUT];
                [Tween rotateYTo:page.partR duration:1 delay:0 y:0 ease:EASE_EXPO_OUT];
                [Tween scaleTo:page duration:1 delay:0 x:.5 y:.5 z:.5 ease:EASE_EXPO_OUT];
            }
            if(!_isExpandInTableStatus){
                _isExpandInTableStatus = true;
                [self resetPagesPosition];
            }
        }else{
            _targetExpandLevel = 0;
            [self.book.shelf unselectBook];
        }
        
    }else{
        [self unselectPage];
    }
}

/******************************
 * select & unselect
 ******************************/

-(void)selectPage:(Page *)page{
    if (_selectedPage!=Nil) {
        return;
    }
    _selectedPage         = page;
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
    [Tween scaleTo:_selectedPage duration:1 delay:0 x:.5 y:.5 z:.5 ease:EASE_EXPO_OUT];
    _selectedPage = Nil;
}

/******************************
 * add & delete
 ******************************/

-(void)registNewAddedPage:(Page*)page{
    [self updateDragYBound];
    [Tween scaleTo:page duration:1 delay:0 x:.5 y:.5 z:.5 ease:EASE_EXPO_OUT];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(pageTouchClick:)
     name:TOUCH_CLICK
     object:page];
}
/******************************
 * render
 ******************************/

-(void)render:(BOOL)isUpdate{
    
    [super render:isUpdate];
    
    for (int i=0; i<self.book.pages.count; i++) {
        Page *page  = [self.book.pages objectAtIndex:i];
        if (page.y>800) {
            page.alpha  = (400.0-(page.y-800))/400;
        }else if(page.y<-800) {
            page.alpha  = (400.0+(800+page.y))/400;
        }else{
            page.alpha  = 1;
        }
    }
    
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
        float partRotation = _expandLevel<.5 ? 89 : (89*(1-_expandLevel)*2);
        if (partRotation<0) {
            partRotation = 0;
        }
        float scale = _expandLevel>1? .5:((1.0-_expandLevel)*.5+.5);
        
        for (int i=0; i<self.book.pages.count; i++) {
            Page *page  = [self.book.pages objectAtIndex:i];
            
            float targetX = _pagesPos[i].x *_expandLevel;
            float targetY;
            
            if (_isExpandInTableStatus) {
                targetY = (_dragY + _pagesPos[i].y)*_expandLevel;
            }else{
                targetY = _pagesPos[i].y*_expandLevel;
            }
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
        for (int i=0; i<self.book.pages.count; i++) {
            Page *page  = [self.book.pages objectAtIndex:i];
            if (_selectedPage!=page) {
                float targetY = _dragY + _pagesPos[i].y;
                page.x      += (_pagesPos[i].x-page.x)*.25;
                page.z      += (_pagesPos[i].z-page.z)*.25;
                
                page.y      += (targetY-page.y)*.25;
                
            }
        }
    }
    
    
}

@end
