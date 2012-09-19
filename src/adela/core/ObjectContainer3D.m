//
//  ObjectContainer3D.m
//  FlipNote3D
//
//  Created by xiang huang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectContainer3D.h"
#import "Scene3D.h"
@implementation ObjectContainer3D







-(ObjectContainer3D*)init
{
    self = [super init];
    if(self){
        _isSceneTransformDirty          = true;
        _isInverseSceneTrransformDirty  = true;
        _isScenePositionDirty           = true;
        _isProjPositionDirty            = true;
        _isprojTransformDirty           = true;
        
        _isHitTestRect                  = false;
        _isTouchDown                    = false;
        _isTouching                     = false;
        _hitTestCircleRadius            = 0;
        _isCastShadow                   = true;
        _screenDiff                     = GLKVector2Make(0, 0);
    }
    return self;
}


-(void)dispose{
    if(_children.count>0){
        for(ObjectContainer3D *obj in _children)
            [obj dispose];
    }
    
}

/*******************************
 *child add
 ******************************/

@synthesize parent = _parent;
@synthesize scene   = _scene;

-(void)addChild:(ObjectContainer3D *)child{
    if(!_children){ _children = [[NSMutableArray alloc]init];}
    [_children addObject:child];
    if(child.parent){
        [child.parent removeChild:child];
        child.scene =nil;
    }
    child.parent = self;
    child.scene = _scene;
    
}
-(void)removeChild:(ObjectContainer3D *)child{
    if(!_children){return;}
    [_children removeObject:child];
    child.parent = nil;
    child.scene =nil;
    [child invalidateSceneTransform];
}
-(BOOL)hasChild:(ObjectContainer3D *)child{
    if(!_children){return NO;}
    return [_children indexOfObject:child]!=-1;
}

-(ObjectContainer3D *)getChildAt:(NSUInteger)index{
    if(!_children){return nil;}
    return [_children objectAtIndex:index];
}

-(NSUInteger)numChildren{
    if(!_children){return 0;}
    return _children.count;
}

-(NSArray*)children{
    if(!_children){return nil;}
    return [NSArray arrayWithArray:_children]; 
}

-(void)setScene:(Scene3D *)scene{
    if(_scene == scene){return;}
    _scene = scene;
    if(_children && _children.count>0){
        for(ObjectContainer3D *obj in _children)
            obj.scene = scene;
    }
    [self invalidateSceneTransform];
}
/*******************************
 *parent
 ******************************/

-(ObjectContainer3D*)parent{
    return _parent;
}

-(void)setParent:(ObjectContainer3D *)parent{
    if(parent!=NULL){
        [_parent removeChild:self];
    }
    _parent = parent;
    [self invalidateSceneTransform];
}

/*******************************
 *parent
 ******************************/

@synthesize camera = _camera;
-(void)setCamera:(Camera3D *)camera{
    _camera = camera;
    if(_children && _children.count>0){
        for(ObjectContainer3D *obj in _children)
            obj.camera = camera;
    }

}
/*******************************
 *scene transform
 ******************************/

@synthesize sceneTransform          = _sceneTransform;
@synthesize inverseSceneTransform   =_inverseSceneTransform;
@synthesize sceneAlpha = _sceneAlpha;

-(GLKMatrix4)sceneTransform{
    if(_isScenePositionDirty)
        [self updateSceneTransform];
    return _sceneTransform;
}

-(void)invalidateTransform{
    [super invalidateTransform];
    [self invalidateSceneTransform];
}

-(void)invalidateSceneTransform{
    
    if (_isSceneTransformDirty)
        return;

    _isSceneTransformDirty          = true;
    _isInverseSceneTrransformDirty  = true;
    _isScenePositionDirty           = true;
    _isprojTransformDirty           = true;
    _isProjPositionDirty            = true;
    
    if(_children && _children.count>0){
        for(ObjectContainer3D *obj in _children)
            [obj invalidateSceneTransform];
    }
}

-(void)updateSceneTransform{
    if (_parent) {
        _sceneAlpha = _alpha*_parent.sceneAlpha;
    } else {
        _sceneAlpha = _alpha;
    }
    if(!_isSceneTransformDirty){return;}
    if (_parent) {
        _sceneTransform = GLKMatrix4Multiply(_parent.sceneTransform, self.transform);
        //_sceneTransform = GLKMatrix4MakeWithArray(self.transform.m);
    } else {
        _sceneTransform = GLKMatrix4MakeWithArray(self.transform.m);
    }
    _isSceneTransformDirty = false;
}

-(GLKMatrix4)inverseSceneTransform{
    if(_isInverseSceneTrransformDirty){
        bool isInverted;
        _inverseSceneTransform = GLKMatrix4Invert(_sceneTransform, &isInverted);
        _isInverseSceneTrransformDirty = false;
    }
    
    return _inverseSceneTransform;
}

-(GLKVector3)scenePosition{
    if (_isScenePositionDirty) {
        _scenePosition.x    = _sceneTransform.m[12];
        _scenePosition.y    = _sceneTransform.m[13];
        _scenePosition.z    = _sceneTransform.m[14];
        _isScenePositionDirty = false;
    }
    return _scenePosition;
}




/******************************************
 * proj transform
 *******************************************/

@synthesize projTransform       = _projTransform;
@synthesize inverseProjTransform= _inverseProjTransform;
@synthesize normTransform       = _normTransform;
@synthesize modelViewTransform  = _modelViewTransform;
@synthesize projectPosition     = _projectPosition;

-(GLKMatrix4)projTransform{
    if(_isProjPositionDirty)
        [self updateProjTransform];
    return _projTransform;
}
-(void)updateProjTransform{
    if(!_isprojTransformDirty && !_scene.camera.isDirty){
        return;
    }
    if (_camera==Nil) {
        _modelViewTransform     = GLKMatrix4Multiply(_scene.camera.inverseSceneTransform,_sceneTransform);
        _projTransform          = GLKMatrix4Multiply(_scene.camera.ppTransform,_modelViewTransform);
    }else{
        _modelViewTransform     = GLKMatrix4Multiply(_camera.inverseSceneTransform,_sceneTransform);
        _projTransform          = GLKMatrix4Multiply(_camera.ppTransform,_modelViewTransform);
    }
    _normTransform          = GLKMatrix3InvertAndTranspose(GLKMatrix4GetMatrix3(_modelViewTransform),NULL);
    _projectPosition        = GLKMatrix4MultiplyVector4(_sceneTransform,GLKVector4Make(0, 0, 0, 1.0));
    
    
    _isprojTransformDirty   = false;
}


/******************************************
 * update
 *******************************************/

-(void)updateMatrix{
    _isTouching = false;
    [self updateTransform];
    [self updateSceneTransform];
    [self updateProjTransform];
    
    if(_children && _children.count>0){
        for(ObjectContainer3D *obj in _children)
            [obj updateMatrix];
    }
}



/******************************************
 * render
 *******************************************/

@synthesize isCastShadow = _isCastShadow;

-(void)render{
    if(!self.visible){
        return;
    }
    if(_children && _children.count>0){
        for(ObjectContainer3D *obj in _children)
            [obj render];
    }
}

-(void)renderShadow{
    if(!self.visible || !_isCastShadow){
        return;
    }
    if(_children && _children.count>0){
        for(ObjectContainer3D *obj in _children)
            [obj renderShadow];
    }
}



/******************************************
 * hittest
 *******************************************/

@synthesize isHitTestRect       = _isHitTestRect;
@synthesize hitTestRect         = _hitTestRect;
@synthesize hitTestCircleRadius = _hitTestCircleRadius;
@synthesize isTouchDown         = _isTouchDown;
@synthesize touchDownPosition   = _touchDownPosition;
@synthesize isTouching          = _isTouching;

-(void)setHitTestRect:(Rect)rect{
    _isHitTestRect  = true;
    _hitTestRect    = rect;
}

-(void)setHitTestCircleRadius:(float)radius{
    _isHitTestRect      = false;
    _hitTestCircleRadius = radius;
}

-(bool)isTouching{
    if (_isTouching) {
        return _isTouching;
    }
    if(_children && _children.count>0){
        for(ObjectContainer3D *obj in _children)
            if (obj.isTouching) {
                return obj.isTouching;
            }
    }
    return false;
}

-(BOOL)hitTestWithNearPoint:(GLKVector3)near
               diffFarPoint:(GLKVector3)diff
                  eventType:(NSString *)type
                      touch:(UITouch *)touch
               mouseEnabled:(BOOL)enabled{

    
        
        float kz  = -_sceneTransform.m32/_scene.camera.far;
        
        GLKVector3 hitPoint = GLKVector3Make(0, 0, 0);

        hitPoint.x  = near.x  + kz * diff.x - _sceneTransform.m30 -_screenDiff.x;
        hitPoint.y  = near.y  + kz * diff.y - _sceneTransform.m31 -_screenDiff.y;
        hitPoint.z  = near.z  + kz * diff.z - _sceneTransform.m32;
        
        
        BOOL isHit = NO;
        if(_isHitTestRect){
            if (hitPoint.x>=_hitTestRect.left*self.scaleX && hitPoint.x<=_hitTestRect.right*self.scaleX &&
                hitPoint.y<=_hitTestRect.top*self.scaleY && hitPoint.y>=_hitTestRect.bottom*self.scaleY) {
                isHit = YES;
            }
        }else if(_hitTestCircleRadius>0){
            if (_hitTestCircleRadius>0 && GLKVector3Length(hitPoint)<_hitTestCircleRadius*(self.scaleX+self.scaleY)*.5) {
                isHit = YES;
            }
        }
        
        if(_children.count>0){
            for(ObjectContainer3D *obj in _children){
                if(obj!=_camera){
                    [obj hitTestWithNearPoint:near
                                 diffFarPoint:diff
                                    eventType:type
                                        touch:touch
                                 mouseEnabled:enabled && self.mouseEnabled];
                }
            }
        }
        if(isHit){
            _isTouching = true;
            NSDictionary *eventData = [[NSDictionary alloc]initWithObjectsAndKeys:touch,@"touch", nil];
            if (enabled && self.mouseEnabled) {
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:type
                 object:self
                 userInfo:eventData];
                if (type==TOUCH_BEGIN) {
                    if (_scene.numTouches==1) {
                        _touchDownTouch = touch;
                        _isTouchDown = true;
                        _touchDownPosition.x = _scene.touchPosition.x;
                        _touchDownPosition.y = _scene.touchPosition.y;
                    
                        [[NSNotificationCenter defaultCenter]
                         addObserver:self
                         selector:@selector(sceneTouchUp:)
                         name:TOUCH_END
                         object:_scene];
                    }
                
                }
            }
        }
    
    return NO;
}
-(BOOL)hitTestWithNearPoint:(GLKVector3)near
               diffFarPoint:(GLKVector3)diff{
    if (!self.mouseEnabled) {
        return NO;
    }
    float kz  = -_sceneTransform.m32/_scene.camera.far;
        
    GLKVector3 hitPoint = GLKVector3Make(0, 0, 0);
        
    hitPoint.x  = near.x  + kz * diff.x - _sceneTransform.m30 -_screenDiff.x;
    hitPoint.y  = near.y  + kz * diff.y - _sceneTransform.m31 -_screenDiff.y;
    hitPoint.z  = near.z  + kz * diff.z - _sceneTransform.m32;
    
    if(_isHitTestRect){
        if (hitPoint.x>=_hitTestRect.left*self.scaleX && hitPoint.x<=_hitTestRect.right*self.scaleX &&
            hitPoint.y<=_hitTestRect.top*self.scaleY && hitPoint.y>=_hitTestRect.bottom*self.scaleY) {
            return YES;
        }
    }else if(_hitTestCircleRadius>0){
        if (_hitTestCircleRadius>0 && GLKVector3Length(hitPoint)<_hitTestCircleRadius*(self.scaleX+self.scaleY)*.5) {
            return YES;
        }
    }
    return NO;
}

-(void)sceneTouchUp:(NSNotification *) notification{
    _isTouchDown = false;
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:TOUCH_END object:_scene];
    
    GLKVector2 deltaTouchMove = GLKVector2Make(_scene.touchPosition.x-_touchDownPosition.x,
                                  _scene.touchPosition.y-_touchDownPosition.y);
    
    if (abs(deltaTouchMove.x)<10 && abs(deltaTouchMove.y)<10) {
        NSDictionary *eventData = [[NSDictionary alloc]initWithObjectsAndKeys:_touchDownTouch,@"touch", nil];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:TOUCH_CLICK
         object:self
         userInfo:eventData];
    }
}


@end
