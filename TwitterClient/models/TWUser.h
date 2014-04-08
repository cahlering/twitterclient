//
//  TWUser.h
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "MUJSONResponseSerializer.h"
#import "TWUserBannerImages.h"

@interface TWUser : MUJSONResponseObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *location;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *profileImage;
@property (strong, nonatomic) NSString *profileBannerUrl;
@property (strong, nonatomic) NSString *profileBackgroundImageUrl;
@property (nonatomic) long tweetsCount;
@property (nonatomic) long followersCount;
@property (nonatomic) long friendsCount;
@property (nonatomic) long favoritesCount;
@property (strong, nonatomic) TWUserBannerImages *bannerImages;

@end
