//
//  TWAPIClient.h
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"
#import "../models/TWTweet.h"

@interface TWAPIClient : BDBOAuth1SessionManager

+ (TWAPIClient *)instance;

- (void) login;

- (void) handleAuthenticationRedirectParameters: (NSString *)authenticationParameters success:(void(^)(void))success;

- (void) homeTimelineWithIndexAndBefore :(NSString*)index before:(BOOL)before :(void(^)(NSArray *tweets))callback;

- (void) currentUser :(void (^)(TWUser *user))callback;

- (void) getUserWithScreenName :(NSString *)screenName andBannerImages:(BOOL)andBannerImages :(void (^)(TWUser *user))callback;

- (void) getProfileBannersWithScreenName :(NSString *)screenName :(void (^)(TWUserBannerImages *images))callback :(void (^)())errorCallback;

- (void) tweet: (NSString *)status :(void (^)(TWTweet *tweet))callback;

- (void) getTweet: (NSString *)tweetId :(void (^)(TWTweet *tweet))callback;

- (void) unReTweet: (TWTweet *)tweetToRetweet :(void (^)(TWTweet *tweet))callback;

- (void) reTweet: (TWTweet *)tweetToRetweet :(void (^)(TWTweet *tweet))callback;

- (void) favorite: (TWTweet *)tweetToFavorite remove:(BOOL)remove :(void (^)(TWTweet *tweet))callback;

- (void) tweetAsReply: (NSString *)status replyToId:(NSString *)replyToId :(void (^)(TWTweet *tweet))callback;

@end
