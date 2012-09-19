//
//  TweenRotationItem.m
//  FlipBook3D
//
//  Created by xiang huang on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweenRotateItem.h"

@implementation TweenRotateItem

@synthesize startX = _startX;
@synthesize startY = _startY;
@synthesize startZ = _startZ;

@synthesize targetX = _targetX;
@synthesize targetY = _targetY;
@synthesize targetZ = _targetZ;

@synthesize changeX = _changeX;
@synthesize changeY = _changeY;
@synthesize changeZ = _changeZ;


-(void)setTargetX:(float)targetX{
    _targetX = targetX;
    _changeX = _targetX-_startX;
}

-(void)setTargetY:(float)targetY{
    _targetY = targetY;
    _changeY = _targetY-_startY;
}

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
            _startX = _target.rotationX;
            _startY = _target.rotationY;
            _startZ = _target.rotationZ;
            _changeX = _targetX-_startX;
            _changeY = _targetY-_startY;
            _changeZ = _targetZ-_startZ;
        }
    }
    if (_delayRemainTime==0 && elapsedTime>_delayTime) {
        elapsedTime-=_delayTime;
        if (elapsedTime>_durationTime) {
            elapsedTime = _durationTime;
            _isComplete = true;
        }
        _target.rotationX       = _easeFunc(elapsedTime,_startX,_changeX,_durationTime);
        _target.rotationY       = _easeFunc(elapsedTime,_startY,_changeY,_durationTime);
        _target.rotationZ       = _easeFunc(elapsedTime,_startZ,_changeZ,_durationTime);
    }
}


@end
