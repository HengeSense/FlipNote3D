//
//  SignupViewController.m
//  FlipBook
//
//  Created by Lei Perry on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SignupViewController.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+BitRice.h"
#import "Utilities.h"
#import "DataManager.h"
#import "ProfileViewController.h"


@interface SignupViewController ()

- (BOOL)checkEmail;
- (BOOL)checkPassword;

- (void)startWiggling:(UITextField *)control;
- (void)stopWiggling:(UITextField *)control;

@end

@implementation SignupViewController
@synthesize txtEmail;
@synthesize txtPassword;
@synthesize txtConfirmPassword;
@synthesize btnSignup;
@synthesize lblHaveAccount;
@synthesize lblEmail;
@synthesize lblPassword;

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
    
    self.txtEmail.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.txtPassword.secureTextEntry = self.txtConfirmPassword.secureTextEntry = YES;
    self.txtEmail.delegate = self.txtPassword.delegate = self.txtConfirmPassword.delegate = self;
    
    UIImage *txtBg = [[UIImage imageNamed:@"border-gray"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    self.txtEmail.background = txtBg;
    self.txtPassword.background = txtBg;
    self.txtConfirmPassword.background = txtBg;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.txtEmail.leftView = paddingView;
    self.txtEmail.leftViewMode = UITextFieldViewModeAlways;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.txtPassword.leftView = paddingView;
    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
    paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.txtConfirmPassword.leftView = paddingView;
    self.txtConfirmPassword.leftViewMode = UITextFieldViewModeAlways;
    
    self.lblHaveAccount.userInteractionEnabled = YES;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back2Login:)];
    [self.lblHaveAccount addGestureRecognizer:gesture];
    
    self.lblEmail.textColor = self.lblPassword.textColor = [UIColor colorFromCode:0xfbd54e inAlpha:1.0f];
}

- (void)viewDidUnload
{
    [self setTxtEmail:nil];
    [self setTxtPassword:nil];
    [self setTxtConfirmPassword:nil];
    [self setBtnSignup:nil];
    [self setLblHaveAccount:nil];
    [self setLblEmail:nil];
    [self setLblPassword:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)back2Login:(UIGestureRecognizer *)gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIImage *txtBg = [[UIImage imageNamed:@"border-green"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    textField.background = txtBg;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIImage *txtBg = [[UIImage imageNamed:@"border-gray"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    textField.background = txtBg;
}

- (IBAction)signupTapped:(id)sender
{
    if (![self checkEmail] || ![self checkPassword])
        return;
    
    // start network activity indicator
    [Utilities startNetworkActivity];
    
    NSString *theURL = [NSString stringWithFormat:@"http://www.bigthings.biz/easynote?m=signup&email=%@&password=%@&appid=%@",
                        self.txtEmail.text,
                        self.txtPassword.text,
                        [Utilities AppID]];
    NSLog(@"%@", theURL);
    NSURL *url = [NSURL URLWithString:theURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    dispatch_queue_t main_queue = dispatch_get_main_queue();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
        dispatch_sync(main_queue, ^{
            NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSDictionary *results = [jsonString objectFromJSONString];
            NSLog(@"%@", results);
            
            [Utilities stopNetworkActivity];
            if ([[results objectForKey:@"Status"] isEqual:@"OK"])
            {
                User *user = [[User alloc] init];
                user.email = self.txtEmail.text;
                user.password = self.txtPassword.text;
                user.sessionId = [results objectForKey:@"SessionId"];
                [DataManager sharedDataManager].currentUser = user;
                
                ProfileViewController *controller = [[ProfileViewController alloc] init];
                [self.navigationController pushViewController:controller animated:YES];
            }
            else
            {
                NSString *error = [results objectForKey:@"Desc"];
                error = [[error componentsSeparatedByString:@": "] objectAtIndex:1];
                
                UIImage *txtBg = [[UIImage imageNamed:@"border-yellow"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
                self.txtEmail.background = txtBg;
                self.lblEmail.text = NSLocalizedString(error, nil);
                
                [self startWiggling:self.txtEmail];
                [self performSelector:@selector(stopWiggling:) withObject:self.txtEmail afterDelay:1];
            }
        });
    });
}

- (BOOL)checkEmail
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL ret = [emailTest evaluateWithObject:self.txtEmail.text];
    if (!ret)
    {
        UIImage *txtBg = [[UIImage imageNamed:@"border-yellow"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        self.txtEmail.background = txtBg;
        self.lblEmail.text = NSLocalizedString(@"invalid email address", nil);
        
        [self startWiggling:self.txtEmail];
        [self performSelector:@selector(stopWiggling:) withObject:self.txtEmail afterDelay:1];
        
        return NO;
    }
    self.lblEmail.text = @"";
    return ret;
}

- (BOOL)checkPassword
{
    if ([self.txtPassword.text length] < 6)
    {
        UIImage *txtBg = [[UIImage imageNamed:@"border-yellow"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        self.txtPassword.background = txtBg;
        self.lblPassword.text = NSLocalizedString(@"password must be at least 6 characters", nil);
        
        [self startWiggling:self.txtPassword];
        [self performSelector:@selector(stopWiggling:) withObject:self.txtPassword afterDelay:1];

        return NO;
    }
    else if (![self.txtPassword.text isEqualToString:self.txtConfirmPassword.text])
    {
        UIImage *txtBg = [[UIImage imageNamed:@"border-yellow"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
        self.txtPassword.background = txtBg;
        self.txtConfirmPassword.background = txtBg;
        self.lblPassword.text = NSLocalizedString(@"mis-match passwords", nil);
        
        [self startWiggling:self.txtPassword];
        [self performSelector:@selector(stopWiggling:) withObject:self.txtPassword afterDelay:1];
        [self startWiggling:self.txtConfirmPassword];
        [self performSelector:@selector(stopWiggling:) withObject:self.txtConfirmPassword afterDelay:1];
        
        return NO;
    }
    self.lblPassword.text = @"";
    return YES;
}

- (void)startWiggling:(UITextField *)control
{
    // rotation
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-0.05f],
                   [NSNumber numberWithFloat:0.05f],
                   nil];
    anim.duration = 0.15f;
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    [control.layer addAnimation:anim forKey:@"wiggleRotation"];
    
    // translation
    anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    anim.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-1.0f],
                   [NSNumber numberWithFloat:1.0f],
                   nil];
    anim.duration = 0.09f;
    anim.autoreverses = YES;
    anim.repeatCount = HUGE_VALF;
    anim.additive = YES;
    [control.layer addAnimation:anim forKey:@"wiggleTranslationY"];
}


- (void)stopWiggling:(UITextField *)control
{
    [control.layer removeAnimationForKey:@"wiggleRotation"];
    [control.layer removeAnimationForKey:@"wiggleTranslationY"];
}

@end
