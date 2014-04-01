//
//  TWTweetComposeViewController.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/30/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWTweetComposeViewController.h"
#import "../clients/TWAPIClient.h"
#import "../models/TWTweetContainer.h"

@interface TWTweetComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *statusInput;
@property (weak, nonatomic) IBOutlet UILabel *inReplyLabel;

@end

@implementation TWTweetComposeViewController

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
    self.nameLabel.text = _currentUser.name;
    self.usernameLabel.text = _currentUser.screenName;
    NSURL *profileImageURL = [NSURL URLWithString:_currentUser.profileImage];
    NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:profileImageURL];

    UIImage *placeHolderImage = [UIImage imageNamed:@"loading"];
    [self.profileImage setImageWithURLRequest:profileImageRequest placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImage.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        nil;
    }];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (_inReplyTo) {
        self.inReplyLabel.hidden = NO;
        self.statusInput.text = [NSString stringWithFormat:@"@%@ ", _inReplyTo.user.screenName];
        [self.statusInput becomeFirstResponder];
    } else {
        self.inReplyLabel.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelCompose:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitStatus:(id)sender
{
    if (_inReplyTo) {
        [[TWAPIClient instance]tweetAsReply:self.statusInput.text replyToId:_inReplyTo.idString :^(TWTweet *tweet) {
            [[TWTweetContainer instance].tweets insertObject:tweet atIndex:0];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    } else {
        [[TWAPIClient instance]tweet:self.statusInput.text :^(TWTweet *tweet) {
            [[TWTweetContainer instance].tweets insertObject:tweet atIndex:0];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

@end
