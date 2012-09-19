//
//  Object3D.m
//  FlipNote3D
//
//  Created by xiang huang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Object3D.h"

@implementation Object3D

@synthesize visible = _visible;
@synthesize mouseEnabled = _mouseEnabled;

@synthesize x       = _x;
@synthesize y       = _y;
@synthesize z       = _z;
@synthesize rotationX = _rotationX;
@synthesize rotationY = _rotationY;
@synthesize rotationZ = _rotationZ;
@synthesize scaleX    = _scaleX;
@synthesize scaleY    = _scaleY;
@synthesize scaleZ    = _scaleZ;
@synthesize transform = _transform;

@synthesize position  = _position;
@synthesize scale   = _scale;
@synthesize eulers  = _eulers;
@synthesize rotation= _rotation;
@synthesize alpha = _alpha;

-(Object3D*)init
{
    self = [super init];
    if(self){
        _isTransformDirty = true;
        _x= 0;          _y=0;          _z=0;
        _rotationX=0;   _rotationY=0;  _rotationZ=0;
        _scaleX=1;      _scaleY=1;      _scaleZ=1;
        _visible        = true;
        _mouseEnabled   = true;
        _alpha          = 1;
    }
    return self;
}

-(float)x{
    return _x;
}
-(float)y{
    return _y;
}
-(float)z{
    return _z;
}
-(void)setX:(float)val{
    _x = val;
    [self invalidateTransform];
}
-(void)setY:(float)val{
    _y = val;
    [self invalidateTransform];
}
-(void)setZ:(float)val{
    _z = val;
    [self invalidateTransform];
}
-(void)setPosition:(GLKVector3)position{
    _x  = position.x;
    _y  = position.y;
    _z  = position.z;
    [self invalidateTransform];
}
-(GLKVector3)position{
    if(_isTransformDirty){
        _position.x = _x;
        _position.y = _y;
        _position.z = _z;
    }
    return _position;
}

-(float)scaleX{
    return _scaleX;
}
-(float)scaleY{
    return _scaleY;
}
-(float)scaleZ{
    return _scaleZ;
}

-(void)setScaleX:(float)val{
    _scaleX = val;
    [self invalidateTransform];
}

-(void)setScaleY:(float)val{
    _scaleY = val;
    [self invalidateTransform];
}

-(void)setScaleZ:(float)val{
    _scaleZ = val;
    [self invalidateTransform];
}

-(void)setScale:(GLKVector3)scale{
    _scaleX = scale.x;
    _scaleY = scale.y;
    _scaleZ = scale.z;
    [self invalidateTransform];
}
-(GLKVector3)scale{
    if(_isTransformDirty){
        _scale.x = _scaleX;
        _scale.y = _scaleY;
        _scale.z = _scaleZ;
    }
    return _scale;
}
-(float)rotationX{
    return _rotationX * RADIANS_TO_DEGREES;
}
-(float)rotationY{
    return _rotationY * RADIANS_TO_DEGREES;
}
-(float)rotationZ{
    return _rotationZ * RADIANS_TO_DEGREES;
}

-(void)setRotationX:(float)val{
    _rotationX = val * DEGREES_TO_RADIANS;
    [self invalidateTransform];
}

-(void)setRotationY:(float)val{
    _rotationY = val * DEGREES_TO_RADIANS;
    [self invalidateTransform];
}

-(void)setRotationZ:(float)val{
    _rotationZ = val * DEGREES_TO_RADIANS;
    [self invalidateTransform];
}

-(void)setRotation:(GLKVector3)rotation{
    _rotationX = rotation.x;
    _rotationY = rotation.y;
    _rotationZ = rotation.z;
    [self invalidateTransform];
}
-(GLKVector3)rotation{
    if(_isTransformDirty){
        _rotation.x = _rotationX;
        _rotation.y = _rotationY;
        _rotation.z = _rotationZ;
    }
    return _rotation;
}




-(GLKVector3)eulers{
    _eulers.x = _rotationX * RADIANS_TO_DEGREES;
    _eulers.y = _rotationY * RADIANS_TO_DEGREES;
    _eulers.z = _rotationZ * RADIANS_TO_DEGREES;
    return _eulers;
}

-(void)setEulers:(GLKVector3)eula{
    _rotationX = eula.x * DEGREES_TO_RADIANS;
    _rotationY = eula.y * DEGREES_TO_RADIANS;
    _rotationZ = eula.z * DEGREES_TO_RADIANS;
    [self invalidateTransform];
}

-(GLKMatrix4)transform{
    if (_isTransformDirty)
        [self updateTransform];
        return _transform;
}

-(void)invalidateTransform{
    _isTransformDirty = true;
}

-(void)updateTransform{
    if(!_isTransformDirty){return;}

    _position.x = _x;
    _position.y = _y;
    _position.z = _z;
    
    _rotation.x = _rotationX;
    _rotation.y = _rotationY;
    _rotation.z = _rotationZ;
    
    _scale.x = _scaleX;
    _scale.y = _scaleY;
    _scale.z = _scaleZ;

    GLKMatrix4 rotTransform = GLKMatrix4MakeXRotation(_rotationX);
    rotTransform    = GLKMatrix4Multiply(GLKMatrix4MakeYRotation(_rotationY), rotTransform);
    rotTransform    = GLKMatrix4Multiply(GLKMatrix4MakeZRotation(_rotationZ), rotTransform);
    
    GLKMatrix4 scaleTransform = GLKMatrix4MakeScale(_scaleX, _scaleY, _scaleY);
    
    GLKMatrix4 transTransform = GLKMatrix4MakeTranslation(_x, _y, _z);
    
    GLKMatrix4 tempTrans = GLKMatrix4Multiply(scaleTransform, rotTransform);
    _transform = GLKMatrix4Multiply(transTransform,tempTrans);
    
    _isTransformDirty = false;
}


@end
