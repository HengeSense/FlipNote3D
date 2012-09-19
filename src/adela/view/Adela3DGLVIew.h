//
//  Adela3DGLVIew.h
//  FlipBook3D
//
//  Created by huang xiang on 7/29/12.
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@class Scene3D;

@interface Adela3DGLVIew : UIView{
    CAEAGLLayer* _eaglLayer;
    EAGLContext* _context;
    EAGLContext*_bgContext;
    Scene3D* _scene;
    
    GLuint _depthBuffer;
    GLuint _colorBuffer;
    GLuint _frameBuffer;
    GLuint _msaaFrameBuffer;
    GLuint _msaaColorBuffer;
    GLuint _msaaDepthBuffer;
    int _msaaSample;
    
    GLuint _positionSlot;
    GLuint _colorSlot;
    GLuint _projectionUniform;
    GLuint _modelViewUniform;
    float _currentRotation;
    
}

@property(readonly)EAGLContext * context;
@property(readonly)EAGLContext * bgContext;
@property(readonly)EAGLSharegroup *shareGroup;
@property(readonly)CAEAGLLayer * eaglLayer;
@property(readonly)Scene3D *scene;
@property(readonly)BOOL isRetina;
@property(readonly)float pixelScaleFactor;

@property(readonly)GLint bufferWidth;
@property(readonly)GLint bufferHeight;

-(void)bindMsaaBuffer;
- (void)render:(CADisplayLink*)displayLink;

+(Adela3DGLVIew*)getinstance;
@end
