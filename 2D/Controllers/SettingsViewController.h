//
//  SettingsViewController.h
//  FlipBook
//
//  Created by Lei Perry on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISwitch *tglAutoSync;
@property (strong, nonatomic) IBOutlet UISwitch *tglAutoLogin;

- (IBAction)autoSyncChanged:(id)sender;
- (IBAction)autoLoginChanged:(id)sender;

@end