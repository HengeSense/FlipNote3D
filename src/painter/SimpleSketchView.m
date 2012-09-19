//
//  SimpleSketchView.m
//  FlipBook3D
//
//  Created by huang xiang on 8/4/12.
//
//

#import "SimpleSketchView.h"
#import "ConstantValues.h"

@implementation SimpleSketchView

@synthesize drawImage = _drawImage;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _drawImage = [[UIImageView alloc] initWithFrame:frame];
        
        UIGraphicsBeginImageContext(frame.size);
        [_drawImage.image drawInRect:CGRectMake(0, 0, _drawImage.frame.size.width, _drawImage.frame.size.height)];

        [[UIColor whiteColor] set];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToMask(context, frame, _drawImage.image.CGImage);
        CGContextFillRect(context, frame);
        
        _drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [self addSubview:self.drawImage];
        mouseMoved = 0;
        
    }
    return self;
}




- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.scale <1) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:SKETCH_CLOSE
         object:self ];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //[myPath stroke];
}

#pragma mark - Touch Methods

BOOL mouseSwiped;
CGPoint lastPoint;
int mouseMoved;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    currentPoint.y -= 40;
    UIGraphicsBeginImageContext(self.frame.size);
    
    [_drawImage.image drawInRect:CGRectMake(0, 0, _drawImage.frame.size.width, _drawImage.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    _drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
    
    mouseMoved++;
    
    if (mouseMoved == 10) {
        mouseMoved = 0;
    }
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //Double click to clean the canvas
    UITouch *touch = [touches anyObject];
    if ([touch tapCount] == 2) {
        _drawImage.image = nil;
        return;
    }
    
    if(!mouseSwiped) {
        //if color == green
        UIGraphicsBeginImageContext(self.frame.size);
        [_drawImage.image drawInRect:CGRectMake(0, 0, _drawImage.frame.size.width, _drawImage.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 1.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        _drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
}





@end
