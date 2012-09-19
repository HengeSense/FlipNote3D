//
//  BitmapTexture.h
//  FlipNote3D
//
//  Created by xiang huang on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <GLKit/GLKit.h>

@interface BitmapTexture : NSObject

//@property(readonly)GLKTextureInfo *texInfo;

@property(readonly)NSString *fileName;
@property(readonly)CGImageRef cgImg;

@property(readonly)int width;
@property(readonly)int height;
@property(readonly)int origWidth;
@property(readonly)int origHeight;

@property(readonly)BOOL isLoaded;
@property(readonly)GLuint texName;


-(id)initWithFileName:(NSString *)fileName asynchronous:(BOOL)async;
-(id)initWithCGImage:(CGImageRef)img;
-(void)dispose;


+(BOOL)isCGImageSizeValid:(CGImageRef)img;
+(BOOL)isDimensionValid:(int)d;
+(BOOL)isPowerOfTwo:(int)value;
+(int)getBestPowerOf2:(int)value;

+(void)doAsyncLoadJob;
@end
