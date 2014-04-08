//
//  TWUser.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWUser.h"

@implementation TWUser

-(id)init {
    if (self = [super init]) {
        self.propertyMap = @{
                             @"screen_name": @"screenName",
                             @"profile_image_url": @"profileImage",
                             @"profile_background_image_url": @"profileBackgroundImageUrl",
                             @"followers_count": @"followersCount",
                             @"favorites_count": @"favoritesCount",
                             @"statuses_count": @"tweetsCount",
                             @"friends_count": @"friendsCount",
                             @"profile_banner_url": @"profileBannerUrl"
                             };
    }
    return self;
}
@end
