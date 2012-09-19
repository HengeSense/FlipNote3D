//
//  TweenItem.m
//  FlipBook3D
//
//  Created by xiang huang on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "TweenItem.h"
#import "Ease.h"

@implementation TweenItem

@synthesize target          =_target;
@synthesize duration        = _durationTime;
@synthesize startTime       = _startTime;
@synthesize isComplete      = _isComplete;
@synthesize delayTime       = _delayTime;


-(id)initWithTarget:(id)target
        start:(float)startTime
     duration:(float)durationTime
        delay:(float)delayTime
         ease:(enum EaseType)ease{
    self = [super init];
    if(self){
        _target      = target;
        _startTime   = startTime;
        _durationTime= durationTime;
        _delayRemainTime = delayTime;
        _delayTime   = delayTime;
        
        switch (ease) {
            case EASE_LINEAR:
                _easeFunc = & easeNone;
                break;
            
            case EASE_BACK_IN:
                _easeFunc = & easeInBack;
                break;
            case EASE_BACK_OUT:
                _easeFunc = & easeOutBack;
                break;
            case EASE_BACK_IN_OUT:
                _easeFunc = & easeInOutBack;
                break;
            
            case EASE_BOUNCE_IN:
                _easeFunc = & easeInBounce;
                break;
            case EASE_BOUNCE_OUT:
                _easeFunc = & easeOutBounce;
                break;
            case EASE_BOUNCE_IN_OUT:
                _easeFunc = & easeInOutBounce;
                break;
            
            case EASE_CUBIC_IN:
                _easeFunc = & easeInCubic;
                break;
            case EASE_CUBIC_OUT:
                _easeFunc = & easeOutCubic;
                break;
            case EASE_CUBIC_IN_OUT:
                _easeFunc = & easeInOutCubic;
                break;
                
            case EASE_CIRC_IN:
                _easeFunc = & easeInCirc;
                break;
            case EASE_CIRC_OUT:
                _easeFunc = & easeOutCirc;
                break;
            case EASE_CIRC_IN_OUT:
                _easeFunc = & easeInOutCirc;
                break;
            
            case EASE_ELASTIC_IN:
                _easeFunc = & easeInElastic;
                break;
            case EASE_ELASTIC_OUT:
                _easeFunc = & easeOutElastic;
                break;
            case EASE_ELASTIC_IN_OUT:
                _easeFunc = & easeInOutElastic;
                break;
            
            case EASE_EXPO_IN:
                _easeFunc = & easeInExpo;
                break;
            case EASE_EXPO_OUT:
                _easeFunc = & easeOutExpo;
                break;
            case EASE_EXPO_IN_OUT:
                _easeFunc = & easeInOutExpo;
                break;
            
            case EASE_QUAD_IN:
                _easeFunc = & easeInQuad;
                break;
            case EASE_QUAD_OUT:
                _easeFunc = & easeOutQuad;
                break;
            case EASE_QUAD_IN_OUT:
                _easeFunc = & easeInOutQuad;
                break;
             
            case EASE_QUART_IN:
                _easeFunc = & easeInQuart;
                break;
            case EASE_QUART_OUT:
                _easeFunc = & easeOutQuart;
                break;
            case EASE_QUART_IN_OUT:
                _easeFunc = & easeInOutQuart;
                break;
                
            case EASE_QUINT_IN:
                _easeFunc = & easeInQuint;
                break;
            case EASE_QUINT_OUT:
                _easeFunc = & easeOutQuint;
                break;
            case EASE_QUINT_IN_OUT:
                _easeFunc = & easeInOutQuint;
                break;
            
            case EASE_SINE_IN:
                _easeFunc = & easeInSine;
                break;
            case EASE_SINE_OUT:
                _easeFunc = & easeOutSine;
                break;
            case EASE_SINE_IN_OUT:
                _easeFunc = & easeInOutSine;
                break;
                
            default:
                _easeFunc = & easeNone;
                break;
        }
    }
    return self;
}


-(void)update:(float)time{
    //for (NSString *key in _keys) {
        /*NSString *setMethod = [@"set" stringByAppendingString:
        [key stringByReplacingCharactersInRange:NSMakeRange(0,1)  
            withString:[[key  substringToIndex:1] capitalizedString]]];
        
        NSLog(setMethod);
        SEL sel = NSSelectorFromString(setMethod);*/
        //[_target performSelector:sel withObject:@"123"];
        //objc_msgSend(_target,sel,@"123");
        
        //NSNumber * aFloat = [NSNumber numberWithFloat:42.0];
        
        //[_target setValue:aFloat forKey:key];
    //}
}

@end
