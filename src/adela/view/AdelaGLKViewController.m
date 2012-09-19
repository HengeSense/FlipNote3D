//
//  AdelaViewController.m
//  FlipNote3D
//
//  Created by hx on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdelaGLKViewController.h"
#import "Tween.h"


// Uniform index.




@implementation AdelaGLKViewController

@synthesize context = _context;
@synthesize scene = _scene;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    GLKView *view                   = (GLKView *)self.view;
    view.context                    = self.context;
    view.drawableDepthFormat        = GLKViewDrawableDepthFormat24;
    view.drawableMultisample        = GLKViewDrawableMultisampleNone;

    [self setupGL];    
}

- (void)viewDidUnload
{    
    [super viewDidUnload];
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	_context = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);
    _scene  = [[Scene3D alloc]initWithGLKView:(GLKView *)self.view];
    BitmapTexture *bgTex = [[BitmapTexture alloc]initWithFileName:@"texture.jpg"];
    _scene.backgroundTexture = bgTex;
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    [self.scene dispose];
}




-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchBegan");

    [_scene sendTouchEvent:touches event:event type:TOUCH_BEGIN];
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesEnded");
    [_scene sendTouchEvent:touches event:event type:TOUCH_END];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesMoved");
    [_scene sendTouchEvent:touches event:event type:TOUCH_MOVE];
}
#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [Tween update];
    [_scene updateMatrix];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   
    [_scene render];
}


@end

