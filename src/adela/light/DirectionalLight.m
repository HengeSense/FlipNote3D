//
//  PointLight.m
//  FlipBook3D
//
//  Created by xiang huang on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DirectionalLight.h"

@implementation DirectionalLight

@synthesize color = _color;
@synthesize direction = _direction;
-(id)init{
    self = [super init];
    _direction.z    = 1;
    return self;
}

@end
