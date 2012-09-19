//
//  PageData.m
//  FlipBook3D
//
//  Created by huang xiang on 7/31/12.
//
//

#import "PageData.h"

@implementation PageData

@synthesize img = _img;
@synthesize date = _date;
@synthesize thumb = _thumb;

-(id)init{
    self = [super init];
    if (self) {
        //_img    = @"defaultPage.png";
    }
    return self;
}
@end
