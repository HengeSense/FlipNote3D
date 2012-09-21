//
//  ProfileViewController.h
//  FlipBook
//
//  Created by Lei Perry on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;

- (IBAction)logoutTapped:(id)sender;

@end