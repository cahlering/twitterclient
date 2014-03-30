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
                             @"profile_image_url": @"profileImage"
                             };
    }
    return self;
}
@end
