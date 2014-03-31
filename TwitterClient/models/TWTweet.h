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

@property (nonatomic) long long id;
@property (strong, nonatomic) NSString *idString;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) TWUser *user;
@property (nonatomic) long retweetCount;
@property (nonatomic) BOOL retweeted;
@property (nonatomic) long favoriteCount;
@property (nonatomic) BOOL favorited;
@property (nonatomic) NSDictionary *currentUserRetweet;

@end
