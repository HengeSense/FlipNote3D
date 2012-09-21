//
//  Canvas.h
//  FlipBook
//
//  Created by Lei Perry on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface Canvas : UIView

@property (strong) NSMutableArray *arrayStrokes;
@property (strong) NSMutableArray *arrayAbandonedStrokes;
@property (strong) UIColor *currentColor;
@property float currentSize;

- (void)undo;
- (void)redo;
- (void)clearCanvas;

@end