//
//  SettingsViewController.m
//  FlipBook
//
//  Created by Lei Perry on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize tglAutoSync;
@synthesize tglAutoLogin;

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

    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([pref objectForKey:@"auto_login"] != nil)
        self.tglAutoLogin.on = [pref boolForKey:@"auto_login"];
    if ([pref objectForKey:@"auto_sync"] != nil)
        self.tglAutoSync.on = [pref boolForKey:@"auto_sync"];
}

- (void)viewDidUnload
{
    [self setTglAutoSync:nil];
    [self setTglAutoLogin:nil];
    [super viewDidUnload];
}


- (IBAction)autoSyncChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:self.tglAutoSync.on forKey:@"auto_sync"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)autoLoginChanged:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:self.tglAutoLogin.on forKey:@"auto_login"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
