//
//  TWProfileViewController.m
//  TwitterClient
//
//  Created by Chris Ahlering on 4/2/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWProfileViewController.h"
#import "TWTimelineTableViewController.h"
#import "TWLandingViewController.h"

@interface TWProfileViewController ()

@property (strong, nonatomic) NSMutableArray *childViewControllers;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGesture;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

- (IBAction)profileContentChange:(id)sender;

@end

@implementation TWProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController setNavigationBarHidden:NO];
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", _user.screenName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPan:(UIPanGestureRecognizer *)recognizer {

    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];

}

- (IBAction)profileContentChange:(id)sender {
    
}
@end


