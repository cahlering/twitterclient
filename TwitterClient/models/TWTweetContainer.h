//
//  TWTweetContainer.h
//  TwitterClient
//
//  Created by Chris Ahlering on 4/1/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTweet.h"

@interface TWTweetContainer : NSObject

@property (strong, nonatomic) NSMutableArray *tweets;

+ (TWTweetContainer *) instance;

- (TWTweet *)tweetById :(long long)tweetId;
@end
