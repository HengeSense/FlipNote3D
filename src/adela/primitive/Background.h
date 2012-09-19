//
//  Background.h
//  FlipNote3D
//
//  Created by xiang huang on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BitmapTexture.h"
#import "GLProgram.h"

@class Scene3D;
@interface Background : NSObject{
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _shadowVertexArray;
    GLuint _shadowVertexBuffer;
    GLuint _blurDiff;
}

@property (readonly) Scene3D *scene;
@property (readonly, nonatomic) GLProgram *program;
@property (readonly, nonatomic) GLProgram *shadowProgram;

@property (readonly, nonatomic) GLProgram *blurXProgram;
@property (readonly, nonatomic) GLProgram *blurYProgram;
@property (readonly, nonatomic) GLProgram *blurProgram;

@property (nonatomic) BitmapTexture *tex;
@property (readonly)GLuint shadowTex;
@property (readonly)GLuint shadowFboName;
@property (readonly)int shadowTexWidth;
@property (readonly)int shadowTexHeight;

@property (readonly)GLuint blurTex;
@property (readonly)GLuint blurTex2;
@property (readonly)GLuint blurFboName;
@property (readonly)GLuint blurFboName2;

@property (readonly)GLKMatrix4 shadowMtx;

@property(readonly)GLuint shadowDepthPos;
@property(readonly)GLuint shadowLightPositionPos;

-(id)initWithTexture:(BitmapTexture *)tex scene:(Scene3D *)scene;

-(void)renderBlur;
-(void)render;
-(void)dispose;

-(void)clearRenderBuffers;
@end
