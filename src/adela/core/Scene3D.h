//
//  Scene3D.h
//  FlipNote3D
//
//  Created by xiang huang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectContainer3D.h"
#import "Camera3D.h"
#import "Background.h"
#import "ConstantValues.h"
#import "DirectionalLight.h"
#import "Adela3DGLVIew.h"

@interface Scene3D : NSObject{
    NSMutableArray *_children;
    Background *_background;
    
    UITouch *_touchDownTouch;
}

@property(readonly) NSArray *children;
-(void)addChild:(ObjectContainer3D*)child;
-(void)removeChild:(ObjectContainer3D *)child;
-(BOOL)hasChild:(ObjectContainer3D *)child;
-(ObjectContainer3D *)getChildAt:(NSUInteger)index;
-(NSUInteger)numChildren;

@property(readonly)float width;
@property(readonly)float height;
@property(readonly)float halfWidth;
@property(readonly)float halfHeight;

@property(nonatomic) BitmapTexture *backgroundTexture;
@property(readonly)Background *background;

@property Camera3D* camera;
@property(readonly)float aspect;
@property DirectionalLight* light;

-(id)initWithView:(Adela3DGLVIew*)view;
@property(readonly)Adela3DGLVIew *view;


@property(readonly)bool isTouchDown;
@property(readonly)GLKVector2 touchDownPosition;

-(void)updateMatrix;
-(void)render;
-(void)renderShadow;
-(void)dispose;

@property(readonly)CGPoint touchPosition;
-(void)sendTouchEvent:(NSSet *) touches event:(UIEvent *)event type:(NSString *)type;
@property(readonly)int numTouches;
-(void)cleanTouches;

-(void)clearRenderBuffers;

+(Scene3D*)instance;

@end

