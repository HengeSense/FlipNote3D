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
#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "Canvas.h"

@interface MainUIViewController : UIViewController<UINavigationControllerDelegate>{
    UIPinchGestureRecognizer *_twoFingerPinch;
    UIPopoverController *_popoverSettings;
    BOOL _syncingInProgress;
}


@property (strong, nonatomic) FlipBookView *flipBookView;
@property (strong) SimpleSketchView *painterView;

@property (nonatomic, strong) Canvas *canvas;
@property (nonatomic, strong) UIView *menuItemBar;

+(MainUIViewController*)getInstance;
@end
