//
//  FlipBookView.m
//  FlipBook3D
//
//  Created by huang xiang on 8/4/12.
//
//

#import "FlipBookView.h"

@implementation FlipBookView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bookShelf = [[BookShelf alloc]initWithScene:_scene];
        [self buildBookTitle];
        [self buildBookPropertyEditor];
    }
    return self;
}


-(void)buildBookTitle{
    _bookTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(412, 120, 200, 40)];
    _bookTitleLabel.backgroundColor = [[UIColor alloc]initWithRed:1 green:1 blue:1 alpha:0];
    _bookTitleLabel.textColor     = [[UIColor alloc]initWithWhite:1 alpha:1];
    _bookTitleLabel.textAlignment = UITextAlignmentLeft;
    UIFont * titleFont = [UIFont fontWithName:@"Helvetica" size:40];
    _bookTitleLabel.font = titleFont;
    _bookTitleLabel.text = @"Journal";
    [self addSubview:_bookTitleLabel];
    
    _bookTitlePageNumLabel= [[UILabel alloc] initWithFrame:CGRectMake(412, 137, 200, 40)];
    _bookTitlePageNumLabel.backgroundColor = [[UIColor alloc]initWithRed:1 green:1 blue:1 alpha:0];
    _bookTitlePageNumLabel.textColor     = [[UIColor alloc]initWithWhite:1 alpha:.5];
    _bookTitlePageNumLabel.textAlignment = UITextAlignmentCenter;
    UIFont * numLabelFont = [UIFont fontWithName:@"Helvetica" size:20];
    _bookTitlePageNumLabel.font = numLabelFont;
    _bookTitlePageNumLabel.text = @"/ 25 pages";
    [self addSubview:_bookTitlePageNumLabel];
    [self updateBookTitleSize];
}

-(void)updateBookTitleSize{
    CGSize titleSize = [_bookTitleLabel.text sizeWithFont:_bookTitleLabel.font
                                   constrainedToSize:CGSizeMake(9999, 9999)
                                       lineBreakMode:_bookTitleLabel.lineBreakMode];
    
    CGSize numSize = [_bookTitlePageNumLabel.text sizeWithFont:_bookTitlePageNumLabel.font
                                        constrainedToSize:CGSizeMake(9999, 9999)
                                            lineBreakMode:_bookTitlePageNumLabel.lineBreakMode];
    float startX = 0.5 * (self.frame.size.width - titleSize.width - numSize.width-8);
    if (_bookShelf.isInEditMode) {
        startX-= 244;
    }
    CGRect titleFrame = CGRectMake( startX, _bookTitleLabel.frame.origin.y, titleSize.width, titleSize.height );
    _bookTitleLabel.frame = titleFrame;
    
    CGRect numLabelFrame = CGRectMake( startX+titleSize.width+6, _bookTitlePageNumLabel.frame.origin.y, numSize.width, numSize.height );
    _bookTitlePageNumLabel.frame = numLabelFrame;
    
}

-(void)setBookTitle:(NSString*)title{
    _bookTitleLabel.text = title;
    [self updateBookTitleSize];
}
-(void)setBookTitlePageNum:(int)pageNum{
    _bookTitlePageNumLabel.text = [NSString stringWithFormat:@"/ %d pages",pageNum ];
    [self updateBookTitleSize];
}

-(void)setBookTitle:(NSString*)title AndPageNum:(int)pageNum{
    _bookTitleLabel.text = title;
    _bookTitlePageNumLabel.text = [NSString stringWithFormat:@"/ %d pages",pageNum ];
    [self updateBookTitleSize];
}

-(void)bookTitleBlink{
    [_bookTitleLabel.layer removeAnimationForKey:@"opacity"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:NO];
    animation.duration          = .6;
    animation.fromValue         = [NSNumber numberWithFloat:0];
    animation.toValue           = [NSNumber numberWithFloat:1];
    [_bookTitleLabel.layer addAnimation:animation forKey:@"opacity"];
    _bookTitleLabel.layer.opacity = 1;
    [_bookTitlePageNumLabel.layer removeAnimationForKey:@"opacity"];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation2 setFillMode:kCAFillModeForwards];
    [animation2 setRemovedOnCompletion:NO];
    animation2.duration         = .6;
    animation2.fromValue        = [NSNumber numberWithFloat:0];
    animation2.toValue          = [NSNumber numberWithFloat:.5];
    [_bookTitlePageNumLabel.layer addAnimation:animation forKey:@"opacity"];
    _bookTitlePageNumLabel.layer.opacity = .5;
}

-(void)bookTitleHide{
    [_bookTitleLabel.layer removeAnimationForKey:@"opacity"];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:NO];
    animation.duration          = .6;
    animation.fromValue         = [NSNumber numberWithFloat:_bookTitleLabel.alpha];
    animation.toValue           = [NSNumber numberWithFloat:0];
    [_bookTitleLabel.layer addAnimation:animation forKey:@"opacity"];
     _bookTitleLabel.layer.opacity = 0;
    
    [_bookTitlePageNumLabel.layer removeAnimationForKey:@"opacity"];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation2 setFillMode:kCAFillModeForwards];
    [animation2 setRemovedOnCompletion:NO];
    animation2.duration         = .6;
    animation2.fromValue        = [NSNumber numberWithFloat:_bookTitleLabel.alpha];
    animation2.toValue          = [NSNumber numberWithFloat:0];
    [_bookTitlePageNumLabel.layer addAnimation:animation forKey:@"opacity"];
    _bookTitlePageNumLabel.layer.opacity = 0;
}

-(void)bookTitleShow{
    [_bookTitleLabel.layer removeAnimationForKey:@"opacity"];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFillMode:kCAFillModeForwards];
    [animation setRemovedOnCompletion:NO];
    animation.duration          = .6;
    animation.fromValue         = [NSNumber numberWithFloat:_bookTitleLabel.alpha];
    animation.toValue           = [NSNumber numberWithFloat:1];
    [_bookTitleLabel.layer addAnimation:animation forKey:@"opacity"];
     _bookTitleLabel.layer.opacity = 1;
    
    [_bookTitlePageNumLabel.layer removeAnimationForKey:@"opacity"];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation2 setFillMode:kCAFillModeForwards];
    [animation2 setRemovedOnCompletion:NO];
    animation2.duration         = .6;
    animation2.fromValue        = [NSNumber numberWithFloat:_bookTitleLabel.alpha];
    animation2.toValue          = [NSNumber numberWithFloat:.5];
    [_bookTitlePageNumLabel.layer addAnimation:animation forKey:@"opacity"];
    _bookTitlePageNumLabel.layer.opacity = .5;
}




-(void)moveLabelToShelfStatus{

    CGSize titleSize = [_bookTitleLabel.text sizeWithFont:_bookTitleLabel.font
                                        constrainedToSize:CGSizeMake(9999, 9999)
                                            lineBreakMode:_bookTitleLabel.lineBreakMode];
    
    CGSize numSize = [_bookTitlePageNumLabel.text sizeWithFont:_bookTitlePageNumLabel.font
                                             constrainedToSize:CGSizeMake(9999, 9999)
                                                 lineBreakMode:_bookTitlePageNumLabel.lineBreakMode];
    float startX = 0.5 * (self.frame.size.width - titleSize.width - numSize.width-8);

    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithControlPoints:0 :0 :.2 :1];
    
    
    [_bookTitleLabel.layer removeAnimationForKey:@"move"];
    CGPoint titlePos            = CGPointMake(startX+_bookTitleLabel.frame.size.width*.5, 143.5);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFillMode:kCAFillModeForwards];
    //[animation setRemovedOnCompletion:NO];
    animation.duration          = 1;
    
    animation.fromValue         = [NSValue valueWithCGPoint:_bookTitleLabel.center];
    animation.toValue           = [NSValue valueWithCGPoint:titlePos];
    [animation setTimingFunction:tf];
    [_bookTitleLabel.layer addAnimation:animation forKey:@"move"];
    _bookTitleLabel.layer.position = titlePos;
    
    [_bookTitlePageNumLabel.layer removeAnimationForKey:@"move"];
    CGPoint numPos              = CGPointMake(startX+_bookTitleLabel.frame.size.width+_bookTitlePageNumLabel.frame.size.width*.5+8, 149);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation2 setFillMode:kCAFillModeForwards];
    //[animation2 setRemovedOnCompletion:NO];
    animation2.duration         = 1;
    animation2.fromValue        = [NSValue valueWithCGPoint:_bookTitlePageNumLabel.center];
    animation2.toValue          = [NSValue valueWithCGPoint:numPos];
    [animation2 setTimingFunction:tf];
    [_bookTitlePageNumLabel.layer addAnimation:animation2 forKey:@"move"];
    _bookTitlePageNumLabel.layer.position = numPos;
}


-(void)moveLabelToFlipRenderStatus{

    CGSize titleSize = [_bookTitleLabel.text sizeWithFont:_bookTitleLabel.font
                                        constrainedToSize:CGSizeMake(9999, 9999)
                                            lineBreakMode:_bookTitleLabel.lineBreakMode];
    
    CGSize numSize = [_bookTitlePageNumLabel.text sizeWithFont:_bookTitlePageNumLabel.font
                                             constrainedToSize:CGSizeMake(9999, 9999)
                                                 lineBreakMode:_bookTitlePageNumLabel.lineBreakMode];
    float startX = 0.5 * (self.frame.size.width - titleSize.width - numSize.width-8);
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithControlPoints:0 :0 :.5 :1];

    [_bookTitleLabel.layer removeAnimationForKey:@"move"];
    CGPoint titlePos            = CGPointMake(startX+_bookTitleLabel.frame.size.width*.5, 70);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFillMode:kCAFillModeForwards];
    //[animation setRemovedOnCompletion:NO];
    animation.duration          = 1;
    
    animation.fromValue         = [NSValue valueWithCGPoint:_bookTitleLabel.center];
    animation.toValue           = [NSValue valueWithCGPoint:titlePos];
    [animation setTimingFunction:tf];
    [_bookTitleLabel.layer addAnimation:animation forKey:@"move"];
    _bookTitleLabel.layer.position = titlePos;
    
    [_bookTitlePageNumLabel.layer removeAnimationForKey:@"move"];
    CGPoint numPos              = CGPointMake(startX+_bookTitleLabel.frame.size.width+_bookTitlePageNumLabel.frame.size.width*.5+8, 78);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation2 setFillMode:kCAFillModeForwards];
    //[animation2 setRemovedOnCompletion:NO];
    animation2.duration         = 1;
    animation2.fromValue        = [NSValue valueWithCGPoint:_bookTitlePageNumLabel.center];
    animation2.toValue          = [NSValue valueWithCGPoint:numPos];
    [animation2 setTimingFunction:tf];
    [_bookTitlePageNumLabel.layer addAnimation:animation2 forKey:@"move"];
    _bookTitlePageNumLabel.layer.position = numPos;
}


-(void)moveLabelToTableRenderStatus{
    CGSize titleSize = [_bookTitleLabel.text sizeWithFont:_bookTitleLabel.font
                                        constrainedToSize:CGSizeMake(9999, 9999)
                                            lineBreakMode:_bookTitleLabel.lineBreakMode];
    
    CGSize numSize = [_bookTitlePageNumLabel.text sizeWithFont:_bookTitlePageNumLabel.font
                                             constrainedToSize:CGSizeMake(9999, 9999)
                                                 lineBreakMode:_bookTitlePageNumLabel.lineBreakMode];
    float startX = 0.5 * (self.frame.size.width - titleSize.width - numSize.width-8);
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithControlPoints:0 :0 :.5 :1];
    
    [_bookTitleLabel.layer removeAnimationForKey:@"move"];
    CGPoint titlePos            = CGPointMake(startX+_bookTitleLabel.frame.size.width*.5, 50);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFillMode:kCAFillModeForwards];
    //[animation setRemovedOnCompletion:NO];
    animation.duration          = 1;
    
    animation.fromValue         = [NSValue valueWithCGPoint:_bookTitleLabel.center];
    animation.toValue           = [NSValue valueWithCGPoint:titlePos];
    [animation setTimingFunction:tf];
    [_bookTitleLabel.layer addAnimation:animation forKey:@"move"];
    _bookTitleLabel.layer.position = titlePos;
    
    [_bookTitlePageNumLabel.layer removeAnimationForKey:@"move"];
    CGPoint numPos              = CGPointMake(startX+_bookTitleLabel.frame.size.width+_bookTitlePageNumLabel.frame.size.width*.5+8, 58);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation2 setFillMode:kCAFillModeForwards];
    //[animation2 setRemovedOnCompletion:NO];
    animation2.duration         = 1;
    animation2.fromValue        = [NSValue valueWithCGPoint:_bookTitlePageNumLabel.center];
    animation2.toValue          = [NSValue valueWithCGPoint:numPos];
    [animation2 setTimingFunction:tf];
    [_bookTitlePageNumLabel.layer addAnimation:animation2 forKey:@"move"];
    _bookTitlePageNumLabel.layer.position = numPos;
}


-(void)moveLabelToCalendarRenderStatus{
    CGSize titleSize = [_bookTitleLabel.text sizeWithFont:_bookTitleLabel.font
                                        constrainedToSize:CGSizeMake(9999, 9999)
                                            lineBreakMode:_bookTitleLabel.lineBreakMode];
    
    CGSize numSize = [_bookTitlePageNumLabel.text sizeWithFont:_bookTitlePageNumLabel.font
                                             constrainedToSize:CGSizeMake(9999, 9999)
                                                 lineBreakMode:_bookTitlePageNumLabel.lineBreakMode];
    float startX = 0.5 * (self.frame.size.width - titleSize.width - numSize.width-8);
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithControlPoints:0 :0 :.5 :1];
    
    [_bookTitleLabel.layer removeAnimationForKey:@"move"];
    CGPoint titlePos            = CGPointMake(startX+_bookTitleLabel.frame.size.width*.5, 30);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFillMode:kCAFillModeForwards];
    //[animation setRemovedOnCompletion:NO];
    animation.duration          = 1;
    
    animation.fromValue         = [NSValue valueWithCGPoint:_bookTitleLabel.center];
    animation.toValue           = [NSValue valueWithCGPoint:titlePos];
    [animation setTimingFunction:tf];
    [_bookTitleLabel.layer addAnimation:animation forKey:@"move"];
    _bookTitleLabel.layer.position = titlePos;
    
    [_bookTitlePageNumLabel.layer removeAnimationForKey:@"move"];
    CGPoint numPos              = CGPointMake(startX+_bookTitleLabel.frame.size.width+_bookTitlePageNumLabel.frame.size.width*.5+8, 38);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation2 setFillMode:kCAFillModeForwards];
    //[animation2 setRemovedOnCompletion:NO];
    animation2.duration         = 1;
    animation2.fromValue        = [NSValue valueWithCGPoint:_bookTitlePageNumLabel.center];
    animation2.toValue          = [NSValue valueWithCGPoint:numPos];
    [animation2 setTimingFunction:tf];
    [_bookTitlePageNumLabel.layer addAnimation:animation2 forKey:@"move"];
    _bookTitlePageNumLabel.layer.position = numPos;

}

-(void)moveLabelToBookEditStatus{
    CGSize titleSize = [_bookTitleLabel.text sizeWithFont:_bookTitleLabel.font
                                        constrainedToSize:CGSizeMake(9999, 9999)
                                            lineBreakMode:_bookTitleLabel.lineBreakMode];
    
    CGSize numSize = [_bookTitlePageNumLabel.text sizeWithFont:_bookTitlePageNumLabel.font
                                             constrainedToSize:CGSizeMake(9999, 9999)
                                                 lineBreakMode:_bookTitlePageNumLabel.lineBreakMode];
    float startX = 0.5 * (self.frame.size.width - titleSize.width - numSize.width-8)-244;
    
    CAMediaTimingFunction *tf = [CAMediaTimingFunction functionWithControlPoints:0 :0 :.5 :1];
    
    [_bookTitleLabel.layer removeAnimationForKey:@"move"];
    CGPoint titlePos            = CGPointMake(startX+_bookTitleLabel.frame.size.width*.5, 140);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFillMode:kCAFillModeForwards];
    //[animation setRemovedOnCompletion:NO];
    animation.duration          = .6;
    
    animation.fromValue         = [NSValue valueWithCGPoint:_bookTitleLabel.center];
    animation.toValue           = [NSValue valueWithCGPoint:titlePos];
    [animation setTimingFunction:tf];
    [_bookTitleLabel.layer addAnimation:animation forKey:@"move"];
    _bookTitleLabel.layer.position = titlePos;
    
    [_bookTitlePageNumLabel.layer removeAnimationForKey:@"move"];
    CGPoint numPos              = CGPointMake(startX+_bookTitleLabel.frame.size.width+_bookTitlePageNumLabel.frame.size.width*.5+8, 148);
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation2 setFillMode:kCAFillModeForwards];
    //[animation2 setRemovedOnCompletion:NO];
    animation2.duration         = .6;
    animation2.fromValue        = [NSValue valueWithCGPoint:_bookTitlePageNumLabel.center];
    animation2.toValue          = [NSValue valueWithCGPoint:numPos];
    [animation2 setTimingFunction:tf];
    [_bookTitlePageNumLabel.layer addAnimation:animation2 forKey:@"move"];
    _bookTitlePageNumLabel.layer.position = numPos;
}


-(void)buildBookPropertyEditor{
    _bookPropertyEditorController = [[BookPropertyEditorViewController alloc]initWithFlipBookView:self];
    [self addSubview:_bookPropertyEditorController.view];
}

-(void)showBookPropertyEditor{
    [_bookPropertyEditorController show];
}
-(void)hideBookPropertyEditor{
    [_bookPropertyEditorController hide];
}
- (void)render:(CADisplayLink*)displayLink{
    [_bookShelf update];
    [super render:displayLink];
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
