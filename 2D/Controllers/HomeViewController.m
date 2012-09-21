//
//  HomeViewController.m
//  FlipBook
//
//  Created by Lei Perry on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeViewController.h"
#import "UIColor+BitRice.h"
#import <QuartzCore/QuartzCore.h>
#import "FTAnimation.h"

@interface HomeViewController ()

- (void)iconPlusTapped:(UIButton *)button;
- (void)iconUserTapped:(UIButton *)button;
- (void)iconSyncTapped:(UIButton *)button;
- (void)iconSettingTapped:(UIButton *)button;

- (void)startSyncing:(UIButton *)button;
- (void)stopSyncing:(UIButton *)button;

@end

@implementation HomeViewController

@synthesize canvas;
@synthesize menuItemBar;

static UIPopoverController *_popoverAccount;

- (id)init
{
    if (self = [super init])
    {
        SettingsViewController *settingsController = [[SettingsViewController alloc] init];
        _popoverSettings = [[UIPopoverController alloc] initWithContentViewController:settingsController];
        [_popoverSettings setPopoverContentSize:settingsController.view.frame.size];
        
        LoginViewController *loginController = [[LoginViewController alloc] init];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginController];
        navController.delegate = self;
        _popoverAccount = [[UIPopoverController alloc] initWithContentViewController:navController];
        [_popoverAccount setPopoverContentSize:CGSizeMake(378, 289)];
    }
    return self;
}

- (void)iconUserTapped:(UIButton *)button
{
    [_popoverAccount presentPopoverFromRect:CGRectMake(880, 20, 30, 30)
                                      inView:self.view
                    permittedArrowDirections:UIPopoverArrowDirectionUp
                                    animated:YES];
}

- (void)iconSyncTapped:(UIButton *)button
{
    if (_syncingInProgress)
        [self stopSyncing:button];
    else
        [self startSyncing:button];
}

- (void)iconSettingTapped:(UIButton *)button
{
    [_popoverSettings presentPopoverFromRect:CGRectMake(1010, 20, 30, 30)
                                      inView:self.view
                    permittedArrowDirections:UIPopoverArrowDirectionUp
                                    animated:YES];
}

- (void)iconPlusTapped:(UIButton *)button
{
    if (self.canvas == nil)
    {
        self.canvas = [[Canvas alloc] init];
        self.canvas.frame = CGRectMake(0, 0, 1024, 748);
        self.canvas.backgroundColor = [UIColor greenColor];
        self.canvas.hidden = YES;
        [self.view insertSubview:self.canvas belowSubview:self.menuItemBar];
    }
    
    if (self.canvas.hidden)
    {
        [self.canvas popIn:.4 delegate:nil];
    }
    else
    {
        [self.canvas popOut:.4 delegate:nil];
    }
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor colorFromCode:0x333333 inAlpha:1.0f];

    self.menuItemBar = [[UIView alloc] initWithFrame:CGRectMake(825, 10, 199, 44)];
    self.menuItemBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.menuItemBar];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(50, 0, 44, 44);
    button.showsTouchWhenHighlighted = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"icon-user"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(iconUserTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuItemBar addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 0, 44, 44);
    button.showsTouchWhenHighlighted = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"icon-sync"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(iconSyncTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuItemBar addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(150, 0, 44, 44);
    button.showsTouchWhenHighlighted = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"icon-setting"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(iconSettingTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuItemBar addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    button.showsTouchWhenHighlighted = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"icon-plus"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(iconPlusTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.menuItemBar addSubview:button];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)startSyncing:(UIButton *)button
{
    _syncingInProgress = YES;
    
    button.alpha = .5f;
    
    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:M_PI * 360 / 180.0f];
    rotation.duration = 3.0f;
    rotation.repeatCount = HUGE_VALF;
    [button.layer addAnimation:rotation forKey:@"360"];
}

- (void)stopSyncing:(UIButton *)button
{
    [button.layer removeAnimationForKey:@"360"];
    
    button.alpha = 1.f;

    _syncingInProgress = NO;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    viewController.contentSizeForViewInPopover = CGSizeMake(378, 289);
}

@end