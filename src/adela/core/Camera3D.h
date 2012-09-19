//
//  Camera3D.h
//  FlipNote3D
//
//  Created by xiang huang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectContainer3D.h"

@interface Camera3D : ObjectContainer3D{
    bool _isPPTransformDirty;
    bool _isRenderTransformDirty;
}
@property(readonly)GLKMatrix4 ppTransform;
@property(readonly)GLKMatrix4 renderTransform;
@property(readonly)GLKMatrix4 inverseRenderTransform;
@property GLKVector2 ppCenter;

@property(readonly)BOOL isDirty;

@property(nonatomic)float fov;
@property(nonatomic)float far;
@property(nonatomic)float near;
@property(nonatomic)float aspect;

-(id)initWithFov:(float)fov Aspect:(float)aspect;


-(void)invalidatePPTransform;
-(void)updatePPTransform;

-(void)invalidateRenderTransform;
-(void)updateRenderTransform;
-(void)clear;
@end
