//
//  TWUserBannerImages.h
//  TwitterClient
//
//  Created by Chris Ahlering on 4/7/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "MUJSONResponseSerializer.h"

@interface TWUserBannerImages : MUJSONResponseObject

@property (nonatomic, strong) NSDictionary *sizes;

@end
