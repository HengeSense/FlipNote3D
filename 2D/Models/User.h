//
//  User.h
//  FlipBook
//
//  Created by Lei Perry on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface User : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *sessionId;

@end