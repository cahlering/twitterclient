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
#import "UIImageView+AFNetworking.h"
#import "TWAPIClient.h"

@interface TWProfileViewController ()

@property (strong, nonatomic) NSMutableArray *childViewControllers;
@property (weak, nonatomic) IBOutlet UILabel *tweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileDetailImage;
@property (weak, nonatomic) IBOutlet UIScrollView *profileScrollView;
@property (weak, nonatomic) IBOutlet UIView *profileDetailImageView;
@property (weak, nonatomic) IBOutlet UIView *profileDetailLabelView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

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

- (void) initializeView
{
    
    [self.navigationController setNavigationBarHidden:NO];
    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@", _user.screenName];
    self.tweetCountLabel.text = [NSString stringWithFormat:@"%ld", _user.tweetsCount];
    self.followersCountLabel.text = [NSString stringWithFormat:@"%ld", _user.followersCount];
    self.followingCountLabel.text = [NSString stringWithFormat:@"%ld", _user.friendsCount];
    self.descriptionLabel.text = _user.description;
    self.locationLabel.text = _user.location;
    self.websiteLabel.text = _user.url;
    
    UIImage *placeHolderImage = [UIImage imageNamed:@"loading"];
    NSURLRequest *profileDetailImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_user.profileImage]];
    [self.profileDetailImage setImageWithURLRequest:profileDetailImageRequest placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileDetailImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        nil;
    }];

    TWAPIClient *client = [TWAPIClient instance];
    [client getProfileBannersWithScreenName:_user.screenName :^(TWUserBannerImages *images) {
        [self setBannerImageWithString:images.sizes[@"mobile_retina"][@"url"]];
    } :^{
        [self setBannerImageWithString:_user.profileBackgroundImageUrl ];
    }];
    
    self.profileScrollView.contentSize = CGSizeMake(self.profileScrollView.frame.size.width * 2, self.profileScrollView.frame.size.height);
}

- (void) setBannerImageWithString :(NSString *)bannerImage
{
    UIImage *placeHolderImage = [UIImage imageNamed:@"loading"];
    NSURLRequest *profileBackgroundImageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:bannerImage]];
    [self.profileImageView setImageWithURLRequest:profileBackgroundImageRequest placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImageView.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        ;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    int page = floor(offset);
    
    self.pageControl.currentPage = page;
}

- (IBAction)onPageControlAction:(UIPageControl *)sender {
    int page = sender.currentPage;
    CGRect frame = self.profileScrollView.frame;
    frame.origin.x = self.profileScrollView.frame.size.width * page;
    [self.profileScrollView scrollRectToVisible:frame animated:YES];
}
@end


