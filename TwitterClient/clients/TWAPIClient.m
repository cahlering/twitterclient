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

- (void)homeTimelineWithIndexAndBefore :(NSString *)index before:(BOOL)before :(void (^)(NSArray *tweets))callback
{
    
    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [self setResponseSerializer:tweetSerializer];
    
    NSDictionary *callParameters;
    if (index) {
        NSString *indexParameterName;
        if (before) {
            indexParameterName = @"max_id";
        } else {
            indexParameterName = @"since_id";
        }
        callParameters = @{indexParameterName : index};
    }
    
    [self GET:@"1.1/statuses/home_timeline.json" parameters:callParameters success:^(NSURLSessionDataTask *task, id responseObject) {
        callback(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Timeline error: %@", error);
    }];
    
}

-(void)currentUser :(void (^)(TWUser *user))callback
{
    
    MUJSONResponseSerializer *userSerializer = [[MUJSONResponseSerializer alloc]init];
    [userSerializer setResponseObjectClass:[TWUser class]];
    [self setResponseSerializer:userSerializer];
    
    [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback((TWUser *)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error getting account: %@", error);
    }];
}

- (void)tweet:(NSString *)status :(void (^)(TWTweet *tweets))callback
{
    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [self setResponseSerializer:tweetSerializer];

    [self POST:@"1.1/statuses/update.json" parameters:@{@"status":status} constructingBodyWithBlock:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback((TWTweet *)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error tweeting: %@", error);
    }];
}

- (void)reTweet:(TWTweet *)tweet :(void (^)(TWTweet *))callback
{
    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [self setResponseSerializer:tweetSerializer];
    
    [self POST:[NSString stringWithFormat:@"%@/%lld.json", @"1.1/statuses/retweet", tweet.id] parameters:nil constructingBodyWithBlock:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback((TWTweet *)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error reTweeting: %@", error);
    }];
    
}


- (void)favorite:(TWTweet *)tweet remove:(BOOL)remove :(void (^)(TWTweet *))callback
{
    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [self setResponseSerializer:tweetSerializer];
    
    [self POST:[NSString stringWithFormat:@"1.1/favorites/%@.json", (remove) ? @"destroy" : @"create" ] parameters:@{@"id": @(tweet.id)} constructingBodyWithBlock:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback((TWTweet *)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error favoriting: %@", error);
    }];
    
}

@end
