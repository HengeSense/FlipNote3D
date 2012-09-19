//
//  TweenToItem.m
//  FlipBook3D
//
//  Created by xiang huang on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweenToItem.h"

@implementation TweenToItem

@synthesize valuePoint = _valuePoint;
@synthesize startValue = _startValue;
@synthesize targetValue = _targetValue;
@synthesize changeValue = _changeValue;

-(void)setTargetValue:(float)targetValue{
    _targetValue = targetValue;
    _changeValue = _targetValue-_startValue;
}

-(void)update:(float)time{
    float elapsedTime = time-_startTime;
    
    if (_delayRemainTime>0) {
        _delayRemainTime = _delayTime-elapsedTime;
        if (_delayRemainTime<0) {
            elapsedTime += -_delayRemainTime;
            _delayRemainTime = 0;
        }
        if (_delayRemainTime==0) {
            _startValue = *_valuePoint;
            _changeValue = _targetValue-_startValue;
        }
    }
    if (_delayRemainTime==0 && elapsedTime>_delayTime) {
        elapsedTime-=_delayTime;
        //NSLog([NSString stringWithFormat:@"%f %f",elapsedTime,_durationTime]);
        if (elapsedTime>=_durationTime) {
            elapsedTime = _durationTime;
            _isComplete = true;
        }
        //NSLog(@"%f,%f",_startValue,*_valuePoint);
        *_valuePoint = _easeFunc(elapsedTime,_startValue,_changeValue,_durationTime);
    }
}


@end
