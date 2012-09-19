//
//  Scene3D.m
//  FlipNote3D
//
//  Created by xiang huang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Scene3D.h"
#import "DirectionalLight.h"

@implementation Scene3D


@synthesize aspect = _aspect;
@synthesize view = _view;

@synthesize width   = _width;
@synthesize height  = _height;
@synthesize halfWidth = _halfWidth;
@synthesize halfHeight= _halfHeight;
@synthesize backgroundTexture= _backgroundTexture;

@synthesize background = _background;

/*******************************
 *init
 ******************************/

static Scene3D *_instance;
/*-(id)init
{
    self = [super init];
    _children = [[NSMutableArray alloc]init];
    _aspect = 1;
    self.camera = [[Camera3D alloc]initWithFov:75*DEGREES_TO_RADIANS Aspect:_aspect];
    return self;
}*/
+(Scene3D*)instance{
    return _instance;
}

-(id)initWithView:(Adela3DGLVIew*)view{
    self = [super init];
    if (self) {
        _children = [[NSMutableArray alloc]init];
        _instance = self;
        _view = view;
        CGSize size = _view.bounds.size;
    
        _width  = size.width;
        _height = size.height;
        _halfWidth = size.width*.5f;
        _halfHeight = size.height*.5f;
        _aspect     = _width/_height;
        _numTouches = 0;
        self.camera = [[Camera3D alloc]initWithFov:75*DEGREES_TO_RADIANS Aspect:_aspect];
        _light      = [[DirectionalLight alloc]init];
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


-(void)addChild:(ObjectContainer3D *)child{
    
    [_children addObject:child];
    if(child.parent){
        [child.parent removeChild:child];
        child.scene = nil;
    }
    child.parent = nil;
    child.scene = self;
    [child invalidateSceneTransform];
}
-(void)removeChild:(ObjectContainer3D *)child{
    [_children removeObject:child];
    child.parent = nil;
    [child invalidateSceneTransform];
}
-(BOOL)hasChild:(ObjectContainer3D *)child{
    return [_children indexOfObject:child]!=-1;
}

-(ObjectContainer3D *)getChildAt:(NSUInteger)index{
    return [_children objectAtIndex:index];
}

-(NSUInteger)numChildren{
    return _children.count;
}

-(NSArray*)children{
    return [NSArray arrayWithArray:_children]; 
}


/*******************************
 *light
 ******************************/

@synthesize light = _light;


/*******************************
 *camera
 ******************************/
@synthesize camera = _camera;

-(void)setCamera:(Camera3D *)camera{
    if(_camera){
        [self removeChild:camera];
    }
    [self addChild:camera];
    _camera = camera;
}
-(Camera3D*)camera{
    return _camera;
}
/*******************************
 *background
 ******************************/

-(void)setBackgroundTexture:(BitmapTexture *)tex{
    if(!_background){
        _background = [[Background alloc]initWithTexture:tex scene:self];
    }else {
        _background.tex = tex;
    }
}


/*******************************
 *touch events
 ******************************/
@synthesize touchPosition = _touchPosition;
@synthesize numTouches  = _numTouches;
@synthesize isTouchDown = _isTouchDown;
@synthesize touchDownPosition = _touchDownPosition;
-(void)sendTouchEvent:(NSSet *) touches event:(UIEvent *)event type:(NSString *)type{
    
    _numTouches += touches.count;
    
    for (UITouch *touch in touches) {
        
    
        _touchPosition   = [touch locationInView: _view];
    
        GLKVector3 vec = GLKVector3Make(_touchPosition.x, _touchPosition.y,0);

        vec.x = vec.x/1024.0*2 - 1;
        vec.y = 1 - vec.y/768.0*2;
        vec.z = 0;
        // NSLog(NSStringFromGLKVector3(vec));
        GLKMatrix4 inverseProj  = GLKMatrix4Invert(_camera.ppTransform, NULL); 
        GLKVector3 unprojVec1   = GLKMatrix4MultiplyAndProjectVector3(inverseProj, vec);
    
        vec.z = 1;
        GLKVector3 unprojVec2 = GLKMatrix4MultiplyAndProjectVector3(inverseProj, vec);
    
    
        GLKVector3 diff = GLKVector3Make(0, 0, 0);
        diff.x = unprojVec2.x - unprojVec1.x;
        diff.y = unprojVec2.y - unprojVec1.y;
        diff.z = unprojVec2.z - unprojVec1.z;

        if(_children.count>0){
        
            for(ObjectContainer3D *obj in _children){
                if(obj!=_camera){
                    [obj hitTestWithNearPoint:unprojVec1 
                                 diffFarPoint:diff 
                                    eventType:type 
                                        touch:touch
                                 mouseEnabled:true];
                }
            }
        }
    
        [[NSNotificationCenter defaultCenter]
         postNotificationName:type
         object:self];
        
        if (type==TOUCH_BEGIN) {
            if (_numTouches==1) {
                _touchDownTouch = touch;
                _isTouchDown = true;
                _touchDownPosition.x = _touchPosition.x;
                _touchDownPosition.y = _touchPosition.y;
                
                [[NSNotificationCenter defaultCenter]
                 addObserver:self
                 selector:@selector(sceneTouchUp:)
                 name:TOUCH_END
                 object:self];
            }
            
        }
    }
}

-(void)sceneTouchUp:(NSNotification *) notification{
    _isTouchDown = false;
    [[NSNotificationCenter defaultCenter]
     removeObserver:self name:TOUCH_END object:self];
    
    GLKVector2 _deltaTouchMove = GLKVector2Make(_touchPosition.x-_touchDownPosition.x,
                                                _touchPosition.y-_touchDownPosition.y);
    
    if (abs(_deltaTouchMove.x)<10 && abs(_deltaTouchMove.y)<10) {
        NSDictionary *eventData = [[NSDictionary alloc]initWithObjectsAndKeys:_touchDownTouch,@"touch", nil];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:TOUCH_CLICK
         object:self
         userInfo:eventData];
    }
}

-(void)cleanTouches{
    _numTouches = 0;
}
/*******************************
 *render
 ******************************/

-(void)updateMatrix{
    if(_children.count>0){
        
        for(ObjectContainer3D *obj in _children){
            [obj updateMatrix];
        }
    }
    [_camera clear];
}

-(void)renderShadow{
    if(_background){
        glDisable(GL_DEPTH_TEST);
         glViewport(0, 0, _background.shadowTexWidth, _background.shadowTexHeight);
         
         glBindFramebuffer(GL_FRAMEBUFFER, _background.shadowFboName);
         
         glUseProgram(_background.shadowProgram.program);
         glUniformMatrix4fv(_background.shadowProgram.projectionMtx, 1, 0, _camera.ppTransform.m);
         glUniform3f(_background.shadowLightPositionPos, -50, 200, 0);
         glUniform1f(_background.shadowDepthPos, -2000);
         
         if(_children.count>0){
         for(ObjectContainer3D *obj in _children){
         [obj renderShadow];
         }
         }
        [_background renderBlur];
        glEnable(GL_DEPTH_TEST);
    }

}
-(void)render{
    
    
    [_view bindMsaaBuffer];

    if(_background)
        [_background render];

    //NSLog([NSString stringWithFormat:@"%d",_children.count]);
    if(_children.count>0){
        for(ObjectContainer3D *obj in _children){
            [obj render];
        }
    }
}

-(void)clearRenderBuffers{
    if(_background){
        [_background clearRenderBuffers];
    }
}

@end


