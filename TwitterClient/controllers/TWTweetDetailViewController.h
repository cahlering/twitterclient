//
//  TWTweetDetailViewController.h
//  TwitterClient
//
//  Created by Chris Ahlering on 3/30/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../models/TWTweet.h"

@interface TWTweetDetailViewController : UIViewController

@property (weak, atomic) TWTweet *tweet;

@end
