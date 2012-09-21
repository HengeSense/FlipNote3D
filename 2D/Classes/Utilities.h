//
//  Utilities.h
//  FlipBook
//
//  Created by Lei Perry on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


@interface Utilities : NSObject

+ (NSString *)GetUUID;
+ (NSString *)AppID;
+ (NSString *)AppStoreID;

+ (void)startNetworkActivity;
+ (void)stopNetworkActivity;

@end