//
//  TWHamburgerMenuController.h
//  TwitterClient
//
//  Created by Chris Ahlering on 4/7/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTweetContainer.h"

@interface TWHamburgerMenuController : UIViewController

@property (nonatomic, strong) NSMutableArray *viewControllers;

- (void)showTimelineView :(TimelineType)type;

- (void)showProfileView;

- (void)showMenuView;

@end
