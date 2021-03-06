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
    [self tweetsByTimelineWithIndexAndBefore:@"home" index:index before:before :callback];
}

- (void)mentionsTimelineWithIndexAndBefore :(NSString *)index before:(BOOL)before :(void (^)(NSArray *tweets))callback
{
    [self tweetsByTimelineWithIndexAndBefore:@"mentions" index:index before:before :callback];
}

- (void)tweetsByTimelineWithIndexAndBefore :(NSString *)timeline index:(NSString *)index before:(BOOL)before :(void (^)(NSArray *tweets))callback
{

    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [self setResponseSerializer:tweetSerializer];
    
    NSDictionary *callParameters;
    if (index) {
        NSString *indexParameterName;
        if (before) {
            indexParameterName = @"since_id";
        } else {
            indexParameterName = @"max_id";
        }
        callParameters = @{indexParameterName : index};
    }
    
    [self GET:[NSString stringWithFormat:@"1.1/statuses/%@_timeline.json", timeline] parameters:callParameters success:^(NSURLSessionDataTask *task, id responseObject) {
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

-(void)getUserWithScreenName :(NSString *)screenName andBannerImages:(BOOL)andBannerImages :(void (^)(TWUser *user))callback
{
    
    MUJSONResponseSerializer *userSerializer = [[MUJSONResponseSerializer alloc]init];
    [userSerializer setResponseObjectClass:[TWUser class]];
    [self setResponseSerializer:userSerializer];
    
    [self GET:@"1.1/users/show.json" parameters:@{@"screen_name": screenName} success:^(NSURLSessionDataTask *task, id responseObject) {
        TWUser *retrievedUser = (TWUser *)responseObject;
        if (andBannerImages) {
            [self getProfileBannersWithScreenName:screenName :^(TWUserBannerImages *images) {
                [retrievedUser setBannerImages:(TWUserBannerImages *)responseObject];
            } :^{
                ;
            }];
        }
        callback(retrievedUser);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error getting account: %@", error);
    }];
}

- (void) getProfileBannersWithScreenName :(NSString *)screenName :(void (^)(TWUserBannerImages *images))callback :(void (^)()) errorCallback
{
    MUJSONResponseSerializer *profileSerializer = [[MUJSONResponseSerializer alloc]init];
    [profileSerializer setResponseObjectClass:[TWUserBannerImages class]];
    [self setResponseSerializer:profileSerializer];
    
    [self GET:@"1.1/users/profile_banner.json" parameters:@{@"screen_name": screenName} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback((TWUserBannerImages*) responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        errorCallback();
        NSLog(@"Error getting profile banners: %@", error);
    }];
    
}

-(void)getTweet:(NSString *)tweetId :(void (^)(TWTweet *))callback
{
    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [self setResponseSerializer:tweetSerializer];
    
    [self GET:@"1.1/statuses/show.json" parameters:@{@"id":tweetId, @"include_my_retweet":@(YES)} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback((TWTweet *)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error tweeting: %@", error);
    }];
}

- (void)tweet:(NSString *)status :(void (^)(TWTweet *tweets))callback
{
    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [self setResponseSerializer:tweetSerializer];

    [self POST:@"1.1/statuses/update.json" parameters:@{@"status":status} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback((TWTweet *)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error tweeting: %@", error);
    }];
}

- (void) tweetAsReply:(NSString *)status replyToId:(NSString *)replyToId :(void (^)(TWTweet *))callback
{
    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [self setResponseSerializer:tweetSerializer];
    
    [self POST:@"1.1/statuses/update.json" parameters:@{@"status":status, @"in_reply_to_status_id":replyToId} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback((TWTweet *)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error replying: %@", error);
    }];
}

- (void)reTweet:(TWTweet *)tweet :(void (^)(TWTweet *))callback
{
    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [self setResponseSerializer:tweetSerializer];
    
    [self POST:[NSString stringWithFormat:@"%@/%lld.json", @"1.1/statuses/retweet", tweet.id] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        callback((TWTweet *)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error reTweeting: %@", error);
    }];
    
}
- (void)unReTweet:(TWTweet *)tweet :(void (^)(TWTweet *))callback
{
    MUJSONResponseSerializer *tweetSerializer = [[MUJSONResponseSerializer alloc]init];
    [tweetSerializer setResponseObjectClass:[TWTweet class]];
    [self setResponseSerializer:tweetSerializer];
    
    NSNumber *idNum = [tweet.currentUserRetweet objectForKey:@"id"];
    long long longTweetId = [idNum longLongValue];
    [self POST:[NSString stringWithFormat:@"%@/%lld.json", @"1.1/statuses/destroy", longTweetId] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    
    [self POST:[NSString stringWithFormat:@"1.1/favorites/%@.json", (remove) ? @"destroy" : @"create" ] parameters:@{@"id": @(tweet.id)} success:^(NSURLSessionDataTask *task, id responseObject) {
        callback((TWTweet *)responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error favoriting: %@", error);
    }];
    
}

@end
