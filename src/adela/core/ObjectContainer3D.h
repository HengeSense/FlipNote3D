//
//  ObjectContainer3D.h
//  FlipNote3D
//
//  Created by xiang huang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Object3D.h"


@class Scene3D;
@class Camera3D;
@interface ObjectContainer3D : Object3D{

    NSMutableArray *_children;
    

    bool _isSceneTransformDirty;
    
    bool _isTouching;

    bool _isInverseSceneTrransformDirty;
    
    bool _isScenePositionDirty;
    
    GLKVector3 _scenePosition;
    GLKVector2 _screenDiff;
    
    bool _isprojTransformDirty;
    bool _isProjPositionDirty;
    
    UITouch *_touchDownTouch;
    
    float _sceneAlpha;
}


//parent children
@property(nonatomic)ObjectContainer3D *parent;
@property(readonly) NSArray *children;
@property(nonatomic)Scene3D *scene;
@property(readonly)float sceneAlpha;

-(void)addChild:(ObjectContainer3D *)child;
-(void)removeChild:(ObjectContainer3D *)child;
-(BOOL)hasChild:(ObjectContainer3D *)child;
-(ObjectContainer3D *)getChildAt:(NSUInteger)index;
@property(nonatomic,readonly)NSUInteger numChildren;


//scene transform
@property(readonly) GLKMatrix4 sceneTransform;
-(void)invalidateSceneTransform;
-(void)updateSceneTransform;

@property(readonly) GLKMatrix4 inverseSceneTransform;
-(GLKVector3)scenePosition;


//proj transform
@property(readonly) GLKMatrix4 projTransform;
@property(readonly) GLKMatrix4 inverseProjTransform;
-(void)updateProjTransform;

//model view transform
@property(readonly)GLKMatrix4 modelViewTransform;


//norm transform
@property(readonly) GLKMatrix3 normTransform;


//matrix
-(void)updateMatrix;

//hittest
-(BOOL)hitTestWithNearPoint:(GLKVector3)near
               diffFarPoint:(GLKVector3)diff
                  eventType:(NSString *)type
                      touch:(UITouch *)touch
               mouseEnabled:(BOOL)enabled;

@property(readonly)bool isTouching;
@property(readonly)bool isHitTestRect;

@property(readonly)GLKVector4 projectPosition;

-(void)setHitTestRect:(Rect)rect;
@property(nonatomic)Rect hitTestRect;


@property(nonatomic)float hitTestCircleRadius;

@property(readonly)bool isTouchDown;
@property(readonly)GLKVector2 touchDownPosition;
//render
@property(nonatomic)Camera3D *camera;
@property BOOL isCastShadow;
-(void)render;
-(void)renderShadow;

//dispose
-(void)dispose;

@end
