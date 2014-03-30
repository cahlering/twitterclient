//
//  TWTweet.h
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "MUJSONResponseSerializer.h"
#import "TWUser.h"

@interface TWTweet : MUJSONResponseObject

@property (nonatomic) long *id;
@property (strong, nonatomic) NSString *idString;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) TWUser *user;

@end
