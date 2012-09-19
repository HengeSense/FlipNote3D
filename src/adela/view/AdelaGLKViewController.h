//
//  AdelaViewController.h
//  FlipNote3D
//
//  Created by hx on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <GLKit/GLKit.h>
#import "GLProgram.h"
#import "Scene3D.h"

@interface AdelaGLKViewController : GLKViewController{

    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    
}
@property (readonly,strong,nonatomic) EAGLContext *context;
@property (readonly,strong,nonatomic)  Scene3D *scene;


- (void)setupGL;
- (void)tearDownGL;
-(void)update;


@end
