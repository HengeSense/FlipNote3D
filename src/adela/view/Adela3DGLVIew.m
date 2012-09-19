//
//  Adela3DGLVIew.m
//  FlipBook3D
//
//  Created by huang xiang on 7/29/12.
//
//

#import "Adela3DGLVIew.h"
#import "Scene3D.h"
#import "Tween.h"

@implementation Adela3DGLVIew


@synthesize context     = _context;
@synthesize shareGroup  = _shareGroup;
@synthesize bgContext   = _bgContext;
@synthesize eaglLayer   = _eaglLayer;
@synthesize scene       =_scene;
@synthesize isRetina    = _isRetina;
@synthesize pixelScaleFactor = _pixelScaleFactor;

@synthesize bufferWidth = _bufferWidth;
@synthesize bufferHeight= _bufferHeight;
+(Class)layerClass{
    return [CAEAGLLayer class];
}

static Adela3DGLVIew* _instance;
+(Adela3DGLVIew*)getinstance{
    return _instance;
}

- (id)initWithFrame:(CGRect)frame
{
    //NSLog([NSString stringWithFormat:@"%f,%f",frame.size.width, frame.size.height]);
    
    self = [super initWithFrame:frame];
    if (self) {
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
            _isRetina = YES;
            _pixelScaleFactor = [[UIScreen mainScreen] scale];
            if (_pixelScaleFactor>1.5) {
                //_pixelScaleFactor = 1.5;
            }
            self.contentScaleFactor = _pixelScaleFactor;
        } else {
            _isRetina = NO;
            _pixelScaleFactor = 1;
        }
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupScene];
        [self setupDisplayLink];
        _instance = self;
        glEnable(GL_DEPTH_TEST);
        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
        
    }
    return self;
}



-(void)setupLayer{
    _eaglLayer  = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque   = YES;
}

-(void)setupContext{
    //_shareGroup = [[EAGLSharegroup alloc]init];
    EAGLRenderingAPI api    = kEAGLRenderingAPIOpenGLES2;
    _context        = [[EAGLContext alloc] initWithAPI:api sharegroup:_shareGroup];
    _bgContext      = [[EAGLContext alloc] initWithAPI:api sharegroup:_context.sharegroup];
    [EAGLContext setCurrentContext:self.context];
}

- (void)setupRenderBuffer {
    /*glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, self.frame.size.width, self.frame.size.height);

    
    glGenRenderbuffers(1, &_colorBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];


    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);*/
    
    _msaaSample = 2;
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glGenRenderbuffers(1, &_colorBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorBuffer);
    

    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_bufferWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_bufferHeight);
    NSLog(@"render buffer size %d,%d",_bufferWidth,_bufferHeight);
    
    
    /*glGenRenderbuffers(1, &_depthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _depthBuffer);
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, _bufferWidth, _bufferHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _depthBuffer);*/
    
    
    glGenFramebuffers(1, &_msaaFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _msaaFrameBuffer);
    
    glGenRenderbuffers(1, &_msaaColorBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _msaaColorBuffer);
    glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, _msaaSample, GL_RGBA8_OES, _bufferWidth, _bufferHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _msaaColorBuffer);
    
    glGenRenderbuffers(1, &_msaaDepthBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _msaaDepthBuffer);
    glRenderbufferStorageMultisampleAPPLE(GL_RENDERBUFFER, _msaaSample, GL_DEPTH_COMPONENT16, _bufferWidth, _bufferHeight);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, _msaaDepthBuffer);
    
    
}

- (void)setupDisplayLink {
    CADisplayLink* displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(render:)];
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)setupScene
{
    [EAGLContext setCurrentContext:self.context];
    
    
    _scene  = [[Scene3D alloc]initWithView:(Adela3DGLVIew *)self];
    BitmapTexture *bgTex = [[BitmapTexture alloc]initWithFileName:@"bg.png" asynchronous:false];
    _scene.backgroundTexture = bgTex;
}

- (void)render:(CADisplayLink*)displayLink {
    [BitmapTexture doAsyncLoadJob];
    
    [Tween update];
    [_scene updateMatrix];
    [_scene cleanTouches];

    [_scene clearRenderBuffers];
    [_scene renderShadow];
    
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glClearColor(1.0, 1.0, 1.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glBindFramebuffer(GL_FRAMEBUFFER, _msaaFrameBuffer);
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);

    glViewport(0, 0, _bufferWidth, _bufferHeight);
    
    
    [_scene render];
    
    glBindFramebuffer(GL_DRAW_FRAMEBUFFER_APPLE, _frameBuffer);
    glBindFramebuffer(GL_READ_FRAMEBUFFER_APPLE, _msaaFrameBuffer);
    glResolveMultisampleFramebufferAPPLE();
    
    const GLenum discards[]  = {GL_COLOR_ATTACHMENT0,GL_DEPTH_ATTACHMENT};
    glDiscardFramebufferEXT(GL_READ_FRAMEBUFFER_APPLE,2,discards);
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBuffer);
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

-(void)bindMsaaBuffer{
    glBindFramebuffer(GL_FRAMEBUFFER, _msaaFrameBuffer);
}
-(void)bindFrameBuffer{
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [_scene sendTouchEvent:touches event:event type:TOUCH_BEGIN];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [_scene sendTouchEvent:touches event:event type:TOUCH_END];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    [_scene sendTouchEvent:touches event:event type:TOUCH_MOVE];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
