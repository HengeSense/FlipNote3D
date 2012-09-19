//
//  Object3D.h
//  FlipNote3D
//
//  Created by xiang huang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>
#import "Math.h"




@interface Object3D : NSObject{
    
    bool _isTransformDirty;
    float _alpha;
}

@property(nonatomic)float alpha;
@property(nonatomic)bool visible;
@property(nonatomic)bool mouseEnabled;

@property(nonatomic)float x;
@property(nonatomic)float y;
@property(nonatomic)float z;

@property(nonatomic)float scaleX;
@property(nonatomic)float scaleY;
@property(nonatomic)float scaleZ;

@property(nonatomic)float rotationX;
@property(nonatomic)float rotationY;
@property(nonatomic)float rotationZ;

@property (readonly)GLKMatrix4 transform;
@property (nonatomic)GLKVector3 position;
@property (nonatomic)GLKVector3 rotation;
@property (nonatomic)GLKVector3 scale;
@property (nonatomic)GLKVector3 eulers;




-(void)invalidateTransform;
-(void)updateTransform;


@end
