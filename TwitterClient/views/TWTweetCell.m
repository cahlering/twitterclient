//
//  TWTweetCell.m
//  TwitterClient
//
//  Created by Chris Ahlering on 3/29/14.
//  Copyright (c) 2014 Chris Ahlering. All rights reserved.
//

#import "TWTweetCell.h"
#import "UIImageView+AFNetworking.h"

@interface TWTweetCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageControl;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyImage;
@property (weak, nonatomic) IBOutlet UIImageView *retweetImage;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteImage;
    
@end

@implementation TWTweetCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTweet:(TWTweet *)tweet
{
    _tweet = tweet;
    
    self.tweetLabel.text = tweet.text;

    self.screenNameLabel.text = [NSString stringWithFormat:@"@%@",tweet.user.screenName];
    self.nameLabel.text = tweet.user.name;
    NSURL *profileImageURL = [NSURL URLWithString:self.tweet.user.profileImage];
    NSURLRequest *profileImageRequest = [NSURLRequest requestWithURL:profileImageURL];
    UIImage *placeHolderImage = [UIImage imageNamed:@"loading"];
    
    if (tweet.favorited) self.favoriteImage.image = [UIImage imageNamed:@"favorite_on"];
    if (tweet.retweeted) self.retweetImage.image = [UIImage imageNamed:@"retweet_on"];
    self.timeLabel.text = tweet.createdAt.description;

    
    [self.profileImageControl setImageWithURLRequest:profileImageRequest placeholderImage:placeHolderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.profileImageControl.image = image;
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        nil;
    }];

}

@end
