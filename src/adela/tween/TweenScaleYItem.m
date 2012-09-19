//
//  TweenScaleY.m
//  FlipBook3D
//
//  Created by xiang huang on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweenScaleYItem.h"

@implementation TweenScaleYItem

@synthesize startY = _startY;

@synthesize targetY = _targetY;

@synthesize changeY = _changeY;



-(void)setTargetY:(float)targetY{
    _targetY = targetY;
    _changeY = _targetY-_startY;
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
            _startY = _target.scaleY;
            _changeY = _targetY-_startY;
        }
    }
    if (_delayRemainTime==0 && elapsedTime>_delayTime) {
        elapsedTime-=_delayTime;
        if (elapsedTime>_durationTime) {
            elapsedTime = _durationTime;
            _isComplete = true;
        }
        _target.scaleY       = _easeFunc(elapsedTime,_startY,_changeY,_durationTime);
    }
}
@end
