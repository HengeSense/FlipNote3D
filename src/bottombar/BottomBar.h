//
//  BottomBar.h
//  FlipBook3D
//
//  Created by huang xiang on 8/6/12.
//
//

#import "ObjectContainer3D.h"
#import "BottomBarButton.h"

@class BookShelf;
@interface BottomBar : ObjectContainer3D{
    
    float _expandLevel;
    float _btnDist;
    
    BottomBarButton * _shareBtn;
    BottomBarButton * _deleteBtn;
    BottomBarButton * _switchViewBtn;
    BottomBarButton * _settingBtn;
    BottomBarButton * _addBtn;
    
}

@property(readonly)NSMutableArray *buttons;
@property(readonly)NSMutableArray *allButtons;

-(id)initWithShelf:(BookShelf*) shelf;
@property(readonly)BookShelf * shelf;


-(void)gotoShelfStatus;
-(void)gotoFlipRenderStatus;
-(void)gotoTableRenderStatus;
-(void)gotoCalendarRenderStatus;

-(void)hide;
-(void)show;
@end
