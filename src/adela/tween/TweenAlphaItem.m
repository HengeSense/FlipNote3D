//
//  TweenAlphaItem.m
//  FlipBook3D
//
//  Created by xiang huang on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweenAlphaItem.h"

@implementation TweenAlphaItem
@synthesize targetAlpha = _targetAlpha;
@synthesize startAlpha = _startAlpha;
@synthesize changeAlpha = _changeAlpha;


-(void)setTargetAlpha:(float)targetAlpha{
    _targetAlpha = targetAlpha;
    _changeAlpha = _targetAlpha-_startAlpha;
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
            _startAlpha = _target.alpha;
            _changeAlpha = _targetAlpha-_startAlpha;
        }
    }
    if (_delayRemainTime==0 && elapsedTime>_delayTime) {
        elapsedTime-=_delayTime;
        if (elapsedTime>_durationTime) {
            elapsedTime = _durationTime;
            _isComplete = true;
        }
        _target.alpha       = _easeFunc(elapsedTime,_startAlpha,_changeAlpha,_durationTime);
        //NSLog([NSString stringWithFormat:@"target alpha %f",_targetAlpha]);
    }
}


@end
