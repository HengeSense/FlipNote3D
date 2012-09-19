//
//  BookShelf.m
//  FlipBook3D
//
//  Created by xiang huang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BookShelf.h"
#import "Book.h"
#import "Tween.h"
#import "FlipBookView.h"
#import "PageData.h"

@implementation BookShelf



//scene
@synthesize scene = _scene;

-(id)initWithScene:(Scene3D*)scene{
    self = [super init];
    if (self) {
        _dragX      = 0;
        _distU      = 750;
        _isTouchDown = false;
        _isInEditMode = false;
        _scene      = scene;
        _scene.light.direction  = GLKVector3Make(.3, 0, -1);
        _books      = [[NSMutableArray alloc]init];
        _bottomBar  = [[BottomBar alloc]initWithShelf:self];
        [scene addChild:_bottomBar];
        [self addTouchListner];
    }
    return self;
}

/*******************************
 //bottombar
 ********************************/

@synthesize bottomBar = _bottomBar;


/*******************************
 //data
 ********************************/
@synthesize data = _data;

-(void)setData:(NSArray *)data{
    _data = data;
    [self initBooks];
}



/*******************************
 //books
 ********************************/

-(NSArray *)books{
    return [NSArray arrayWithArray:_books];
}

-(void)initBooks{

    NSLog(@"initBooks");
    
    //int rowWidth = distU*(row-1)+PAGEPART_WIDTH;
    
    for(int i =0;i<_data.count;i++){
        BookData *bookData = [_data objectAtIndex:i];
        Book *book = [[Book alloc]initWithData:bookData shelf:self];
        [[NSNotificationCenter defaultCenter]
            addObserver:self
               selector:@selector(bookTouchClick:)
                   name:TOUCH_CLICK
                 object:book];
        
        [_books addObject:book];
        [_scene addChild:book];
    }
    [self setupBooksOrigPosAndId];
    for(int i =0;i<_data.count;i++){
        Book *book = [_books objectAtIndex:i];
        book.x     = book.defaultPosInShelf.x;
        book.y     = book.defaultPosInShelf.y;
        book.z     = book.defaultPosInShelf.z;

    }
    [self updateDragXBound];
    [self focuseBook:[_books objectAtIndex:0]];
    
    val = 0;
}

-(void)setupBooksOrigPosAndId{
    for(int i =0;i<_books.count;i++){
        Book *book = [_books objectAtIndex:i];
        book.defaultPosInShelf = GLKVector3Make(i*_distU - PAGEPART_WIDTH*.5f,
                                            0,
                                            -2000);
        book.id         = i;
    }
}


-(void)bookTouchClick: (NSNotification *) notification{
    NSLog(@"book clicked");
    if (!_isInEditMode) {
        Book * book = notification.object;
    [self selectBook:book];
    }
}


//add book
-(void)addBook{
    BookData *bookData = [[BookData alloc]init];
    bookData.name   = @"notebook";
    NSMutableArray *pages = [[NSMutableArray alloc]init];
    
    for (int j=0; j<25; j++) {
        PageData *pd = [[PageData alloc]init];
        NSDate *date = [[NSDate alloc]init];
        pd.date = date;
        [pages addObject:pd];
    }
    bookData.pages = pages;
    Book *book      = [[Book alloc]initWithData:bookData shelf:self];
    book.position   = book.defaultPosInShelf;
    book.x          = -PAGEPART_WIDTH*.5;
    book.z          = -500;
    book.alpha      = 0;
    
    [Tween alphaTo:book duration:.6 delay:0 alpha:1 ease:EASE_LINEAR];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(bookTouchClick:)
     name:TOUCH_CLICK
     object:book];
    for (int i =0; i<_books.count; i++) {
        Book *bk   = [_books objectAtIndex:i];
        [_scene removeChild:bk];
    }
    [_books insertObject:book atIndex:_focusedBook.id+1];
    for (int i =0; i<_books.count; i++) {
        Book *bk   = [_books objectAtIndex:i];
        [_scene addChild:bk];
    }
    [self setupBooksOrigPosAndId];
    [self focuseBook:book];
    
}

-(void)deleteFocusedBook{
    _deletingBook = _focusedBook;
    _focusedBook  = Nil;
    [_books removeObject:_deletingBook];
    [Tween killTweenOf:_deletingBook];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:TOUCH_CLICK object:_deletingBook];
    [Tween moveTo:_deletingBook duration:.6 delay:0 x:-PAGEPART_WIDTH*.5 y:0 z:-1000 ease:EASE_EXPO_OUT];
    [Tween alphaTo:_deletingBook duration:.6 delay:0 alpha:0 ease:EASE_EXPO_OUT];
    [self performSelector:@selector(deleteFocusedBookCompleteHandler)  withObject:nil afterDelay:.3];
    [self setupBooksOrigPosAndId];
    if (_deletingBook.id>0) {
        [self focuseBook:[_books objectAtIndex:_deletingBook.id-1]];
    }

}

-(void)deleteFocusedBookCompleteHandler{
    [_scene removeChild:_deletingBook];
}



/*******************************
//focused book
********************************/

@synthesize focusedBook = _focusedBook;

-(void)focuseBook:(Book*)focusedBook{
    if (_focusedBook==focusedBook) {
        return;
    }
    _focusedBook = focusedBook;
    [(FlipBookView*)_scene.view setBookTitle:_focusedBook.data.name AndPageNum:_focusedBook.data.pages.count];
    //[(FlipBookView*)_scene.view bookTitleBlink];
    if (!_isTouchDown) {
        _dragX = -focusedBook.id * _distU;
    }
}



-(void)slideLeft{
    
}

-(void)slideRight{
    
}

-(void)updateDragXBound{
    if (_books.count>2) {
        _maxDragX = 0;
        Book* lastBook = [_books objectAtIndex:_books.count-1];
        _minDragX = -lastBook.x ;
    }else{
        _maxDragX = 0;
        _maxDragX = 0;
    }
}



/*******************************
edit book cover
 ********************************/
@synthesize isInEditMode = _isInEditMode;
-(void)editFocusedBook{
    if (_isInEditMode || _selectedBook!=Nil) {
        return;
    }
    _isInEditMode = true;
    for (Book * book in _books) {
        [Tween killTweenOf:book];
        if (_focusedBook!=book) {
            [Tween alphaTo:book duration:.6 delay:0 alpha:0 ease:EASE_LINEAR];
        }else{
            [Tween alphaTo:book duration:.6 delay:0 alpha:1 ease:EASE_LINEAR];
            [Tween moveTo:book duration:1 delay:0 x:-800 y:0 z:-1500 ease:EASE_EXPO_OUT];
        }
    }
    [(FlipBookView*)_scene.view moveLabelToBookEditStatus];
    [(FlipBookView*)_scene.view showBookPropertyEditor];
    [_bottomBar hide];
    
}

-(void)exitEdit{
    _isInEditMode = false;
    [(FlipBookView*)_scene.view moveLabelToShelfStatus];
    [(FlipBookView*)_scene.view hideBookPropertyEditor];
    for (Book * book in _books) {
        [Tween alphaTo:book duration:.6 delay:0 alpha:1 ease:EASE_LINEAR];
    }
    [_bottomBar show];
}
/*******************************
//move
********************************/

-(void)addTouchListner{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(touchBeginHandler:)
     name:TOUCH_BEGIN
     object:_scene];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(touchMoveHandler:)
     name:TOUCH_MOVE
     object:_scene];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(touchEndHandler:)
     name:TOUCH_END
     object:_scene];
}


-(void)touchBeginHandler: (NSNotification *) notification{
    if (_isInEditMode) {
        [self exitEdit];
    }
    if (_selectedBook!=Nil) {
        return;
    }
    _isTouchDown    = true;
    _lastTouchPosition.x = _scene.touchPosition.x;
    _lastTouchPosition.y = _scene.touchPosition.y;
    _touchDownPosition.x = _lastTouchPosition.x;
    _touchDownPosition.y = _lastTouchPosition.y;
}

-(void)touchMoveHandler: (NSNotification *) notification{
    if (_selectedBook!=Nil) {
        return;
    }
    if (_isInEditMode) {
        
    }else{
        float deltaX         = (_scene.touchPosition.x - _lastTouchPosition.x) * 2.5;
        _lastTouchPosition.x = _scene.touchPosition.x;
        _lastTouchPosition.y = _scene.touchPosition.y;
        _dragX              += deltaX;
    }
}

-(void)touchEndHandler: (NSNotification *) notification{
    _isTouchDown = false;
    
    if (_isInEditMode) {
        
    }else{
        if (_dragX>_maxDragX) {
            _dragX = _maxDragX;
        }else if(_dragX<_minDragX) {
            _dragX = _minDragX;
        }
        _dragX = -_focusedBook.id * _distU;
    }
}



/*******************************
 //select & unselect book
 ********************************/

@synthesize selectedBook = _selectedBook;

-(void)selectBook:(Book*)book{
    if(_selectedBook){return;}
    _selectedBook = book;
    
    
    
    if (_focusedBook!=book) {
        [self focuseBook:book];
        [self performSelector:@selector(selectBookDelayCall) withObject:Nil afterDelay:.4];
    }else{

        _selectedBook.status = OPEN_FLIP;
        for (Book * book in _books) {
            if (_selectedBook!=book) {
                [Tween alphaTo:book duration:1 delay:0 alpha:0 ease:EASE_LINEAR];
            }
        }
        [[NSNotificationCenter defaultCenter]
         postNotificationName:BOOK_OPEN
         object:self ];
        [(FlipBookView*)_scene.view moveLabelToFlipRenderStatus];
        [_bottomBar gotoFlipRenderStatus];
    }
}
-(void)selectBookDelayCall{
    _selectedBook.status = OPEN_FLIP;
    for (Book * book in _books) {
        if (_selectedBook!=book) {
            [Tween alphaTo:book duration:1 delay:0 alpha:0 ease:EASE_LINEAR];
        }
    }
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BOOK_OPEN
     object:self ];
    [(FlipBookView*)_scene.view moveLabelToFlipRenderStatus];
    [_bottomBar gotoFlipRenderStatus];
}

-(void)selectBookById:(int)bookId{
    
    [self selectBook:[_books objectAtIndex:bookId]];
    
}

-(int)getSelectedPageId{
    if (_selectedBook==Nil || _selectedBook.renderer==Nil || _selectedBook.renderer.selectedPage==Nil) {
        return -1;
    }
   
    return _selectedBook.renderer.selectedPage.id;
}

-(void)unselectBook{
    if(!_selectedBook){return;}
    _selectedBook.status = CLOSE;
    for (Book * book in _books) {
        if (_selectedBook!=book) {
            [Tween alphaTo:book duration:.6 delay:.3 alpha:1 ease:EASE_LINEAR];
        }
    }
    _selectedBook = nil;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:BOOK_CLOSE
     object:self ];
    
    [(FlipBookView*)_scene.view moveLabelToShelfStatus];
    [_bottomBar gotoShelfStatus];
}


-(void)selectedBookGotoFlipRender{
    _selectedBook.status = OPEN_FLIP;
    [(FlipBookView*)_scene.view moveLabelToFlipRenderStatus];
    [_bottomBar gotoFlipRenderStatus];
}

-(void)selectedBookGotoTableRender{
    _selectedBook.status = OPEN_TABLE;
    [(FlipBookView*)_scene.view moveLabelToTableRenderStatus];
    [_bottomBar gotoTableRenderStatus];
}
-(void)selectedBookGotoCalendarRender{
    _selectedBook.status = OPEN_CALENDAR;
    [(FlipBookView*)_scene.view moveLabelToCalendarRenderStatus];
    [_bottomBar gotoCalendarRenderStatus];
}



-(void)deleteSelectedPageInSelectedBook{
    if (_selectedBook) {
        [_selectedBook deleteFocusedPage];
    }
}

-(void)addAPageInSelectedBook{
    if (_selectedBook) {
        [_selectedBook addAEmptyPage];
    }
}


/*******************************
//outside interface
 ********************************/

-(void)setPageImgByFile:(NSString*)pageImgFileName bookId:(int)bookId pageId:(int)pageId{
    Book *book = [_books objectAtIndex:bookId];
    Page *page = [book.pages objectAtIndex:pageId];
    [page updateTexByFile:pageImgFileName type:TEX_IMG];
}

-(void)setPageImgByCGImg:(CGImageRef)cgImg bookId:(int)bookId pageId:(int)pageId{
    Book *book = [_books objectAtIndex:bookId];
    Page *page = [book.pages objectAtIndex:pageId];
    [page updateTexByCGImg:cgImg type:TEX_IMG];
}




/*******************************
 //gesture
 ********************************/

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer{
    if(_selectedBook){
        [_selectedBook.renderer twoFingerPinch:recognizer];
    }
}

-(void)update{
    
    if (_isInEditMode) {
        
    }else{
        for(int i =0;i<_books.count;i++){
            Book *book  = [_books objectAtIndex:i];
            if (book.status == CLOSE) {
                book.x += (book.defaultPosInShelf.x+_dragX-book.x)*.2;
                book.y += (book.defaultPosInShelf.y-book.y)*.2;
                if (book == _focusedBook) {
                    book.z += (book.defaultPosInShelf.z+350-book.z)*.2;
                }else{
                    book.z += (book.defaultPosInShelf.z-book.z)*.2;
                }
            }
        }
        int focusedBookId = floorf((-_dragX+_distU*.5)/_distU);
        if (focusedBookId<0) {
            focusedBookId = 0;
        }else if(focusedBookId>_books.count-1){
            focusedBookId = _books.count-1;
        }
    
        if(focusedBookId!=_focusedBook.id){
            [self focuseBook:[_books objectAtIndex:focusedBookId]];
        }
    }
}
@end
