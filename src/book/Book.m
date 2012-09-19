//
//  Book.m
//  FlipBook3D
//
//  Created by xiang huang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Book.h"
#import "PageData.h"
#import "FlipRenderer.h"
#import "TableRenderer.h"
#import "CalendarRenderer.h"
#import "FlipBookView.h"

@implementation Book

@synthesize data        = _data;
@synthesize id          = _id;
@synthesize pages       = _pages;
@synthesize cover       = _cover;
@synthesize shelf       = _shelf;

@synthesize status      = _status;
@synthesize renderer    = _renderer;
@synthesize defaultPosInShelf = _defaultPosInShelf;

-(id)initWithData:(BookData *)data shelf:(BookShelf *) shelf{
    self = [super init];
    if(self){
        
        _data   = data;
        _shelf  = shelf;
        _cover  = [[BookCover alloc]initWithBook:self];
        _cover.rotationY = -90;
        
        [self addChild:_cover];
        self.rotationY = 90;
        _status = CLOSE;
        Rect hitRect;
        hitRect.top     =  PAGEPART_HALFHEIGHT;
        hitRect.bottom  = -PAGEPART_HALFHEIGHT;
        hitRect.left    = 0;
        hitRect.right   = PAGEPART_WIDTH;
        self.hitTestRect    = hitRect;
        
    }
    return self;
    
}





-(void)setStatus:(enum BookStatus)status{
    if(status==CLOSE){
        if(_renderer!=Nil){
            [_renderer close];

            [[NSNotificationCenter defaultCenter]
                addObserver:self
                selector:@selector(rendererCompleteHandler:)
                name:RENDERER_CLOSE_COMPLETE
                object:_renderer];
        }
    }else{
        if(!_pages){
            [self initPages];
        }
        if(_renderer!=Nil){
            [[NSNotificationCenter defaultCenter] removeObserver:self name:RENDERER_CLOSE_COMPLETE object:_renderer];
            [_renderer deactivate];
        }
        RendererBase *newRender = [RendererBase getRenderer:status book:self];
        [newRender activateFromStatus:_status];
        _renderer = newRender;
    }
    _status = status;
}


-(void)rendererCompleteHandler: (NSNotification *) notification{
    [_renderer deactivate];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RENDERER_CLOSE_COMPLETE object:_renderer];
    _renderer = Nil;
    [self removePages];
}

-(void)initPages{
    if(!_pages){
        _pages  = [[NSMutableArray alloc]init];
    }
    for (int i =0; i<_data.pages.count; i++) {
        Page *page = [[Page alloc]initWithBook:self];
        page.id = i;
        [_pages addObject:page];
        [self addChild:page];
    }
}



-(void)removePages{
    for (int i =0; i<_pages.count; i++) {
        Page *page = [_pages objectAtIndex:i];
        [self removeChild:page];
        [page dispose];
    }
    [_pages removeAllObjects];
    _pages = Nil;
}

/******************************
 * page add and delete
 ******************************/

-(void)addAEmptyPage{
    PageData *pd = [[PageData alloc]init];
    pd.date = [[NSDate alloc]init];
    if (_status==OPEN_FLIP) {
        [_data.pages insertObject:pd atIndex:_renderer.focusedPage.id+1];
        [(FlipRenderer *)_renderer flipNextPage];
    }else{
        [_data.pages addObject:pd];
    }
    
    Page *page = [[Page alloc]initWithBook:self];
    [self addChild:page];
    
    if (_status==OPEN_FLIP) {
        [_pages insertObject:page atIndex:_renderer.focusedPage.id+1];
        for (int i =0; i<_data.pages.count; i++) {
            Page *page = [_pages objectAtIndex:i];
            page.id = i;
        }
    }else{
        page.id = _pages.count;
        [_pages addObject:page];
        if (_status==OPEN_TABLE) {
            [(TableRenderer*)_renderer resetPagesPosition];
        }else if(_status==OPEN_CALENDAR){
            [(CalendarRenderer*)_renderer resetPagesPosition];
        }
    }
    [_renderer registNewAddedPage:page];
    [(FlipBookView*)self.scene.view setBookTitle:_data.name AndPageNum:_data.pages.count];
    
}

-(void)deleteFocusedPage{
    if (_status==OPEN_FLIP && _pages.count>1) {
        Page* deletePage = [_pages objectAtIndex:_renderer.selectedPage.id];
        [_pages removeObjectAtIndex:_renderer.selectedPage.id];
        [_data.pages removeObjectAtIndex:_renderer.selectedPage.id];

        [_renderer unregistRemovedPage:deletePage];
        [self removeChild:deletePage];
        for (int i =0; i<_data.pages.count; i++) {
            Page *page = [_pages objectAtIndex:i];
            page.id = i;
        }
    }
    [(FlipBookView*)self.scene.view setBookTitle:_data.name AndPageNum:_data.pages.count];
}

/******************************
 * page add and delete
 ******************************/


-(void)updateMatrix{
    if(_renderer){
        [_renderer render:YES];
    }
    [super updateMatrix];
}

-(void)renderShadow{
    [super renderShadow];
}

-(void)render{
    [super render];
}

@end
