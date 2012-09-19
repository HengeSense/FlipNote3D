//
//  ProgramGenerator.h
//  FlipNote3D
//
//  Created by xiang huang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <GLKit/GLKit.h>




@interface GLProgram : NSObject{
    GLuint _vertShader;
    GLuint _fragShader;
}

@property(readonly) GLuint program;

@property(readonly) GLuint modelViewProjMtx;
@property(readonly)GLuint modelViewMtx;
@property(readonly)GLuint projectionMtx;
@property(readonly)GLuint shadowMtx;
@property(readonly) GLuint normalMtx;

@property(readonly) GLuint color;
@property(readonly) GLuint alpha;
@property(readonly) GLuint lightPosition;


-(id)initWithShader:(NSString*)vertexShader:(NSString*)fragmentShader;

-(void)bindPosition;
-(void)bindNormal;
-(void)bindTextCoord;
-(void)bindTextCoord0;
-(void)bindTextCoord1;

-(void)bindModelViewProjMtx;
-(void)bindModelViewMtx;
-(void)bindProjMtx;
-(void)bindNormalMtx;
-(void)bindShadowMtx;

-(void)bindColor;
-(void)bindAlpha;
-(void)bindLightPos;

-(BOOL)linking;

-(void)deleteShader;

- (BOOL)validateProgram:(GLuint)prog;

-(void)dispose;

+(void)initialize;
@end
