//
//  TWTweetContainer.m
//  TwitterClient
//
//  Created by Chris Ahlering on 4/1/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWTweetContainer.h"

@interface TWTweetContainer()

@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) NSMutableArray *mentions;

@end

@implementation TWTweetContainer


+ (TWTweetContainer *)instance
{
    static TWTweetContainer *clientInstance;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        clientInstance = [[TWTweetContainer alloc]init];
        clientInstance.tweets = [NSMutableArray array];
        clientInstance.mentions = [NSMutableArray array];
    });
    return clientInstance;
}

- (TWTweet *)tweetById:(long long)tweetId
{
    //just brute force iterate for now
    for (TWTweet *tweet in _tweets) {
        if (tweet.id == tweetId) {
            return tweet;
        }
    }
    return nil;
}

- (NSMutableArray *) tweetsForTimeLine
{
    if (_timelineType == MENTION) {
        return _mentions;
    } else {
        return _tweets;
    }
}

@end
