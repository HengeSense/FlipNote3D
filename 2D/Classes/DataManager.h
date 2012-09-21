//
//  DataManager.h
//  FlipBook
//
//  Created by Lei Perry on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

@interface DataManager : NSObject

@property (nonatomic, strong) User *currentUser;

+ (DataManager *)sharedDataManager;

@end