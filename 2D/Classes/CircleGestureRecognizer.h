//
//  CircleGestureRecognizer.h
//  FlipBook
//
//  Created by Lei Perry on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIGestureRecognizerSubclass.h>

@protocol CircleGestureDelegate <NSObject>

- (void)redo;
- (void)undo;

@end

@interface CircleGestureRecognizer : UIGestureRecognizer

@property (nonatomic, unsafe_unretained) id<CircleGestureDelegate> circleDelegate;
@property (nonatomic, readonly) CGFloat progress;

@end