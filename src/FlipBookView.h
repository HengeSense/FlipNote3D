//
//  FlipBookView.h
//  FlipBook3D
//
//  Created by huang xiang on 8/4/12.
//
//

#import "Adela3DGLVIew.h"
#import "BookShelf.h"
#import "BookPropertyEditorViewController.h"

@interface FlipBookView : Adela3DGLVIew{
    UILabel* _bookTitleLabel;
    UILabel* _bookTitlePageNumLabel;
    BookPropertyEditorViewController *_bookPropertyEditorController;
}

@property(readonly)BookShelf *bookShelf;

-(void)setBookTitle:(NSString*)title;
-(void)setBookTitlePageNum:(int)pageNum;
-(void)setBookTitle:(NSString*)title AndPageNum:(int)pageNum;
-(void)bookTitleBlink;

-(void)bookTitleShow;
-(void)bookTitleHide;

-(void)moveLabelToShelfStatus;
-(void)moveLabelToFlipRenderStatus;
-(void)moveLabelToTableRenderStatus;
-(void)moveLabelToCalendarRenderStatus;
-(void)moveLabelToBookEditStatus;

-(void)showBookPropertyEditor;
-(void)hideBookPropertyEditor;
@end
