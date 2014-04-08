//
//  TWHamburgerMenuController.m
//  TwitterClient
//
//  Created by Chris Ahlering on 4/7/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWHamburgerMenuController.h"
#import "TWProfileViewController.h"
#import "TWTimelineTableViewController.h"

@interface TWHamburgerMenuController ()

@property (nonatomic) int selectedViewControllerIndex;
@property (nonatomic) BOOL profileDisplayed;
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic, strong) UIViewController *lastSelectedViewController;
@property (nonatomic, strong) NSMutableArray *viewControllers;

- (IBAction)onPanAction:(UIPanGestureRecognizer *)sender;
@end

@implementation TWHamburgerMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        TWTimelineTableViewController *timelineVC = [[TWTimelineTableViewController alloc] init];
        _viewControllers = [NSMutableArray array];
        [_viewControllers addObject:timelineVC];
        self.selectedViewControllerIndex = 0;
        
        TWProfileViewController *profileVC = [[TWProfileViewController alloc]init];
        [_viewControllers addObject:profileVC];
        self.lastSelectedViewController = profileVC;
        
        [self addChildViewController:timelineVC];
        [timelineVC didMoveToParentViewController:self];
        [self setSelectedViewController:timelineVC];
        _profileDisplayed = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    for (UIViewController *viewController in _viewControllers) {
        [self.view addSubview:[viewController view]];
    }
    UIView *initialView = [[self getSelectedViewController] view];
    [self.view bringSubviewToFront:initialView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *) getSelectedViewController
{
    return (UIViewController *)[self.viewControllers objectAtIndex:self.selectedViewControllerIndex];
}

- (void)setSelectedViewController:(UIViewController *)newlySelectedViewController
{
    if(![self.viewControllers containsObject:newlySelectedViewController]) {
        return;
    }
    self.selectedViewControllerIndex = [self.viewControllers indexOfObject:newlySelectedViewController];
    
    UIViewController *currentController = [self selectedViewController];
    
    if([self isViewLoaded]) {
        [[currentController view] removeFromSuperview];
        
        UIView *newView = newlySelectedViewController.view;
        [newView setFrame:CGRectMake(0, 0, currentController.view.frame.size.width, currentController.view.frame.size.height)];
        [newView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
        [self.view addSubview:newView];
    }
    self.lastSelectedViewController = currentController;
}

- (IBAction)onPanAction:(UIPanGestureRecognizer *)recognizer {
    UIView *panningView = [[self getSelectedViewController]view];
    CGPoint point    = [recognizer translationInView:self.view];
    CGPoint velocity = [recognizer velocityInView:panningView];
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        float panX = point.x;
        NSLog(@"%d - %f", recognizer.state , panX);
        panningView.frame = CGRectMake(panningView.frame.origin.x + panX, 0, panningView.frame.size.width, panningView.frame.size.height);
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat viewWidth = panningView.frame.size.width;
        float endX = (velocity.x > 0) ? viewWidth : -viewWidth;
        if (_profileDisplayed) {
            endX = 0;
        }
        [UIView animateWithDuration:.5 animations:^{
            panningView.frame = CGRectMake(endX, 0, viewWidth, panningView.frame.size.height);
            _profileDisplayed = !_profileDisplayed;
        }];
    }
}

@end
