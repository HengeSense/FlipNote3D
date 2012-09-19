//
//  BookPropertyEditorViewController.h
//  FlipBook3D
//
//  Created by huang xiang on 9/18/12.
//
//

#import <UIKit/UIKit.h>
@class FlipBookView;

@interface BookPropertyEditorViewController : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPopoverControllerDelegate>{
    FlipBookView *_flipBookView;
    UITextField *_titleTextField;
    NSMutableArray *_imgClips;
    int _imgClipPage;
    UIButton *_choosePhotoIcon;
    UIButton *_choosePhotoLabel;
    UIPopoverController *popoverController;

}
@property (nonatomic) UIPopoverController *popoverController;
-(void)show;
-(void)hide;
- (id)initWithFlipBookView:(FlipBookView*)view;

@end
