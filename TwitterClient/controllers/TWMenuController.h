//
//  TWMenuController.h
//  TwitterClient
//
//  Created by Chris Ahlering on 4/8/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWUser.h"
#import "TWHamburgerMenuController.h"

@interface TWMenuController : UIViewController

@property (strong, nonatomic) TWUser *user;
@property (strong, nonatomic) TWHamburgerMenuController *myNavigationController;

@end
