//
//  TWTweet.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWTweet.h"

@implementation TWTweet
-(id)init {
    if (self = [super init]) {
        self.propertyMap = @{
                             @"id_str": @"idString"
                             };
    }
    return self;
}

@end
