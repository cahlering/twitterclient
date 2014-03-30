//
//  TWUser.h
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "MUJSONResponseSerializer.h"

@interface TWUser : MUJSONResponseObject

@property (weak, nonatomic) NSString *name;
@property (weak, nonatomic) NSString *screenName;
@property (weak, nonatomic) NSString *profileImage;

@end
