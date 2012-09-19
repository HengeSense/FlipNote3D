//
//  SimpleSketchView.h
//  FlipBook3D
//
//  Created by huang xiang on 8/4/12.
//
//

#import <UIKit/UIKit.h>

@interface SimpleSketchView : UIView{

    
}
@property(readonly) UIImageView * drawImage;


- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer;


@end
