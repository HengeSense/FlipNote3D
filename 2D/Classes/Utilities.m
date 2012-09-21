//
//  Utilities.m
//  FlipBook
//
//  Created by Lei Perry on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

+ (NSString *)AppID
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([pref objectForKey:@"app_id"] == nil)
    {
        [pref setObject:[Utilities GetUUID] forKey:@"app_id"];
        [pref synchronize];
    }
    return [pref objectForKey:@"app_id"];
}

+ (NSString *)AppStoreID
{
    return @"";
}

static NSInteger __networkActivityCount = 0;

+ (void)startNetworkActivity
{
    __networkActivityCount++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

+ (void)stopNetworkActivity
{
    __networkActivityCount--;
    if (__networkActivityCount == 0)
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

@end