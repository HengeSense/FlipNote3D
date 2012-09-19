//
//  BookPropertyEditorViewController.m
//  FlipBook3D
//
//  Created by huang xiang on 9/18/12.
//
//

#import "BookPropertyEditorViewController.h"
#import "FlipBookView.h"
#import "ConstantValues.h"
#import "Book.h"
#import <MobileCoreServices/UTCoreTypes.h>


@implementation BookPropertyEditorViewController

@synthesize  popoverController;


- (id)initWithFlipBookView:(FlipBookView*)view
{

    if (self) {
        _flipBookView   = view;
        CGRect frame    = CGRectMake(400, 220, 82*6+70, 300);
        self.view       = [[UIView alloc]initWithFrame:frame];
        self.view.hidden = true;
        //self.view.backgroundColor = [UIColor redColor];
        
        [self initTitleTextField];
    }
    return self;
}


-(void)initTitleTextField{
    CGRect rect = CGRectMake(70, 0, 495, 40);
    _titleTextField = [[UITextField alloc]initWithFrame:rect];
    _titleTextField.backgroundColor = [[UIColor alloc]initWithRed:1 green:1 blue:1 alpha:0];
    _titleTextField.textColor     = [[UIColor alloc]initWithWhite:1 alpha:1];
    _titleTextField.textAlignment = UITextAlignmentLeft;
    _titleTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    UIFont * titleFont = [UIFont fontWithName:@"Helvetica" size:30];
    _titleTextField.font = titleFont;
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(titleTextChangeHandler:)
     name:UITextFieldTextDidChangeNotification
     object:_titleTextField];
    _titleTextField.text = @"title";
    [self.view addSubview:_titleTextField];
}

-(void)titleTextChangeHandler:(NSNotification *) notification{
    NSLog(@"change");
    [_flipBookView setBookTitle:_titleTextField.text];
}


-(void)initImgClips{
    for (int i=0; i<15; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"coverThumb%d",i]];
        UIButton * imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frameOrigion = CGRectMake(70+i%6*82, 50+floorf(i/6)*82, 80, 80);
        imgBtn.frame    = frameOrigion;
        imgBtn.tag      = i;
        
        [imgBtn setBackgroundImage:img forState:UIControlStateNormal];
        [imgBtn addTarget:self action:@selector(imgBtnClickHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:imgBtn];
        
    }
    UIImage *emptyImg = [UIImage imageNamed:@"emptyImage.png"];
    _choosePhotoIcon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect frameOrigion = CGRectMake(70+15%6*82, 50+floorf(15/6)*82, 80, 80);

    _choosePhotoIcon.frame   = frameOrigion;
    [_choosePhotoIcon setBackgroundImage:emptyImg forState:UIControlStateNormal];
    [_choosePhotoIcon addTarget:self action:@selector(choosePhotoIconClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_choosePhotoIcon];
}

- (void)imgBtnClickHandler:(UIButton *)button
{
    NSLog(@"%d",button.tag);
    if (button.tag==0) {
        _flipBookView.bookShelf.focusedBook.data.cover = BOOKCOVER_BLACK;
    }else if(button.tag==1){
        _flipBookView.bookShelf.focusedBook.data.cover = BOOKCOVER_WHITE;
    }else{
        _flipBookView.bookShelf.focusedBook.data.cover = [NSString stringWithFormat:@"cover%d.png",button.tag];
    }
    
    [_flipBookView.bookShelf.focusedBook.cover reloadCover];
}
-(void)show{
    self.view.hidden = false;
    _titleTextField.text = _flipBookView.bookShelf.focusedBook.data.name;
    if (_imgClips==Nil) {
        [self initImgClips];
    }
    _imgClipPage = -1;
    
    self.view.alpha = 0;
    [UIView animateWithDuration:.6 delay:.6 options: UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.view.alpha = 1;
                     }
                     completion:^(BOOL finished){ }];
}
-(void)hide{
    [UIView animateWithDuration:.3 delay:0 options: UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.view.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         if(finished){
                            self.view.hidden = true;
                         }
                     }];
}

- (void) choosePhotoIconClickHandler:(UIButton *)button{
    
    if ([self.popoverController isPopoverVisible]) {
        [self.popoverController dismissPopoverAnimated:YES];

    } else {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                      (NSString *) kUTTypeImage,
                                      nil];
            imagePicker.allowsEditing = NO;
            
            self.popoverController = [[UIPopoverController alloc]
                                      initWithContentViewController:imagePicker];
            
            popoverController.delegate = self;
            [self.popoverController
             presentPopoverFromRect:CGRectMake(0,160, 0, 0) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
            
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverController dismissPopoverAnimated:true];
    
//    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [_flipBookView.bookShelf.focusedBook.cover setCoverImage:image];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
