//
//  TWMenuController.m
//  TwitterClient
//
//  Created by Chris Ahlering on 4/8/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWMenuController.h"
#import "TWAPIClient.h"
#import "TWTweetContainer.h"
#import "UIImageView+AFNetworking.h"
#import "TWProfileViewController.h"
#import "TWTimelineTableViewController.h"

@interface TWMenuController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;

- (IBAction)onProfileTap:(UITapGestureRecognizer *)sender;
- (IBAction)onHomeTap:(UITapGestureRecognizer *)sender;
- (IBAction)onMentionsTap:(UITapGestureRecognizer *)sender;
@end

@implementation TWMenuController

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

    TWAPIClient *client = [TWAPIClient instance];
    if (self.user == nil) {
        [client currentUser:^(TWUser *user) {
            self.user = user;
            [self initializeView];
        }];
    } else {
        [self initializeView];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) initializeView
{
    
    self.profileNameLabel.text = [NSString stringWithFormat:@"%@", _user.name];
    
    UIImage *placeHolderImage = [UIImage imageNamed:@"loading"];
    NSURLRequest *profileDetailImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_user.profileImage]];
    [self.profileImage setImageWithURLRequest:profileDetailImageRequest placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        nil;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onProfileTap:(UITapGestureRecognizer *)sender {
    [_myNavigationController showProfileView];
}

- (IBAction)onHomeTap:(UITapGestureRecognizer *)sender {
    [_myNavigationController showTimelineView:HOME];
}

- (IBAction)onMentionsTap:(UITapGestureRecognizer *)sender {
    [_myNavigationController showTimelineView:MENTION];
}
@end
