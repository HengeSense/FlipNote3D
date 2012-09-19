//
//  BottomBar.m
//  FlipBook3D
//
//  Created by huang xiang on 8/6/12.
//
//

#import "BottomBar.h"
#import "ConstantValues.h"
#import "Scene3D.h"
#import "Tween.h"
#import "BookShelf.h"
#import "Book.h"
#import "FlipBookView.h"

@implementation BottomBar



@synthesize shelf = _shelf;

-(id)initWithShelf:(BookShelf*) shelf{
    self = [super init];
    if (self) {
        _shelf = shelf;
        self.z  = -1000;
        self.y  = -510;
        _expandLevel = 0;
        _btnDist    = 79;
        self.isCastShadow = false;
        [Tween to:self duration:1 delay:1 valuePoint:&_expandLevel targetValue:1 ease:EASE_EXPO_OUT];
        [self initButtons];
        //[self open];

    }
    return self;
}

@synthesize buttons = _buttons;
@synthesize allButtons = _allButtons;
-(void)initButtons{
    _shareBtn = [[BottomBarButton alloc]initWidthPart:LEFT andName:SHARE];
    [_shareBtn updateBuffers:1 :0:true];
    [self addChild:_shareBtn];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(shareBtnClick:)
     name:TOUCH_CLICK
     object:_shareBtn];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(btnTouchBegin:)
     name:TOUCH_BEGIN
     object:_shareBtn];
    
    _deleteBtn = [[BottomBarButton alloc]initWidthPart:RIGHT andName:DELETE];
    [_deleteBtn updateBuffers:1 :1:true];
    [self addChild:_deleteBtn];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(deleteBtnClick:)
     name:TOUCH_CLICK
     object:_deleteBtn];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(btnTouchBegin:)
     name:TOUCH_BEGIN
     object:_deleteBtn];
    
    _switchViewBtn = [[BottomBarButton alloc]initWidthPart:LEFT andName:SWITCHVIEW];
    [_switchViewBtn updateBuffers:2 :2:true];
    [self addChild:_switchViewBtn];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(switchViewBtnClick:)
     name:TOUCH_CLICK
     object:_switchViewBtn];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(btnTouchBegin:)
     name:TOUCH_BEGIN
     object:_switchViewBtn];
    _switchViewBtn.visible = false;
    
    _settingBtn = [[BottomBarButton alloc]initWidthPart:LEFT andName:SETTING];
    [_settingBtn updateBuffers:0 :2:true];
    [self addChild:_settingBtn];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(settingBtnClick:)
     name:TOUCH_CLICK
     object:_settingBtn];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(btnTouchBegin:)
     name:TOUCH_BEGIN
     object:_settingBtn];
    
    
    _addBtn = [[BottomBarButton alloc]initWidthPart:RIGHT andName:ADD];
    [_addBtn updateBuffers:0 :1:true];
    [self addChild:_addBtn];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(addBtnClick:)
     name:TOUCH_CLICK
     object:_addBtn];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(btnTouchBegin:)
     name:TOUCH_BEGIN
     object:_addBtn];
    
    
    _buttons    = [[NSMutableArray alloc ]initWithObjects:_shareBtn,_deleteBtn,_settingBtn,_addBtn, nil];
    _allButtons = [[NSMutableArray alloc ]initWithObjects:_shareBtn,_deleteBtn,_switchViewBtn,_settingBtn,_addBtn, nil];
}



-(void)shareBtnClick: (NSNotification *) notification{
    //[Tween killTweenOf:self];
    //_btnDist=90;
    NSLog(@"shareBtnClick");
    
    
}

-(void)deleteBtnClick: (NSNotification *) notification{
    //[Tween killTweenOf:self];
    NSLog(@"deleteBtnClick");
    if(_shelf.selectedBook){
        [_shelf deleteSelectedPageInSelectedBook];
    }else{
        [_shelf deleteFocusedBook];
    }
}

-(void)switchViewBtnClick: (NSNotification *) notification{
    //[Tween killTweenOf:self];
    NSLog(@"switchViewBtnClick");
    if(_shelf.selectedBook && _shelf.selectedBook.status==OPEN_FLIP){
        [_shelf selectedBookGotoTableRender];
    }else if(_shelf.selectedBook && _shelf.selectedBook.status==OPEN_TABLE){
        [_shelf selectedBookGotoCalendarRender];
    }else if(_shelf.selectedBook && _shelf.selectedBook.status==OPEN_CALENDAR){
        [_shelf selectedBookGotoFlipRender];
    }
    self.mouseEnabled = false;
    [Tween mouseEnableTo:self delay:1 value:true];
}

-(void)settingBtnClick: (NSNotification *) notification{
    NSLog(@"settingBtnClick");
    if(_shelf.selectedBook){
    }else{
        [_shelf editFocusedBook];
    }

}

-(void)addBtnClick: (NSNotification *) notification{
    NSLog(@"addBtnClick");
    if(_shelf.selectedBook){
        [_shelf addAPageInSelectedBook];
    }else{
        [_shelf addBook];
    }
}

-(void)btnTouchBegin: (NSNotification *) notification{
    [Tween to:self duration:.1 delay:0 valuePoint:&_btnDist targetValue:79.9 ease:EASE_EXPO_OUT];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(btnTouchEnd:)
     name:TOUCH_END
     object:self.scene];
    
}
-(void)btnTouchEnd: (NSNotification *) notification{
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:TOUCH_END
     object:self.scene];
    [Tween to:self duration:.3 delay:.1 valuePoint:&_btnDist targetValue:79 ease:EASE_EXPO_OUT];
}

-(void)gotoShelfStatus{
    
    [Tween to:self duration:.3 delay:0 valuePoint:&_expandLevel targetValue:.2 ease:EASE_EXPO_OUT];
    [self performSelector:@selector(gotoShelfCloseHandler) withObject:Nil afterDelay:.3];
}

-(void)gotoShelfCloseHandler{
    [Tween to:self duration:1 delay:0 valuePoint:&_expandLevel targetValue:1 ease:EASE_EXPO_OUT];
    [_buttons removeAllObjects];
    [_buttons addObject:_shareBtn];
    [_buttons addObject:_deleteBtn];
    [_buttons addObject:_settingBtn];
    [_buttons addObject:_addBtn];
    [self updateButtons];
}

-(void)gotoFlipRenderStatus{
    [Tween to:self duration:.3 delay:0 valuePoint:&_expandLevel targetValue:.2 ease:EASE_CUBIC_OUT];
    [self performSelector:@selector(gotoFlipRenderCloseHandler) withObject:Nil afterDelay:.3];
}

-(void)gotoFlipRenderCloseHandler{
    [_switchViewBtn updateBuffers:2 :2:false];
    [Tween to:self duration:1 delay:0 valuePoint:&_expandLevel targetValue:1 ease:EASE_EXPO_OUT];
    [_buttons removeAllObjects];
    [_buttons addObject:_shareBtn];
    [_buttons addObject:_deleteBtn];
    [_buttons addObject:_switchViewBtn];
    [_buttons addObject:_addBtn];
    [self updateButtons];
}

-(void)gotoTableRenderStatus{
    [Tween to:self duration:.3 delay:0 valuePoint:&_expandLevel targetValue:.2 ease:EASE_CUBIC_OUT];
    [self performSelector:@selector(gotoTableRenderCloseHandler) withObject:Nil afterDelay:.3];
}

-(void)gotoTableRenderCloseHandler{
    [_switchViewBtn updateBuffers:2 :1:false];
    [Tween to:self duration:1 delay:0 valuePoint:&_expandLevel targetValue:1 ease:EASE_EXPO_OUT];
    
    [_buttons removeAllObjects];
    [_buttons addObject:_shareBtn];
    [_buttons addObject:_switchViewBtn];
    [_buttons addObject:_addBtn];
    [self updateButtons];
}


-(void)gotoCalendarRenderStatus{
    [Tween to:self duration:.3 delay:0 valuePoint:&_expandLevel targetValue:.2 ease:EASE_CUBIC_OUT];
    [self performSelector:@selector(gotoCalendarRenderCloseHandler) withObject:Nil afterDelay:.3];
}
    
-(void)gotoCalendarRenderCloseHandler{
    [_switchViewBtn updateBuffers:2 :0:false];
    [Tween to:self duration:1 delay:0 valuePoint:&_expandLevel targetValue:1 ease:EASE_EXPO_OUT];
        
    [_buttons removeAllObjects];
    [_buttons addObject:_shareBtn];
    [_buttons addObject:_switchViewBtn];
    [_buttons addObject:_addBtn];
    [self updateButtons];
}



-(void)updateButtons{
    for (int i =0; i<_allButtons.count; i++) {
        BottomBarButton *btn = [_allButtons objectAtIndex:i];
        btn.visible = false;
    }
    for (int i =0; i<_buttons.count; i++) {
        BottomBarButton *btn = [_buttons objectAtIndex:i];
        if (i%2==0) {
            btn.part = LEFT;
        }else{
            btn.part = RIGHT;
        }
        btn.visible = true;
    }
}


-(void)hide{
    self.mouseEnabled = false;
    [Tween killTweenOf:self];
    [Tween to:self duration:.6 delay:0 valuePoint:&_expandLevel targetValue:0 ease:EASE_EXPO_OUT];
}
-(void)show{
    self.mouseEnabled = true;
    [Tween killTweenOf:self];
    [Tween to:self duration:1 delay:0 valuePoint:&_expandLevel targetValue:1 ease:EASE_EXPO_OUT];
}

-(void)updateMatrix{
    [self update];
    //self.scene.camera.ppCenter = _screenDiff;
    [super updateMatrix];
    //self.scene.camera.ppCenter = GLKVector2Make(0, 0);
}

-(void)update{
    float btnDiffX = (-.5*_buttons.count+1)*_btnDist*_expandLevel;
    float ang = acosf(_expandLevel*_btnDist/BOTTOMBARBTN_SIZE);
    ang = ang*RADIANS_TO_DEGREES;
    
    for (int i =0; i<_buttons.count; i++) {
        
        BottomBarButton *btn = [_buttons objectAtIndex:i];
        btn.x  =  btnDiffX+2*floor(i/2)*_btnDist*_expandLevel;
        if (btn.part == LEFT) {
            btn.rotationY = ang;
        }else{
            btn.rotationY = -ang;
        }
    }
}

@end
