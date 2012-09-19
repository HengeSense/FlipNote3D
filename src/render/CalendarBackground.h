//
//  CalendarBackground.h
//  FlipBook3D
//
//  Created by huang xiang on 8/19/12.
//
//

#import "ObjectContainer3D.h"

@interface CalendarBackground : ObjectContainer3D

-(GLKVector3)getDatePosition:(NSDate*)date;
@end
