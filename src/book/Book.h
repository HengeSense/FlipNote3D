//
//  Book.h
//  FlipBook3D
//
//  Created by xiang huang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectContainer3D.h"
#import "BookData.h"
#import "BookCover.h"
#import "BookShelf.h"
#import "RendererBase.h"
#import "Page.h"



@interface Book : ObjectContainer3D{
    BookCover *_cover;
    GLKVector3 _defaultPosInShelf;
    int id;
}

@property(readonly)BookData *data;
@property(nonatomic)int id;
@property(readonly)NSMutableArray *pages;
@property(readonly)BookCover *cover;
@property(nonatomic)GLKVector3 defaultPosInShelf;

@property(readonly)BookShelf *shelf;

@property(nonatomic)enum BookStatus status;

@property(readonly)RendererBase *renderer;


-(id)initWithData:(BookData *)data shelf:(BookShelf *) shelf;


-(void)deleteFocusedPage;
-(void)addAEmptyPage;


@end
