//
//  MainUIViewController.h
//  FlipBook3D
//
//  Created by huang xiang on 7/31/12.
//
//

#import <UIKit/UIKit.h>
#import "FlipBookView.h"
#import "SimpleSketchView.h"
@interface MainUIViewController : UIViewController{
    UIPinchGestureRecognizer *_twoFingerPinch;
}


@property (strong, nonatomic) FlipBookView *flipBookView;
@property (strong) SimpleSketchView *painterView;

+(MainUIViewController*)getInstance;
@end
