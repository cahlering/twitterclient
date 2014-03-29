//
//  TWAPIClient.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWAPIClient.h"

@implementation TWAPIClient

+ (TWAPIClient *)instance
{
    static TWAPIClient *clientInstance;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        clientInstance = [[TWAPIClient alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.twitter.com/"] consumerKey:@"VraujCcyWRb7DnlqUwYkA" consumerSecret:@"Kgl9weUuNRIpvpU9ZgdXIrEVhFJAVfkVWI5gZ75UZU"];
    });
    return clientInstance;
}

- (void) login
{
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"POST" callbackURL:[NSURL URLWithString:@"codepathos://requestToken"] scope:nil success:^(BDBOAuthToken *requestToken) {
        
        NSURL * authUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%@/oauth/authorize?oauth_token=%@", [self.baseURL scheme], [self.baseURL host], requestToken.token]];
        [[UIApplication sharedApplication] openURL:authUrl];
    } failure:^(NSError *error) {
        NSLog(@"Token request error %@", error);
    }];
}

- (void) handleAuthenticationRedirectParameters : (NSString *) authenticationParameters success:(void (^)(void))success
{
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:authenticationParameters] success:^(BDBOAuthToken *accessToken) {
        success();
        NSLog(@"@Authorized!");
    } failure:^(NSError *error) {
        NSLog(@"Authorization failure: %@", error);
    }];
}


@end
