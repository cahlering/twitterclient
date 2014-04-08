//
//  TWTweetContainer.h
//  TwitterClient
//
//  Created by Chris Ahlering on 4/1/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TWTweet.h"

typedef enum  {
    HOME,
    MENTION
} TimelineType;

@interface TWTweetContainer : NSObject

@property (nonatomic) TimelineType timelineType;

+ (TWTweetContainer *) instance;

- (NSMutableArray *) tweetsForTimeLine;

- (TWTweet *)tweetById :(long long)tweetId;
@end
