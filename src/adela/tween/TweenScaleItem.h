//
//  TweenScaleItem.h
//  FlipBook3D
//
//  Created by xiang huang on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweenItem.h"

@interface TweenScaleItem : TweenItem

@property(nonatomic)float startX;
@property(nonatomic)float startY;
@property(nonatomic)float startZ;

@property(nonatomic)float targetX;
@property(nonatomic)float targetY;
@property(nonatomic)float targetZ;

@property(nonatomic)float changeX;
@property(nonatomic)float changeY;
@property(nonatomic)float changeZ;

@end
