//
//  Camera3D.m
//  FlipNote3D
//
//  Created by xiang huang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Camera3D.h"

@implementation Camera3D

@synthesize ppTransform = _ppTransform;
@synthesize renderTransform = _renderTransform;
@synthesize isDirty = _isDirty;
@synthesize inverseRenderTransform = _inverseRenderTransform;
@synthesize fov = _fov;
@synthesize far = _far;
@synthesize near = _near;
@synthesize aspect = _aspect;
@synthesize ppCenter = _ppCenter;

-(void)setFov:(float)fov{
    _fov = fov*DEGREES_TO_RADIANS;
    [self invalidatePPTransform];
}
-(float)getFov{
    return _fov*RADIANS_TO_DEGREES;
}

-(void)setFar:(float)far{
    _far = far;
    [self invalidatePPTransform];
}

-(void)setNear:(float)near{
    _near = near;
    [self invalidatePPTransform];
}

-(void)setAspect:(float)aspect{
    _aspect = aspect;
    [self invalidatePPTransform];
}


-(id)initWithFov:(float)fov Aspect:(float)aspect{
    self = [super init];
    if(self){
        _fov    = fov;
        _aspect = aspect;
        _near   = 1;
        _far    = 2500;
        _isPPTransformDirty     = true;
        _isRenderTransformDirty = true;
        _ppCenter = GLKVector2Make(0, 0);
    }
    return self;
}

/*******************************
 *pp transform
 ******************************/

-(GLKMatrix4)getPpTransform{
    [self updatePPTransform];
    return _ppTransform;
}

-(void)invalidatePPTransform{
    _isPPTransformDirty = true;
    [self invalidateRenderTransform];
}

-(void)updatePPTransform{
    if(!_isPPTransformDirty){return;}
    

    GLfloat size = _near * tanf(_fov / 2.0);
    CGRect rect;
    rect.origin = CGPointMake(0.0, 0.0);
    rect.size = CGSizeMake(1024, 760);
    GLKVector2 ppc    = GLKVector2Make(size/1024 *_ppCenter.x, size/1024 *_ppCenter.y);
    
    _ppTransform      = GLKMatrix4MakeFrustum(-size+ppc.x , size+ppc.x , -size/_aspect+ppc.y , size/_aspect+ppc.y , _near, _far);


    _isPPTransformDirty= false;
    _isDirty = true;
}

-(void)setPpCenter:(GLKVector2)ppCenter{
    _ppCenter = ppCenter;
    _isPPTransformDirty     = true;
}

-(GLKVector2)ppCenter{
    return _ppCenter;
}
/*******************************
 *render transform
 ******************************/

-(GLKMatrix4)getRenderTransform{
    if(_isRenderTransformDirty){
        [self updateRenderTransform];
    }
    return _renderTransform;
}

-(void)invalidateRenderTransform{
    _isRenderTransformDirty = true;
}

-(void)updateRenderTransform{
    if(!_isRenderTransformDirty){return;}
    //NSLog(@"cam updateRenderTransform");
    bool isInvertible;
    GLKMatrix4 invertSceneTrans = GLKMatrix4Invert(self.sceneTransform, &isInvertible);
    _renderTransform = GLKMatrix4Multiply(invertSceneTrans, self.ppTransform);
    _inverseRenderTransform = GLKMatrix4Invert(_renderTransform, &isInvertible);
    _isRenderTransformDirty = false;
    _isDirty = true;
}

-(void)invalidateTransform{
    [super invalidateTransform];
    [self invalidatePPTransform];
}

-(void)invalidateSceneTransform{
    [super invalidateSceneTransform];
    [self invalidateRenderTransform];
}

-(void)updateMatrix{
    [self updateTransform];
    [self updateSceneTransform];
    [self updateProjTransform];
    [self updatePPTransform];
    [self updateRenderTransform];
}

-(void)clear{
    _isDirty = false;
}


@end
