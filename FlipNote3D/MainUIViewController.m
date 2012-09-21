//
//  MainUIViewController.m
//  FlipBook3D
//
//  Created by huang xiang on 7/31/12.
//
//

#import "MainUIViewController.h"
#import "Book.h"
#import "RendererBase.h"
#import "PageData.h"
#import "FTAnimation.h"
#import "UIColor+BitRice.h"
#import <QuartzCore/QuartzCore.h>

@interface MainUIViewController ()

- (void)iconUserTapped:(UIButton *)button;
- (void)iconSyncTapped:(UIButton *)button;
- (void)iconSettingTapped:(UIButton *)button;

- (void)startSyncing:(UIButton *)button;
- (void)stopSyncing:(UIButton *)button;

@end

@implementation MainUIViewController

@synthesize flipBookView = _flipBookView;
@synthesize painterView = _painterView;
@synthesize canvas = _canvas;
@synthesize menuItemBar = _menuItemBar;

static UIPopoverController *_popoverAccount;

MainUIViewController * _instance;
+(MainUIViewController *)getInstance{
    return _instance;
}

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

-(void)loadView{
    [super loadView];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    _instance   = self;
    CGRect landscapeBounds  = [UIScreen mainScreen].bounds;
    
    landscapeBounds.origin.x = 0;
    landscapeBounds.origin.y = 0;
    if (landscapeBounds.size.width<landscapeBounds.size.height){
        CGFloat temp = landscapeBounds.size.height;
        landscapeBounds.size.height = landscapeBounds.size.width;
        landscapeBounds.size.width  = temp;
    }

	_flipBookView = [[FlipBookView alloc]initWithFrame:landscapeBounds];
    [self.view insertSubview:_flipBookView belowSubview:self.menuItemBar];
    _painterView = [[SimpleSketchView alloc]initWithFrame:landscapeBounds];
    [self.view insertSubview:_painterView belowSubview:self.menuItemBar];
    [_painterView setHidden:true];
    
    _twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(twoFingerPinch:)];
    [self.view addGestureRecognizer:_twoFingerPinch];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self buildData];
    [self buildNotificationHandlers];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


-(void)buildData{
    
    NSMutableArray *data = [[NSMutableArray alloc]init];
    for (int i=0; i<6; i++) {

        BookData *bookData = [[BookData alloc]init];
        if (i==0) {
            bookData.cover    = BOOKCOVER_BLACK;
            bookData.name     = @"bookA";
        }else if (i==1) {
            bookData.cover    = BOOKCOVER_WHITE;
            bookData.name     = @"bookB";
        }else if (i==2) {
            bookData.cover    = @"cover14.png";
            bookData.name     = @"bookC";
        }else if (i==3) {
            bookData.cover    = @"cover4.png";
            bookData.name     = @"bookD";
        }else if (i==4) {
            bookData.cover    = @"cover5.png";
            bookData.name     = @"bookE";
        }else if (i==5) {
            bookData.cover    = @"cover6.png";
            bookData.name     = @"bookF";
        }
        

        NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        
        NSMutableArray *pages = [[NSMutableArray alloc]init];
        for (int j=0; j<25; j++) {
            PageData *pd = [[PageData alloc]init];
            //pd.img  = [NSString stringWithFormat:@"page%d.png",j+1];
            //pd.thumb= [NSString stringWithFormat:@"pageThumb%d.jpg",j+1];
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setDay:j%2+1];
            [comps setMonth:j%12+1];
            [comps setYear:2012];
            [comps setHour:12];
            [comps setMinute:0];
            [comps setSecond:0];
            
            NSDate *date = [cal dateFromComponents:comps];
            pd.date = date;
            [pages addObject:pd];
        }
        bookData.pages = pages;
        [data addObject:bookData];
    }
    
    _flipBookView.bookShelf.data  = data;
}

-(void)buildNotificationHandlers{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(bookOpenHandler:)
     name:BOOK_OPEN
     object:_flipBookView.bookShelf];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(bookCloseHandler:)
     name:BOOK_CLOSE
     object:_flipBookView.bookShelf];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(pageFullScreenHandler:)
     name:PAGE_FULLSCREEN
     object:_flipBookView.bookShelf];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(pageExitFullScreenHandler:)
     name:PAGE_EXIT_FULLSCREEN
     object:_flipBookView.bookShelf];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sketchCloseHandler:)
     name:SKETCH_CLOSE
     object:_painterView];
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer{
    
    if (_painterView.hidden) {
        [_flipBookView.bookShelf twoFingerPinch:recognizer];
    }else{
        [_painterView twoFingerPinch:recognizer];
    }
    
}

-(void)bookOpenHandler: (NSNotification *) notification{
    NSLog(@"book open");
}

-(void)bookCloseHandler: (NSNotification *) notification{
    NSLog(@"book close");
}

int editingBookId;
int editingPageId;
-(void)pageFullScreenHandler: (NSNotification *) notification{
    editingBookId = _flipBookView.bookShelf.selectedBook.id;
    editingPageId = _flipBookView.bookShelf.getSelectedPageId;
    NSLog(@"page fullscreen %d",editingPageId);
    //NSLog([NSString stringWithFormat:@"%d",editingBookId]);
    //NSLog([NSString stringWithFormat:@"%d",editingPageId]);
    [_painterView setHidden:false];
}

-(void)pageExitFullScreenHandler: (NSNotification *) notification{
    NSLog(@"page exit fullscreen");
    [_painterView setHidden:true];
    //CGImageRef spriteImage = [UIImage imageNamed:@"a.jpg"].CGImage;
    //[_flipBookViewController.bookShelf setPageImgByCGImg:spriteImage bookId:editingBookId pageId:editingPageId];
    //[_flipBookViewController.bookShelf setPageImgByFile:@"a.jpg" bookId:editingBookId pageId:editingPageId];
}

-(void)sketchCloseHandler: (NSNotification *) notification{
    NSLog(@"sketch close");
    [_flipBookView.bookShelf setPageImgByCGImg:_painterView.drawImage.image.CGImage bookId:editingBookId pageId:editingPageId];
    [_painterView setHidden:true];
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