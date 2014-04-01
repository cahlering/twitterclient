//
//  TWTweetCell.h
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../models/TWTweet.h"

@interface TWTweetCell : UITableViewCell

@property (weak, nonatomic) TWTweet *tweet;

-(CGFloat) cellHeight;

@end
