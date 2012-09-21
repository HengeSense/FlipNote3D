//
//  ProfileViewController.m
//  FlipBook
//
//  Created by Lei Perry on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileViewController.h"
#import "DataManager.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize lblEmail;
@synthesize btnLogout;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *bg = [[UIImage imageNamed:@"square-button"] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    [self.btnLogout setBackgroundImage:bg forState:UIControlStateNormal];
    
    self.lblEmail.text = [[DataManager sharedDataManager].currentUser email];
}

- (void)viewDidUnload
{
    [self setLblEmail:nil];
    [self setBtnLogout:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (IBAction)logoutTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end