//
//  Cube.h
//  FlipNote3D
//
//  Created by xiang huang on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ObjectContainer3D.h"
#import "GLProgram.h"
#import "BitmapTexture.h"


@interface Cube : ObjectContainer3D{
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}
@property (readonly, nonatomic) GLProgram *program;
@property (readonly) BitmapTexture *tex;
-(void)setupBuffers;
@end
