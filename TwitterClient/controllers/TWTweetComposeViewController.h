//
//  TWTweetComposeViewController.h
//  TwitterClient
//
//  Created by Chris Ahlering on 3/30/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../models/TWUser.h"
#import "UIImageView+AFNetworking.h"

@interface TWTweetComposeViewController : UIViewController

@property (strong, nonatomic) TWUser *currentUser;

@end
