//
//  TWTweetComposeViewController.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/30/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWTweetComposeViewController.h"
#import "../clients/TWAPIClient.h"

@interface TWTweetComposeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextView *statusInput;

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
    [[TWAPIClient instance]tweet:self.statusInput.text :^(TWTweet *tweet) {
        //need a delegate to pass this to the home view
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
