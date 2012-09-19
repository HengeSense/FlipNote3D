//
//  BookCover.h
//  FlipBook3D
//
//  Created by xiang huang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectContainer3D.h"
#import "BitmapTexture.h"

@class Book;

@interface BookCover : ObjectContainer3D

@property(readonly)Book* book;
@property(readonly)BitmapTexture* tex;

+(void)initialize;


-(id)initWithBook:(Book *) book;
-(void)reloadCover;
-(void)setCoverImage:(UIImage *)img;

@end
