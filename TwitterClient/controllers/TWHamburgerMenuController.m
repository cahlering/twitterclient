//
//  TWHamburgerMenuController.m
//  TwitterClient
//
//  Created by Chris Ahlering on 4/7/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWHamburgerMenuController.h"
#import "TWMenuController.h"
#import "TWProfileViewController.h"
#import "TWTimelineTableViewController.h"

@interface TWHamburgerMenuController ()

@property (nonatomic) BOOL menuDisplayed;
@property (nonatomic, strong) TWTimelineTableViewController *timelineVC;
@property (nonatomic, strong) TWMenuController *menuVC;
@property (nonatomic, strong) TWProfileViewController *profileVC;

- (IBAction)onPanAction:(UIPanGestureRecognizer *)sender;
@end

@implementation TWHamburgerMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _timelineVC = [[TWTimelineTableViewController alloc] init];
        _viewControllers = [NSMutableArray array];
        [_viewControllers addObject:_timelineVC];
        
        _menuVC = [[TWMenuController alloc]init];
        [_menuVC setMyNavigationController:self];
        [_viewControllers addObject:_menuVC];

        _profileVC = [[TWProfileViewController alloc]init];
        [_viewControllers addObject:_profileVC];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:[_menuVC view]];
    [self.view addSubview:[_timelineVC view]];
    
    UIView *initialView = [_timelineVC view];
    [self.view bringSubviewToFront:initialView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPanAction:(UIPanGestureRecognizer *)recognizer {
    UIView *panningView = [_timelineVC view];
    CGPoint point    = [recognizer translationInView:panningView];
    CGPoint velocity = [recognizer velocityInView:panningView];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        panningView.center = CGPointMake(panningView.center.x + point.x, panningView.center.y + point.y);
        [recognizer setTranslation:CGPointMake(0, 0) inView:panningView];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat viewWidth = panningView.frame.size.width;
        float endX = (velocity.x > 0) ? viewWidth * 1.5 : -viewWidth / 2;
        if (_menuDisplayed) {
            endX = viewWidth / 2;
        }
        [UIView animateWithDuration:.5 animations:^{
            NSLog(@"%d - %f", recognizer.state, endX );
            panningView.center = CGPointMake(endX , panningView.frame.size.height / 2);
            _menuDisplayed = !_menuDisplayed;
        }];
    }
}

- (void)showTimelineView:(TimelineType)type
{
    [self willMoveToParentViewController:_timelineVC];
    [_timelineVC timelineType:type];

    [self addChildViewController:_timelineVC];
    [self.view bringSubviewToFront:_timelineVC.view];
    [UIView animateWithDuration:.5 animations:^{
        _timelineVC.view.center = CGPointMake(_timelineVC.view.frame.size.width / 2,
                                              _timelineVC.view.frame.size.height / 2);
    } completion:^(BOOL finished) {
        [self didMoveToParentViewController:_timelineVC];
        _menuDisplayed = NO;
    }];
    
    _menuDisplayed = NO;
    
    
}

- (void)showProfileView
{
    [self.navigationController pushViewController:_profileVC animated:YES];
    
}

- (void)showMenuView
{
    [self willMoveToParentViewController:_menuVC];
    [self addChildViewController:_menuVC];
    [self.view addSubview:_menuVC.view];
    [self.view bringSubviewToFront:_menuVC.view];
    [self didMoveToParentViewController:_menuVC];
    _menuDisplayed = YES;
}

@end
