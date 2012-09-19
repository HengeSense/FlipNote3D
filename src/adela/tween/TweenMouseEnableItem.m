//
//  TweenMouseEnableItem.m
//  FlipBook3D
//
//  Created by huang xiang on 9/14/12.
//
//

#import "TweenMouseEnableItem.h"

@implementation TweenMouseEnableItem


@synthesize targetVar = _targetVar;
-(void)setTargetVar:(BOOL)targetVar{
    _targetVar = targetVar;
}



-(void)update:(float)time{
    float elapsedTime = time - _startTime;
    
    if (_delayRemainTime>0) {
        _delayRemainTime = _delayTime - elapsedTime;
        if (_delayRemainTime<0) {
            _delayRemainTime = 0;
        }

    }
    if (_delayRemainTime==0 && elapsedTime>_delayTime) {
        _isComplete                = true;
        _target.mouseEnabled       = _targetVar;
        
    }
}

@end
