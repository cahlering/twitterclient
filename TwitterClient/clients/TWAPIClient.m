//
//  TWAPIClient.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWAPIClient.h"
#import "../models/TWTweet.h"

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

- (void)homeTimeline :(void (^)(NSArray *tweets))callback
{
    NSError *localerror;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@:%@/%@", self.baseURL.scheme, self.baseURL.host, @"1.1/statuses/home_timeline"] parameters:nil error:&localerror];
    
    if (localerror) {
        //error handler
    }
    
    AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Timeline error: %@", error);
    }];
    
    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [operation setResponseSerializer:tweetSerializer];
    
    [operation start];
}


@end
