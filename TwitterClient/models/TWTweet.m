//
//  TWTweet.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWTweet.h"

@implementation TWTweet
-(id)init {
    if (self = [super init]) {
        self.propertyMap = @{
                             @"id_str": @"idString",
                             @"created_at": @"createdAt",
                             @"retweet_count": @"retweetCount",
                             @"favorite_count": @"favoriteCount",
                             @"current_user_retweet": @"currentUserRetweet"
                             };
        
        [self.dateFormatter setDateFormat:@"EEE MMM d HH:mm:ss Z y"];

    }
    return self;
}

@end
