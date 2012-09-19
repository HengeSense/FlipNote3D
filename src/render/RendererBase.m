//
//  RenderBase.m
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RendererBase.h"
#import "CalendarRenderer.h"
#import "FlipRenderer.h"
#import "TableRenderer.h"
#import "PageData.h"
#import "Book.h"
#import "Tween.h"

@implementation RendererBase


//book
@synthesize book        = _book;
-(id)initWithBook:(Book *)book{
    self = [super init];
    if(self){
        _book = book;
        _isRendering = YES;
    }
    return self;
}

//activate
@synthesize isActivate  = _isActivate;
-(void)activateFromStatus:(enum BookStatus)status{
    _isActivate	= YES;
    if(status==CLOSE){
        [self activateFromCloseStatus];
    }else if(status==OPEN_FLIP){
        [self activateFromFlipStatus];
    }else if(status==OPEN_TABLE){
        [self activateFromTableStatus];
    }else if(status==OPEN_CALENDAR){
        [self activateFromCalendarStatus];
    }
}



-(void)activateFromCloseStatus{
    NSLog(@"activateFromCloseStatus");
}

-(void)activateFromFlipStatus{
    NSLog(@"activateFromFlipStatus");
}

-(void)activateFromTableStatus{
    NSLog(@"activateFromTableStatus");
}

-(void)activateFromCalendarStatus{
    NSLog(@"activateFromCalendarStatus");
}

-(void)deactivate{
    [self removeTouchListner];
}
-(void)close{
    
}


-(void)setAnimatingFlagFalse{
    _isAnimating = false;
}

-(void)postComplete{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:RENDERER_CLOSE_COMPLETE
     object:self ];
}

-(void)addTouchListner{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(touchBeginHandler:)
     name:TOUCH_BEGIN
     object:self.book.scene];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(touchMoveHandler:)
     name:TOUCH_MOVE
     object:self.book.scene];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(touchEndHandler:)
     name:TOUCH_END
     object:self.book.scene];
}



-(void)removeTouchListner{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TOUCH_BEGIN object:self.book.scene];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TOUCH_MOVE object:self.book.scene];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:TOUCH_END object:self.book.scene];
}

-(void)touchBeginHandler: (NSNotification *) notification{
    if (_isPinchScaling || _selectedPage!=Nil) {
        return;
    }
    _lastTouchPosition = self.book.scene.touchPosition;
    _touchDownPosition.x = _lastTouchPosition.x;
    _touchDownPosition.y = _lastTouchPosition.y;
    _totalTouchMove.x = 0;
    _totalTouchMove.y = 0;
    _absTotalTouchMove.x = 0;
    _absTotalTouchMove.y = 0;
}

-(void)touchMoveHandler: (NSNotification *) notification{
    if (_isPinchScaling || _selectedPage!=Nil) {
        return;
    }
    _deltaTouchMove = CGPointMake(self.book.scene.touchPosition.x-_lastTouchPosition.x,
                                  self.book.scene.touchPosition.y-_lastTouchPosition.y);
    _totalTouchMove.x += _deltaTouchMove.x;
    _totalTouchMove.y += _deltaTouchMove.y;
    _absTotalTouchMove.x += abs(_totalTouchMove.x);
    _absTotalTouchMove.y += abs(_totalTouchMove.y);
    _lastTouchPosition = self.book.scene.touchPosition;    
}

-(void)touchEndHandler: (NSNotification *) notification{

}


//page tween control

-(void)removePagesTween{
    for (int i=0; i<_book.pages.count; i++) {
        Page *page = [_book.pages objectAtIndex:i];
        [Tween killTweenOf:page];
    }
}
-(void)removePagesAndPagePartsTween{
    for (int i=0; i<_book.pages.count; i++) {
        Page *page = [_book.pages objectAtIndex:i];
        [Tween killTweenOf:page];
        [Tween killTweenOf:page.partL];
        [Tween killTweenOf:page.partR];
    }
}
-(void)removeAllTweenOfThisBook{
    [Tween killTweenOf:_book];
    for (int i=0; i<_book.pages.count; i++) {
        Page *page = [_book.pages objectAtIndex:i];
        [Tween killTweenOf:page];
        [Tween killTweenOf:page.partL];
        [Tween killTweenOf:page.partR];
    }
}

//pages
@synthesize selectedPage= _selectedPage;
@synthesize focusedPage = _focusedPage;

@synthesize isSelectedPageFullScreen = _isSelectedPageFullScreen;


-(void)selectPage:(Page *) page{
}

-(void)unselectPage{
}

-(void)registNewAddedPage:(Page*)page{
}
-(void)unregistRemovedPage:(Page*)page{
}

-(void)postSelectPageFullScreenEvent{
    _isSelectedPageFullScreen = true;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PAGE_FULLSCREEN
     object:self.book.shelf ];
}
-(void)postSelectPageExitFullScreenEvent{
    _isSelectedPageFullScreen = false;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PAGE_EXIT_FULLSCREEN
     object:self.book.shelf];
}

//gesture
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer{
    if (_isSelectedPageFullScreen) {
        [self postSelectPageExitFullScreenEvent];
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _isPinchScaling = true;
        [self twoFingerPinchBegan:recognizer];
        
    }else if  (recognizer.state == UIGestureRecognizerStateChanged) {
        [self twoFingerPinchScale:recognizer];
    }else {
        _isPinchScaling = false;
        [self twoFingerPinchEnd:recognizer];
    }
}

-(void)twoFingerPinchBegan:(UIPinchGestureRecognizer *)recognizer {
    
}
-(void)twoFingerPinchScale:(UIPinchGestureRecognizer *)recognizer {
    
}
-(void)twoFingerPinchEnd:(UIPinchGestureRecognizer *)recognizer {
    
}

//render
@synthesize isRendering = _isRendering;
-(void)render:(BOOL)isUpdate{
}

//factory
+(RendererBase *)getRenderer:(enum BookStatus)status book:(Book*)book{
    if(status==OPEN_FLIP){
        return([[FlipRenderer alloc] initWithBook:book]);
    }else if(status==OPEN_TABLE){
        return ([[TableRenderer alloc] initWithBook:book]);
    }else if(status==OPEN_CALENDAR){
        return ([[CalendarRenderer alloc]initWithBook:book]);
    }
    return nil;
}



@end
