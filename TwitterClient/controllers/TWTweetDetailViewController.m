//
//  TWTweetDetailViewController.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/30/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWTweetDetailViewController.h"
#import "TWTweetComposeViewController.h"
#import "UIImageView+AFNetworking.h"
#import "../clients/TWAPIClient.h"
#import "MBAlertView.h"

@interface TWTweetDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImage;


@end

@implementation TWTweetDetailViewController

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
    self.title = @"Tweet";
    self.tweetLabel.text = _tweet.text;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@",_tweet.user.screenName];
    self.nameLabel.text = _tweet.user.name;
    if (_tweet.favorited) self.favoriteImage.image = [UIImage imageNamed:@"favorite_on"];
    self.favoritesCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.favoriteCount];
    if (_tweet.retweeted) self.retweetImage.image = [UIImage imageNamed:@"retweet_on"];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.retweetCount];
    
    NSURL *profileImageURL = [NSURL URLWithString:self.tweet.user.profileImage];
    NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:profileImageURL];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"M/d/YY, HH:mm a"];
    self.timeLabel.text = [df stringFromDate:_tweet.createdAt];
    
    UIImage *placeHolderImage = [UIImage imageNamed:@"loading"];
    [self.profileImage setImageWithURLRequest:profileImageRequest placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        nil;
    }];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [[TWAPIClient instance] getTweet:_tweet.idString :^(TWTweet *tweet) {
        _tweet = tweet;
    }];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)retweet:(id)sender {
    if (_tweet.retweeted) {
        [[TWAPIClient instance] unReTweet:_tweet :^(TWTweet *tweet) {
            self.retweetImage.image = [UIImage imageNamed:@"retweet"];
            _tweet.retweetCount--;
            self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.retweetCount];
        }];
    } else {
        [[TWAPIClient instance] reTweet:_tweet :^(TWTweet *tweet) {
            self.retweetImage.image = [UIImage imageNamed:@"retweet_on"];
            _tweet.retweetCount++;
            self.retweetCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.retweetCount];
        }];
    }
}

- (IBAction)favorite:(id)sender {
    [[TWAPIClient instance] favorite:_tweet remove:_tweet.favorited :^(TWTweet *tweet) {
        _tweet.favorited = !_tweet.favorited; //per the api documentation (https://dev.twitter.com/docs/api/1.1/post/favorites/create), the returned tweet may not accurately reflect the favorited status, so set it manually
        if (_tweet.favorited) {
            self.favoriteImage.image = [UIImage imageNamed:@"favorite_on"];
            _tweet.favoriteCount++;
            self.favoritesCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.favoriteCount];

        } else {
            self.favoriteImage.image = [UIImage imageNamed:@"favorite"];
            _tweet.favoriteCount--;
            self.favoritesCountLabel.text = [NSString stringWithFormat:@"%ld", _tweet.favoriteCount];
        }
    }];
}

- (IBAction)reply:(id)sender {
    TWTweetComposeViewController *composeViewController = [[TWTweetComposeViewController alloc] initWithNibName:@"TWTweetComposeViewController" bundle:nil];
    
    [composeViewController setCurrentUser:self.currentUser];
    [composeViewController setInReplyTo:_tweet];
    [self.navigationController pushViewController:composeViewController animated:YES];
//    MBAlertView* alert = [MBAlertView alertWithBody:@"Coming soon" cancelTitle:nil cancelBlock:nil];
//    [alert addButtonWithText:@"Dismiss" type:MBAlertViewItemTypePositive block:^{}];
//    [alert addToDisplayQueue];
    
}
@end
