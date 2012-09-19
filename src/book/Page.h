//
//  Page.h
//  FlipBook3D
//
//  Created by xiang huang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectContainer3D.h"
#import "PagePart.h"
#import "BitmapTexture.h"

@class Book;
enum TexType{
    TEX_NONE,TEX_THUMB,TEX_IMG
};
@interface Page : ObjectContainer3D{
    enum TexType _texType;
    }

@property(readonly)PagePart * partL;
@property(readonly)PagePart * partR;
@property(readonly)Book * book;
@property(readonly)BitmapTexture * tex;

@property(nonatomic)float rotationYL;
@property(nonatomic)float rotationYR;

@property(nonatomic)int id;


-(id)initWithBook:(Book*)book;
-(void)loadTex;
-(void)unloadTex;
-(void)loadThumb;

-(void)updateTexByFile:(NSString*)fileName type:(enum TexType)texType;
-(void)updateTexByCGImg:(CGImageRef)cgImg type:(enum TexType)texType;
+(void)initialize;

@end
