//
//  TWAPIClient.h
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TWAPIClient : BDBOAuth1RequestOperationManager

+ (TWAPIClient *)instance;

- (void) login;

- (void) handleAuthenticationRedirectParameters: (NSString *)authenticationParameters success:(void(^)(void))success;

- (NSArray *)homeTimeline;

- (void) tweet;

- (void) reTweetById: (NSInteger *)tweetToRetweet;


@end
