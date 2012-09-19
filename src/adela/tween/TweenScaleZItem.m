//
//  TweenScaleZItem.m
//  FlipBook3D
//
//  Created by xiang huang on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweenScaleZItem.h"

@implementation TweenScaleZItem

@synthesize startZ = _startZ;

@synthesize targetZ = _targetZ;

@synthesize changeZ = _changeZ;



-(void)setTargetZ:(float)targetZ{
    _targetZ = targetZ;
    _changeZ = _targetZ-_startZ;
}
/**
 *
 *
 * @param t		Current time (in frames or seconds).
 * @param b		Starting value.
 * @param c		Change needed in value.
 * @param d		Expected easing duration (in frames or seconds).
 * @return		The correct value.
 */

-(void)update:(float)time{
    float elapsedTime = time-_startTime;
    
    if (_delayRemainTime>0) {
        _delayRemainTime = _delayTime-elapsedTime;
        if (_delayRemainTime<0) {
            elapsedTime += -_delayRemainTime;
            _delayRemainTime = 0;
        }
        if (_delayRemainTime==0) {
            _startZ = _target.scaleZ;
            _changeZ = _targetZ-_startZ;
        }
    }
    if (_delayRemainTime==0 && elapsedTime>_delayTime) {
        elapsedTime-=_delayTime;
        if (elapsedTime>_durationTime) {
            elapsedTime = _durationTime;
            _isComplete = true;
        }
        _target.scaleZ       = _easeFunc(elapsedTime,_startZ,_changeZ,_durationTime);
    }
}


@end
