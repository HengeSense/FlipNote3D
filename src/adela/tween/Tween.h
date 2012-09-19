//
//  Tween.h
//  FlipBook3D
//
//  Created by xiang huang on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectContainer3D.h"
#import "TweenItem.h"

@interface Tween : NSObject{
    
}


+(void)initialize;


+(float)getCurrentTime;

+(void)killTweenOf:(ObjectContainer3D *)target;

+(TweenItem*)to:(id)target
           duration:(float)durationTime
              delay:(float)delayTime
         valuePoint:(float*)valuePoint
        targetValue:(float)targetValue
               ease:(enum EaseType)ease;

+(TweenItem*)moveTo:(ObjectContainer3D *)target
     duration:(float)durationTime
        delay:(float)delayTime
            x:(float)targetX
            y:(float)targetY
            z:(float)targetZ
         ease:(enum EaseType)ease;

+(TweenItem*)moveXTo:(ObjectContainer3D *)target
     duration:(float)durationTime
        delay:(float)delayTime
            x:(float)targetX
         ease:(enum EaseType)ease;

+(TweenItem*)moveYTo:(ObjectContainer3D *)target
      duration:(float)durationTime
        delay:(float)delayTime
             y:(float)targetY
         ease:(enum EaseType)ease;

+(TweenItem*)moveZTo:(ObjectContainer3D *)target
      duration:(float)durationTime
        delay:(float)delayTime
             z:(float)targetZ
         ease:(enum EaseType)ease;

+(TweenItem*)scaleTo:(ObjectContainer3D *)target
      duration:(float)durationTime
        delay:(float)delayTime
             x:(float)targetX
             y:(float)targetY
             z:(float)targetZ
          ease:(enum EaseType)ease;

+(TweenItem*)scaleXTo:(ObjectContainer3D *)target
      duration:(float)durationTime
        delay:(float)delayTime
             x:(float)targetX
           ease:(enum EaseType)ease;

+(TweenItem*)scaleYTo:(ObjectContainer3D *)target
      duration:(float)durationTime
        delay:(float)delayTime
             y:(float)targetY
           ease:(enum EaseType)ease;

+(TweenItem*)scaleZTo:(ObjectContainer3D *)target
       duration:(float)durationTime
        delay:(float)delayTime
              z:(float)targetZ
           ease:(enum EaseType)ease;

+(TweenItem*)rotateTo:(ObjectContainer3D *)target
      duration:(float)durationTime
         delay:(float)delayTime
             x:(float)targetX
             y:(float)targetY
             z:(float)targetZ
           ease:(enum EaseType)ease;

+(TweenItem*)rotateXTo:(ObjectContainer3D *)target
       duration:(float)durationTime
          delay:(float)delayTime
              x:(float)targetX
            ease:(enum EaseType)ease;

+(TweenItem*)rotateYTo:(ObjectContainer3D *)target
       duration:(float)durationTime
          delay:(float)delayTime
              y:(float)targetY
            ease:(enum EaseType)ease;

+(TweenItem*)rotateZTo:(ObjectContainer3D *)target
       duration:(float)durationTime
          delay:(float)delayTime
              z:(float)targetZ
            ease:(enum EaseType)ease;

+(TweenItem*)alphaTo:(ObjectContainer3D *)target
              duration:(float)durationTime
                 delay:(float)delayTime
                 alpha:(float)targetAlpha
                  ease:(enum EaseType)ease;

+(TweenItem*)mouseEnableTo:(ObjectContainer3D *)target
                     delay:(float)delayTime
                     value:(BOOL)targetVal;

+(void)killTweenOf:(ObjectContainer3D *)target;

+(void)update;

@end
