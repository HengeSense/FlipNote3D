//
//  Page.m
//  FlipBook3D
//
//  Created by xiang huang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Page.h"
#import "Book.h"
#import "PageData.h"

@implementation Page

@synthesize book = _book;
@synthesize partL = _partL;
@synthesize partR = _partR;

@synthesize rotationYL = _rotationYL;
@synthesize rotationYR = _rotationYR;

@synthesize id = _id;

static BitmapTexture * _defaultTex;
+(void)initialize{
    _defaultTex = [[BitmapTexture alloc]initWithFileName:@"defaultPage.png" asynchronous:false] ;
}

-(id)initWithBook:(Book*)book{
    self = [super init];
    if(self){
        _texType = TEX_NONE;
        _book = book;
        _partL = [[PagePart alloc]initWidthPart:LEFT page:self];
        _partR = [[PagePart alloc]initWidthPart:RIGHT page:self];
        [self addChild:_partL];
        [self addChild:_partR];
        Rect hitRect;
        hitRect.top     =  PAGEPART_HALFHEIGHT;
        hitRect.bottom  = -PAGEPART_HALFHEIGHT;
        hitRect.left    = -PAGEPART_WIDTH;
        hitRect.right   = PAGEPART_WIDTH;
        self.hitTestRect    = hitRect;
    }
    return self;
}

@synthesize tex = _tex;

-(BitmapTexture *)tex{
    if (_tex && _tex.isLoaded) {
        return _tex;
    }else{
        return _defaultTex;
    }
}

-(void)loadTex{
    if (_texType == TEX_IMG) {
        return;
    }
    if (_tex) {
        [_tex dispose];
    }
    PageData *pd = [_book.data.pages objectAtIndex:_id];
    if (pd.img!=Nil) {
        _tex = [[BitmapTexture alloc]initWithFileName:pd.img asynchronous:true];
        _texType    = TEX_IMG;
    }
}

-(void)loadThumb{
    if (_texType == TEX_THUMB) {
        return;
    }
    if (_tex) {
        [_tex dispose];
    }
    PageData *pd = [_book.data.pages objectAtIndex:_id];
    if (pd.thumb!=Nil) {
        _tex = [[BitmapTexture alloc]initWithFileName:pd.thumb asynchronous:true];
        _texType    = TEX_THUMB;
    }
}

-(void)unloadTex{
    if(!_tex){
        return;
    }
    [_tex dispose];
    _tex = nil;
    _texType = TEX_NONE;
}

-(void)updateTexByFile:(NSString*)fileName type:(enum TexType)texType{
    _texType = texType;
    [self unloadTex];
    _tex = [[BitmapTexture alloc]initWithFileName:fileName asynchronous:true];
}

-(void)updateTexByCGImg:(CGImageRef)cgImg type:(enum TexType)texType{
    NSLog(@"update tex : %d",self.id);
    _texType = texType;
    [self unloadTex];
    _tex    = [[BitmapTexture alloc]initWithCGImage:cgImg];
}

-(void)dispose{
    [self unloadTex];
    [super dispose];
}
@end
