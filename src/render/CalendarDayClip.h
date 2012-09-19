//
//  CalendarDayClip.h
//  FlipBook3D
//
//  Created by huang xiang on 8/26/12.
//
//

#import "ObjectContainer3D.h"
#import "Page.h"

@interface CalendarDayClip : ObjectContainer3D{
    NSMutableArray *_pages;
    int _labelVertexId;
}

@property(readonly)NSDate* date;
@property(readonly)NSArray *pages;
-(id)initWithDate:(NSDate*)date;
-(void)addpage:(Page*)page;

-(void)renderLabel;
-(BOOL)isEqualToDate:(NSDate*)inputDate;
@end
