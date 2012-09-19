//
//  TweenItem.h
//  FlipBook3D
//
//  Created by xiang huang on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ObjectContainer3D.h"

enum EaseType
{
    EASE_LINEAR,
    EASE_BACK_IN,
    EASE_BACK_OUT,
    EASE_BACK_IN_OUT,
    EASE_BOUNCE_IN,
    EASE_BOUNCE_OUT,
    EASE_BOUNCE_IN_OUT,
    EASE_CIRC_IN,
    EASE_CIRC_OUT,
    EASE_CIRC_IN_OUT,
    EASE_CUBIC_IN,
    EASE_CUBIC_OUT,
    EASE_CUBIC_IN_OUT,
    EASE_ELASTIC_IN,
    EASE_ELASTIC_OUT,
    EASE_ELASTIC_IN_OUT,
    EASE_EXPO_IN,
    EASE_EXPO_OUT,
    EASE_EXPO_IN_OUT,
    EASE_QUAD_IN,
    EASE_QUAD_OUT,
    EASE_QUAD_IN_OUT,
    EASE_QUART_IN,
    EASE_QUART_OUT,
    EASE_QUART_IN_OUT,
    EASE_QUINT_IN,
    EASE_QUINT_OUT,
    EASE_QUINT_IN_OUT,
    EASE_SINE_IN,
    EASE_SINE_OUT,
    EASE_SINE_IN_OUT
};


@interface TweenItem : NSObject{

    ObjectContainer3D *_target;
    
    float _durationTime;
    float _startTime;
    float _delayTime;
    float _delayRemainTime;
    BOOL _isComplete;
    
    float(*_easeFunc)(float,float,float,float);
}


@property(readonly)NSObject *target;
@property(readonly)float duration;
@property(readonly)float startTime;
@property(readonly)float delayTime;

@property(readonly)BOOL isComplete;



-(id)initWithTarget:(id)target
        start:(float)startTime
     duration:(float)durationTime
        delay:(float)delayTime
         ease:(enum EaseType)ease;

-(void)update:(float)time;
@end
