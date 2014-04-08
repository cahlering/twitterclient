//
//  TWProfileViewController.h
//  TwitterClient
//
//  Created by Chris Ahlering on 4/2/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWUser.h"

@interface TWProfileViewController : UIViewController<UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) TWUser *user;

@end
