//
//  RenderBase.h
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ConstantValues.h"

@class Book;
@class Page;

@interface RendererBase : NSObject{
    Page * _selectedPage;
    Page * _focusedPage;
    
    CGPoint _lastTouchPosition;
    CGPoint _touchDownPosition;
    CGPoint _deltaTouchMove;
    CGPoint _totalTouchMove;
    CGPoint _absTotalTouchMove;
    float _lastPinchScale;
    BOOL _isPinchScaling;
    
    BOOL _isSelectedPageFullScreen;
    BOOL _isAnimating;
}


//book
@property (readonly) Book* book;
-(id)initWithBook:(Book *)book;

//open and close
@property (readonly) BOOL isActivate;
-(void)activateFromStatus:(enum BookStatus)status;

-(void)close;
-(void)deactivate;
-(void)postComplete;

//page
@property(readonly)Page * selectedPage;
-(void)selectPage:(Page *) page;
-(void)unselectPage;

@property(readonly)BOOL isSelectedPageFullScreen;
//render
-(void)render:(BOOL)isUpdate;
@property(nonatomic)BOOL isRendering;

// flip and focus
@property(readonly)Page * focusedPage;

-(void)registNewAddedPage:(Page*)page;
-(void)unregistRemovedPage:(Page*)page;
-(void)postSelectPageFullScreenEvent;
-(void)postSelectPageExitFullScreenEvent;

//touch
-(void)addTouchListner;
-(void)removeTouchListner;
-(void)touchBeginHandler: (NSNotification *) notification;
-(void)touchMoveHandler: (NSNotification *) notification;
-(void)touchEndHandler: (NSNotification *) notification;

//gesture
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer;

-(void)twoFingerPinchBegan:(UIPinchGestureRecognizer *)recognizer;
-(void)twoFingerPinchScale:(UIPinchGestureRecognizer *)recognizer;
-(void)twoFingerPinchEnd:(UIPinchGestureRecognizer *)recognizer;

//tween control
-(void)removePagesTween;
-(void)removePagesAndPagePartsTween;
-(void)removeAllTweenOfThisBook;

//factory
+(RendererBase *)getRenderer:(enum BookStatus)status book:(Book*)book;

@end
