//
//  UIColor-BitRice.m
//  FlipBook
//
//  Created by Lei Perry on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIColor+BitRice.h"

@implementation UIColor (BitRice)

+ (UIColor *)colorFromCode:(int)hexCode inAlpha:(float)alpha {
    float red   = ((hexCode >> 16) & 0x000000FF)/255.0f;
    float green = ((hexCode >> 8) & 0x000000FF)/255.0f;
    float blue  = ((hexCode) & 0x000000FF)/255.0f;
    return [UIColor colorWithRed:red
                           green:green
                            blue:blue
                           alpha:alpha];
}

@end