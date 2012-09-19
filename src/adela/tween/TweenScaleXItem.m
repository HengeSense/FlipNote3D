//
//  TweenScaleXItem.m
//  FlipBook3D
//
//  Created by xiang huang on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweenScaleXItem.h"

@implementation TweenScaleXItem

@synthesize startX = _startX;

@synthesize targetX = _targetX;

@synthesize changeX = _changeX;



-(void)setTargetX:(float)targetX{
    _targetX = targetX;
    _changeX = _targetX-_startX;
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
    float elapsedTime = time - _startTime;
    
    if (_delayRemainTime>0) {
        _delayRemainTime = _delayTime - elapsedTime;
        if (_delayRemainTime<0) {
            elapsedTime += -_delayRemainTime;
            _delayRemainTime = 0;
        }
        if (_delayRemainTime==0) {
            _startX = _target.scaleX;
            _changeX = _targetX-_startX;
        }
    }
    if (_delayRemainTime==0 && elapsedTime>_delayTime) {
        elapsedTime-=_delayTime;
        if (elapsedTime>_durationTime) {
            elapsedTime = _durationTime;
            _isComplete = true;
        }
        _target.scaleX       = _easeFunc(elapsedTime,_startX,_changeX,_durationTime);
        
    }
}


@end
