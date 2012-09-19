//
//  Tween.m
//  FlipBook3D
//
//  Created by xiang huang on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tween.h"
#import <sys/time.h>
#import "TweenMoveItem.h"
#import "TweenMoveXItem.h"
#import "TweenMoveYItem.h"
#import "TweenMoveZItem.h"
#import "TweenScaleItem.h"
#import "TweenScaleXItem.h"
#import "TweenScaleYItem.h"
#import "TweenScaleZItem.h"
#import "TweenRotateItem.h"
#import "TweenRotateXItem.h"
#import "TweenRotateYItem.h"
#import "TweenRotateZItem.h"
#import "TweenAlphaItem.h"
#import "TweenToItem.h"
#import "TweenMouseEnableItem.h"

static NSMutableArray *tweens;
static double initMillionSecond;

@implementation Tween


+(void)initialize{
    tweens = [[NSMutableArray alloc]init];
    struct timeval time;
    gettimeofday(&time, NULL);
    
    initMillionSecond = 0.000001 * time.tv_usec + time.tv_sec;
}

+(float)getCurrentTime{
    struct timeval time;
    gettimeofday(&time, NULL);
    float millis = 0.000001 * time.tv_usec + time.tv_sec - initMillionSecond;
    return millis;
}

+(void)killTweenOf:(ObjectContainer3D *)target{
    for (int i =0;i<tweens.count;i++) {
        TweenItem *item =[tweens objectAtIndex:i];
        if(item.target == target){
            [tweens removeObject:item];
            i--;
        }
    }
}

+(void)killTween:(TweenItem *)tween{
    [tweens removeObject:tween];
}


+(TweenItem*)to:(id)target
       duration:(float)durationTime
          delay:(float)delayTime
     valuePoint:(float*)valuePoint
    targetValue:(float)targetValue
           ease:(enum EaseType)ease{
    TweenToItem *tween = [[TweenToItem alloc]initWithTarget:target
                                                          start:[Tween getCurrentTime]
                                                       duration:durationTime
                                                          delay:delayTime ease:ease];
    tween.startValue    = *valuePoint;
    tween.valuePoint    = valuePoint;
    tween.targetValue   = targetValue;
    
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)moveTo:(ObjectContainer3D *)target
           duration:(float)durationTime
              delay:(float)delayTime
                  x:(float)targetX
                  y:(float)targetY
                  z:(float)targetZ
               ease:(enum EaseType)ease{
    
    TweenMoveItem *tween = [[TweenMoveItem alloc]initWithTarget:target
                                                          start:[Tween getCurrentTime]
                                                       duration:durationTime
                                                          delay:delayTime ease:ease];
    tween.startX    = target.x;
    tween.startY    = target.y;
    tween.startZ    = target.z;
    
    tween.targetX   = targetX;
    tween.targetY   = targetY;
    tween.targetZ   = targetZ;
    
    
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)moveXTo:(ObjectContainer3D *)target
            duration:(float)durationTime
               delay:(float)delayTime
                   x:(float)targetX
                ease:(enum EaseType)ease{
    TweenMoveXItem *tween = [[TweenMoveXItem alloc]initWithTarget:target
                                                          start:[Tween getCurrentTime]
                                                       duration:durationTime
                                                          delay:delayTime ease:ease];
    tween.startX    = target.x;
    tween.targetX   = targetX;
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)moveYTo:(ObjectContainer3D *)target
            duration:(float)durationTime
               delay:(float)delayTime
                   y:(float)targetY
                ease:(enum EaseType)ease{
    TweenMoveYItem *tween = [[TweenMoveYItem alloc]initWithTarget:target
                                                            start:[Tween getCurrentTime]
                                                         duration:durationTime
                                                            delay:delayTime ease:ease];
    tween.startY    = target.y;
    tween.targetY   = targetY;
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)moveZTo:(ObjectContainer3D *)target
            duration:(float)durationTime
               delay:(float)delayTime
                   z:(float)targetZ
                ease:(enum EaseType)ease{
    TweenMoveZItem *tween = [[TweenMoveZItem alloc]initWithTarget:target
                                                            start:[Tween getCurrentTime]
                                                         duration:durationTime
                                                            delay:delayTime ease:ease];
    tween.startZ    = target.z;
    tween.targetZ   = targetZ;
    [tweens addObject:tween];
    return tween;
}


+(TweenItem*)scaleTo:(ObjectContainer3D *)target
            duration:(float)durationTime
               delay:(float)delayTime
                   x:(float)targetX
                   y:(float)targetY
                   z:(float)targetZ
                ease:(enum EaseType)ease{
    TweenScaleItem *tween = [[TweenScaleItem alloc]initWithTarget:target
                                                          start:[Tween getCurrentTime]
                                                       duration:durationTime
                                                          delay:delayTime ease:ease];
    tween.startX    = target.scaleX;
    tween.startY    = target.scaleY;
    tween.startZ    = target.scaleZ;
    
    tween.targetX   = targetX;
    tween.targetY   = targetY;
    tween.targetZ   = targetZ;
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)scaleXTo:(ObjectContainer3D *)target
             duration:(float)durationTime
                delay:(float)delayTime
                    x:(float)targetX
                 ease:(enum EaseType)ease{
    TweenScaleXItem *tween = [[TweenScaleXItem alloc]initWithTarget:target
                                                                start:[Tween getCurrentTime]
                                                             duration:durationTime
                                                                delay:delayTime ease:ease];
    tween.startX    = target.scaleX;
    tween.targetX   = targetX;
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)scaleYTo:(ObjectContainer3D *)target
             duration:(float)durationTime
                delay:(float)delayTime
                    y:(float)targetY
                 ease:(enum EaseType)ease{
    TweenScaleYItem *tween = [[TweenScaleYItem alloc]initWithTarget:target
                                                              start:[Tween getCurrentTime]
                                                           duration:durationTime
                                                              delay:delayTime ease:ease];
    tween.startY    = target.scaleY;
    tween.targetY   = targetY;
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)scaleZTo:(ObjectContainer3D *)target
             duration:(float)durationTime
                delay:(float)delayTime
                    z:(float)targetZ
                 ease:(enum EaseType)ease{
    TweenScaleZItem *tween = [[TweenScaleZItem alloc]initWithTarget:target
                                                              start:[Tween getCurrentTime]
                                                           duration:durationTime
                                                              delay:delayTime ease:ease];
    tween.startZ    = target.scaleZ;
    tween.targetZ   = targetZ;
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)rotateTo:(ObjectContainer3D *)target
             duration:(float)durationTime
                delay:(float)delayTime
                    x:(float)targetX
                    y:(float)targetY
                    z:(float)targetZ
                 ease:(enum EaseType)ease{
    TweenRotateItem *tween = [[TweenRotateItem alloc]initWithTarget:target
                                                              start:[Tween getCurrentTime]
                                                           duration:durationTime
                                                              delay:delayTime ease:ease];
    tween.startX    = target.rotationX;
    tween.startY    = target.rotationY;
    tween.startZ    = target.rotationZ;
    
    tween.targetX   = targetX;
    tween.targetY   = targetY;
    tween.targetZ   = targetZ;
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)rotateXTo:(ObjectContainer3D *)target
              duration:(float)durationTime
                 delay:(float)delayTime
                     x:(float)targetX
                  ease:(enum EaseType)ease{
    TweenRotateXItem *tween = [[TweenRotateXItem alloc]initWithTarget:target
                                                              start:[Tween getCurrentTime]
                                                           duration:durationTime
                                                              delay:delayTime ease:ease];
    tween.startX    = target.rotationX;
    tween.targetX   = targetX;
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)rotateYTo:(ObjectContainer3D *)target
              duration:(float)durationTime
                 delay:(float)delayTime
                     y:(float)targetY
                  ease:(enum EaseType)ease{
    TweenRotateYItem *tween = [[TweenRotateYItem alloc]initWithTarget:target
                                                                start:[Tween getCurrentTime]
                                                             duration:durationTime
                                                                delay:delayTime ease:ease];
    tween.startY    = target.rotationY;
    tween.targetY   = targetY;
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)rotateZTo:(ObjectContainer3D *)target
              duration:(float)durationTime
                 delay:(float)delayTime
                     z:(float)targetZ
                  ease:(enum EaseType)ease{
    TweenRotateZItem *tween = [[TweenRotateZItem alloc]initWithTarget:target
                                                              start:[Tween getCurrentTime]
                                                           duration:durationTime
                                                              delay:delayTime ease:ease];
    tween.startZ    = target.rotationZ;
    tween.targetZ   = targetZ;
    [tweens addObject:tween];
    return tween;
}

+(TweenItem*)alphaTo:(ObjectContainer3D *)target
            duration:(float)durationTime
               delay:(float)delayTime
               alpha:(float)targetAlpha
                ease:(enum EaseType)ease{
    TweenAlphaItem *tween = [[TweenAlphaItem alloc]initWithTarget:target
                                                                start:[Tween getCurrentTime]
                                                             duration:durationTime
                                                                delay:delayTime ease:ease];
    tween.startAlpha    = target.alpha;
    tween.targetAlpha   = targetAlpha;
    [tweens addObject:tween];
    return tween;
}
+(TweenItem*)mouseEnableTo:(ObjectContainer3D *)target
               delay:(float)delayTime
               value:(BOOL)targetVal{
    TweenMouseEnableItem *tween = [[TweenMouseEnableItem alloc]initWithTarget:target
                                                            start:[Tween getCurrentTime]
                                                         duration:0
                                                            delay:delayTime ease:EASE_LINEAR];

    tween.targetVar   = targetVal;
    [tweens addObject:tween];
    return tween;
}

+(void)update{
    
    float millis = [self getCurrentTime];
    
    if(tweens.count>0){
        for (TweenItem *item in tweens) {
            [item update:millis];
        
        }
        for (int i =0;i<tweens.count;i++) {
            TweenItem *item =[tweens objectAtIndex:i];
            if(item.isComplete){
                [tweens removeObject:item];
                i--;
            }
        }
    }
}


@end
