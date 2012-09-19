//
//  BookShelf.h
//  FlipBook3D
//
//  Created by xiang huang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Scene3D.h"
#import "BookData.h"
#import "BottomBar.h"
@class Book;

@interface BookShelf : NSObject{
    NSMutableArray*_books;
    NSArray *_data;
    double val;
    
    float _maxDragX;
    float _minDragX;
    float _dragX;
    float _distU;
    
    bool _isTouchDown;
    bool _isInEditMode;
    CGPoint _lastTouchPosition;
    CGPoint _touchDownPosition;
    CGPoint _deltaTouchMove;
    
    Book *_deletingBook;
}

//scenes
@property(readonly)Scene3D *scene;
-(id)initWithScene:(Scene3D*)scene;

//data
@property(nonatomic)NSArray *data;

//books
@property(readonly)NSArray *books;
@property(readonly)Book *selectedBook;
@property(readonly)Book *focusedBook;
@property(readonly)bool isInEditMode;
-(void)addBook;
-(void)deleteFocusedBook;

//select
-(int)getSelectedPageId;
-(void)selectBookById:(int)bookId;
-(void)unselectBook;
-(void)deleteSelectedPageInSelectedBook;
-(void)addAPageInSelectedBook;
//focuse
-(void)focuseBook:(Book*)book;
-(void)slideLeft;
-(void)slideRight;

//edit
-(void)editFocusedBook;
-(void)exitEdit;

-(void)selectedBookGotoFlipRender;
-(void)selectedBookGotoTableRender;
-(void)selectedBookGotoCalendarRender;

//bottomBar
@property(readonly)BottomBar *bottomBar;

//outside interface
-(void)setPageImgByFile:(NSString*)pageImgFileName bookId:(int)bookId pageId:(int)pageId;
-(void)setPageImgByCGImg:(CGImageRef)cgImg bookId:(int)bookId pageId:(int)pageId;

//gesture
- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer;

//update
-(void)update;
@end
