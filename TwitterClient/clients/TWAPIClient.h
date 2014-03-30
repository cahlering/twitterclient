//
//  TWAPIClient.h
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "BDBOAuth1SessionManager.h"

@interface TWAPIClient : BDBOAuth1SessionManager

+ (TWAPIClient *)instance;

- (void) login;

- (void) handleAuthenticationRedirectParameters: (NSString *)authenticationParameters success:(void(^)(void))success;

- (void)homeTimelineWithIndexAndBefore :(NSString*)index before:(BOOL)before :(void(^)(NSArray *tweets))callback;

- (void) tweet;

- (void) reTweetById: (NSString *)tweetToRetweet;


@end
