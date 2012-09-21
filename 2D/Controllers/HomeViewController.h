//
//  HomeViewController.h
//  FlipBook
//
//  Created by Lei Perry on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "Canvas.h"

@interface HomeViewController : UIViewController<UINavigationControllerDelegate>
{
    UIPopoverController *_popoverSettings;
    BOOL _syncingInProgress;
}

@property (nonatomic, strong) Canvas *canvas;
@property (nonatomic, strong) UIView *menuItemBar;

@end